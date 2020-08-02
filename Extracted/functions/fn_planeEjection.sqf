/*
	Author: Bravo Zero One development
	- John_Spartan

	Description:
	- This function is designed to implement semi-authenthic ejection system on fixed wing aircrfat that have such functionality enabled/configured.

	Exucution:
	- Call the function via user action added to the aircrfat itself.

			class Plane_Eject_UserActionExample
			{
				priority = 0.05;
				shortcut = "Eject";
				displayName = "$STR_A3_action_eject";
				condition = "player in this";
				statement = "[this] call BIS_fnc_planeEjection";
				position = "pilotcontrol";
				radius = 10;
				onlyforplayer = 1;
				showWindow = 0;
		                hideOnUse = 1;
			};

	Requirments:
	- Compatible aircrfat must have a config definition for all sub-sytems that will be invoked by this function.
		1. Old legacy ejection must be disabled in aircrfat's cfgVehicles configuration.
		driverCanEject = 0;
		gunnerCanEject = 0;
		cargoCanEject = 0;

		2. Aircrfat must have a set of parameters defined in CfgVehicles subClass (EjectionSystem) for ejection system. Theese parameters will affect the ejection behaviour.
		example of cfgVehicles subclass definitions;

		class EjectionSystem
		{
			EjectionSeatEnabled = 1;										//enable advanced ejection system
			EjectionDual = 0;											//currently only single seat aircraft ejectiion supported (to do for latter)
			EjectionSeatClass = "B_Ejection_Seat_Plane_Fighter_01_F";								//class name of ejector seat to use (separate vehicle/object)
			CanopyClass = "Plane_Fighter_01_Canopy_F";								//class name of canopy to use (separate vehicle/object)
			EjectionSeatHideAnim = "ejection_seat_hide";								//name of the hide animation that will hide ejector seat mesh in plane
			EjectionSeatRailAnim = "ejection_seat_motion";								//name of the animation that will be played to start a smooth ejection motion out of cockpit
			CanopyHideAnim = "canopy_hide";										//name of the hide animation that will hide canopy mesh in plane
			EjectionSeatPos = "pos_eject";										//position memory point whwre to attach ejector seat
			CanopyPos = "pos_eject_canopy";										//position memory point where to attach dummy canopy
			EjectionSoundExt = "Plane_Fighter_01_ejection_ext_sound";						//sound to play when ejection trigered (external)
			EjectionSoundInt = "Plane_Fighter_01_ejection_in_sound";						//sound to play when ejection trigered (in-ternal)
			EjectionParachute = "Steerable_Parachute_F";								//class name parachute used in ejection
			EjectionSeatForce = 50;											//ejection seat blast force
			CanopyForce = 30;											//canopy bast force

		};

		3. Aircrfat model must have momory points definig positions where to attach new vehicle ejector seat, new vehicle canopy.
		4. Aircrfat model (in model cfg & class AnimationSources) must have a set of hide animations defined to hide ejector seat and canopy in model when new seaparate vehicles are spawned.

		In model.cfg
		class canopy_hide
		{
			type="hide";
			source="user";
			selection="canopy_hide";
			minValue = 0.0;
			maxValue = 1.0;
			minPhase = 0.0;
			maxPhase = 1.0;
			initPhase = 0;
			hideValue = 0.001;
		};

		class ejection_seat_hide
		{
			type="hide";
			source="user";
			selection="ejection_seat";
			minValue = 0.0;
			maxValue = 1.0;
			minPhase = 0.0;
			maxPhase = 1.0;
			initPhase = 0;
			hideValue = 0.001;
		}

		In cfgVehicles >> class AnimationSources
		class canopy_hide
		{
			source = "user";
			animPeriod = 0.001;
			initPhase = 0;
		};

		class ejection_seat_hide
		{
			source = "user";
			animPeriod = 0.001;
			initPhase = 0;
		};

		5. Aircrfat model must have an animation for initial ejection stage, where new ejector seat with pilot is pushed gradualy out of cockpit (done to avaoid PhysX colisions and make this feature look good, rathre than spawnig ejetor seat above plane).
		New ejector seat with pilot will be attached to this animation (via animated meory point).
		Memory point EjectionSeatPos must be part of this animated selection.

		In model.cfg
		class ejection_seat_motion
		{
			type = "translation";
			source = "user";
			selection = "ejection_seat";
			begin = "tns_ejection_seat";
			end = "tns_ejection_seat_e";
			animPeriod = 0;
			memory = 1;
			minValue = 0.0;
			maxValue = 1.0;
			offset0 = 0.0;
			offset1 = 3.0;
		};

		In cfgVehicles >> class AnimationSources
		class ejection_seat_motion
		{
			source = "user";
			animPeriod = 0.25;
			initPhase = 0;
		};

		6. Ejector seat and canopy must be created/defined as separate objects. Can be reused.

	Parameter(s):
		_this select 0: mode (Scalar)
		0: plane/object

		other parameters are gathered from configuration files.

	Returns: nothing
	Result: Pilot will be ejected from aircraft. Semi-authenthic behaviour.

*/

#define DISPOSE_ASSETS			if (!isNil{_canopy} && {!isNull _canopy}) then {_canopy setDamage 1;addToRemainsCollector [_canopy]}; if (!isNil{_ejectionSeat} && {!isNull _ejectionSeat}) then {addToRemainsCollector [_ejectionSeat]}
//#define DISPOSE_ASSETS			if (!isNil{_ejectionSeat} && {!isNull _ejectionSeat}) then {addToRemainsCollector [_ejectionSeat]}

private _plane = param [0,objNull];

if (isNull _plane || {!alive _plane || {unitIsUAV _plane || {speed _plane < 1}}}) exitWith {};

if (_plane getVariable ["bis_ejected",false]) exitWith {};
_plane setVariable ["bis_ejected",true];

_plane spawn
{
	private _plane = _this;
	private _pilot = driver _plane;

	private _fnc_handleEjectionSeat =
	{
		//["[x] Ejection seat '%1' crash tracking initiated! Crew: %2",_this,crew _this] call bis_fnc_logFormat;

		private _timeout = time + 60;

		private _velocity = velocity _this select 2;
		private _pilot = (crew _this) param [0, objNull];

		//detect crash
		waitUntil
		{
			_velocity = velocity _this select 2;
			_pilot = (crew _this) param [0, objNull];

			time > _timeout || {(_velocity < 0.05 && {getPos _pilot select 2 < 2})}
		};


		if (time > _timeout) exitWith {};

		//["[x] Ejection seat '%1' with crew %4 crashed to the ground! Delta change: %2 -> %3",_this,_deltaPrev,_delta,crew _this] call bis_fnc_logFormat;

		//lower the velocity to reduce bound effect
		_this setVelocity (velocity _this apply {_x / 2});

		//kill pilot
		if (!isNull _pilot) then
		{
			moveOut _pilot;
			_pilot setDamage 1;
		};

		//destroy the seat so it can be collected by garbage collector
		_this setDamage 1;
	};

	if (isNull _plane || {!alive _plane || {isNull _pilot || {!alive _pilot}}}) exitWith {};

	//["[i] Ejecting from plane: %1",_plane] call bis_fnc_logFormat;

	private _configPath = configFile >> "CfgVehicles" >> typeOf _plane >> "EjectionSystem";
	private _ejectionSeatEnabled = getNumber (_configPath >> "EjectionSeatEnabled"); if (_ejectionSeatEnabled == 0) exitWith {};

	private _canopyHideAnim = getText (_configPath >> "CanopyHideAnim"); if (_plane animationPhase _canopyHideAnim > 0.01) exitWith {};
	private _ejectionSeatClass = getText (_configPath >> "EjectionSeatClass");
	private _ejectionSeatHideAnim = getText (_configPath >> "EjectionSeatHideAnim");
	private _ejectionSeatRailAnim = getText (_configPath >> "EjectionSeatRailAnim");
	private _ejectionSeatForce = getNumber (_configPath >> "EjectionSeatForce");
	private _canopyForce = getNumber (_configPath >> "canopyForce");
	private _canopyClass = getText (_configPath >> "canopyClass");
	private _canopyExplodes = getNumber (_configPath >> "canopyExplodes") == 1;
	private _ejectionParachute = getText (_configPath >> "EjectionParachute");

	private _memoryPointEjectionSeat = getText (_configPath >> "EjectionSeatPos");
	private _memoryPointCanopy = getText (_configPath >> "CanopyPos");

	/*--------------------------------------------------------------------------------------------------

		Blast off the canopy first

	--------------------------------------------------------------------------------------------------*/

	//hide canopy on plane
	_plane animate [_canopyHideAnim,1,true];

	if (!_canopyExplodes) then
	{
		//create and position canopy
		private _canopy = createVehicle [_canopyClass, [100,100,100],[],0,"CAN_COLLIDE"];
		_canopy allowDamage false;
		_plane disableCollisionWith _canopy;

		private _canopyPos = _plane modelToWorldWorld ((_plane selectionPosition _memoryPointCanopy) vectorAdd [0,0,2]);
		_canopy setPosWorld _canopyPos;
		_canopy setVectorDirAndUp [vectorDir _plane, vectorUp _plane];

		private _planeVelocityModelSpace = velocityModelSpace _plane;
		_canopy setVelocityModelSpace ((_planeVelocityModelSpace apply {_x/10}) vectorAdd [0,-0.2 * _canopyForce,_canopyForce]);
		_canopy addTorque (_canopy vectorModelToWorld [-1000,0,0]);
	};

	/*--------------------------------------------------------------------------------------------------

		Eject the pilot in the ejection seat

	--------------------------------------------------------------------------------------------------*/
	if (isNull _plane || {!alive _plane}) exitWith {DISPOSE_ASSETS};

	//hide ejection seat on plane
	_plane animate [_ejectionSeatHideAnim,1,true];

	//make pilot invulnerable for the transition time
	private _wasVulnerable = isDamageAllowed _pilot;

	if (_wasVulnerable) then
	{
		_pilot allowDamage false;
	};

	//create and position ejection seat
	private _ejectionSeat = createvehicle [_ejectionSeatClass,[0,0,1000],[],0,"CAN_COLLIDE"];

	//_plane disableCollisionWith _ejectionSeat;
	//_ejectionSeat disableCollisionWith _plane;

	_ejectionSeat attachTo [_plane,[0,0,2],_memoryPointEjectionSeat];

	//move pilot to ejection seat and lock it
	waitUntil{moveOut _pilot; vehicle _pilot != _plane};
	waitUntil{_pilot moveInCargo _ejectionSeat; vehicle _pilot == _ejectionSeat};
	 _ejectionSeat lock 2;

	//["[x] Pilot %1 in ejection seat %2: %3",_pilot,_ejectionSeat,_pilot in _ejectionSeat] call bis_fnc_logFormat;

	//do rail animation and particle effects
	_plane animate [_ejectionSeatRailAnim,1];
	waitUntil{_plane animationPhase _ejectionSeatRailAnim > 0.75};

	detach _ejectionSeat; waitUntil{isNull attachedTo _ejectionSeat};

	//make player once more vulnerable
	if (_wasVulnerable) then
	{
		_pilot allowDamage true;
	};


	[_plane,_ejectionSeat] spawn BIS_fnc_planeEjectionFX;

	//["[x] Ejection seat %1 detached",_ejectionSeat] call bis_fnc_logFormat;

	_planeVelocityModelSpace = velocityModelSpace _plane;
	_ejectionSeat setVelocityModelSpace (_planeVelocityModelSpace apply {_x/10} vectorAdd [0.5,0.5,_ejectionSeatForce]);

	/*--------------------------------------------------------------------------------------------------

		After ejection
		- deploy parachute
		- handle high speed collision with terrain
		- dispose of canopy and seat

	--------------------------------------------------------------------------------------------------*/
	if (isNull _ejectionSeat) exitWith {DISPOSE_ASSETS};

	private ["_ejectionSeatVelocity"];

	//failsafe for low altitude ejections
	_ejectionSeat spawn _fnc_handleEjectionSeat;

	//wait for pilot to descend under 350m
	private _parachuteDeployTime = time + 1;

	waitUntil
	{
		_ejectionSeatVelocity = velocity _ejectionSeat;

		!alive _pilot || {!(_pilot in _ejectionSeat) || {(getPos _ejectionSeat select 2 < 350 && {_ejectionSeatVelocity select 2 < -0.5 && {time > _parachuteDeployTime}})}}
	};

	if (!alive _pilot) exitWith {DISPOSE_ASSETS};

	//move pilot out of the ejection seat
	if (_pilot in _ejectionSeat) then
	{
		_ejectionSeat lock 0;
		_ejectionSeat setVelocity (_ejectionSeatVelocity apply {_x/4});

		waitUntil
		{
			moveOut _pilot;
			vehicle _pilot != _ejectionSeat
		};
	};

	//deploy parachute
	if (isPlayer _pilot) then
	{
		disableUserInput true;
	};

	private _parachute = createvehicle [_ejectionParachute,getPos _ejectionSeat,[],0,"CAN_COLLIDE"];
	_parachute setPosWorld (_ejectionSeat modelToWorldWorld [0,0,2.5]);
	_parachute setDir getDir _ejectionSeat;
	waitUntil
	{
		_pilot moveInDriver _parachute;
		_pilot in _parachute
	};
	if !(_pilot in _parachute) then
	{
		_pilot moveInDriver _parachute;
	};
	_parachute lock 2;

	sleep 1;	//to make sure parachute is locked and player cannot use Get Out ;(

	if (isPlayer _pilot) then
	{
		disableUserInput false;
	};

	//activate achievement
	setStatValue ["JetsPunchOut", 1];

	//set state of non-funcional assets
	_plane setFuel 0;
	_plane lock 2;
	unassignVehicle _pilot;
	[_pilot] allowGetIn false;
	sleep 10;

	//dispose of canopy & ejector seat
	DISPOSE_ASSETS;
};