/*
	Author: 
		Karel Moricky, improved by Killzone_Kid

	Description:
		Move given unit to given respawn position. Units moved to height >= 30m will start on parachute. Position [0,0,0] is blacklisted
		This function must be executed where unit to be moved is local

	Parameter(s):
		0: OBJECT
		1:
			STRING - Move to marker position. Marker size will be used for random placement area and marker direction for unit direction
			OBJECT - Unit, Group or Vehicle. Move to the object position or inside an object if the object is a vehicle, or if group or unit 
				is in vehicle and there is an empty seat
			ARRAY - Move to precise [x,y,z] position AGL. [x,y] array will be converted to [x,y,0]
		2: BOOLEAN (OPTIONAL) - Can be dead:
			TRUE (DEFAULT) - Moved unit and/or object to which unit is moved can be dead
			FALSE - Both moved unit and vehicle or unit at position (if any) must be alive

	Returns:
		BOOL - false: failed, true: succeeded
*/

#define SPAWN_RADIUS 5
#define SPAWN_PARACHUTE_HEIGHT 30 //--- minimum height for parachute, borderline suicidal
#define SPAWN_OFFSET 1.5

params 
[
	["_unit", objNull, [objNull]],
	["_position", false, [[], "", objNull, grpNull]],
	["_canBeDead", true, [true]]
];

try
{
	if (isNull _unit) throw "unit is undefined";
	if (!local _unit) throw "unit is not local";
	
	//--- optional: if dead are not allowed, check if unit is dead
	if (!_canBeDead && !alive _unit) exitWith {false}; //--- unit is dead, abort quietly
	
	if (_position isEqualTo false) throw "position is undefined";
	
	if (_position isEqualType grpNull) then {_position = leader _position};
	if (_position isEqualType objNull) then {_position = vehicle _position};
	
	_position call
	{
		//--- vehicle of the leader
		if (_this isEqualType objNull) exitWith
		{	
			//--- optional: if dead are not allowed, check if object is dead
			if (!_canBeDead && {!isNull _this && !alive _this}) exitWith {false}; //--- no error, it is a feature
			
			if (_unit moveInAny _this) exitWith {true}; //--- success
			
			if (isNull _this) throw "position is undefined"; //--- failed because vehicle is no more?
			
			//--- try to move next to the object
			
			private _zPos = (ASLToAGL getPosASL _this) select 2;
			private _bb = boundingBox _this;
			private _moveDirectionSelect = speed _this < 0 && !(_this isKindOf "CAManBase");
			
			if (_zPos >= SPAWN_PARACHUTE_HEIGHT) exitWith //--- vehicle high in the air, move in parachute
			{
				private _spawnPos = _this modelToWorldVisual  //--- get spawn position now, to make it more robust in scheduled
				[
					SPAWN_RADIUS / 2 - random SPAWN_RADIUS, 
					(_bb select _moveDirectionSelect select 1), //--- avoid appearing in front of a moving vehicle
					(_bb select 0 select 2) * 1.25 //--- spawn under the flying vehicle to avoid collision
				];
				
				if (_spawnPos isEqualTo [0,0,0]) throw "position is undefined"; //--- still valid?
				
				isNil //--- atomic, move unit into parachute as soon as possible
				{
					private _para = createVehicle ["Steerable_Parachute_F", _spawnPos, [], 0, "CAN_COLLIDE"];
					_para setDir (_para getDir _this);
					_unit moveInDriver _para;
					_para setVelocity velocity _this;
				};
				
				true
			};
			
			//--- vehicle is on the ground, move next to it
			
			private _offset = (getPos _this distance getPosVisual _this) + SPAWN_OFFSET;
			private _spawnPos = (_this getRelPos [ //--- get spawn position now, to make it more robust in scheduled
				(_bb select _moveDirectionSelect select 1) 
				+ 
				([-_offset, _offset] select _moveDirectionSelect), //--- avoid appearing in front of a moving vehicle
				linearConversion [0, 100, round random 100, -15, 15]
			]) vectorAdd [0, 0, _zPos];
			
			if (isNil "_spawnPos" || {_spawnPos isEqualTo [0,0,0]}) throw "position is undefined"; //--- make sure we have position
			
			_unit setVehiclePosition [_spawnPos, [], 0, "NONE"];
			_unit setDir (_unit getDir _this);
			
			true
		};
		
		//--- marker
		if (_this isEqualType "") exitWith
		{
			private _markerPos = markerPos _this; //--- get spawn position now, to make it more robust in scheduled
			
			if (_markerPos isEqualTo [0,0,0]) throw "position is undefined or blacklisted"; //--- blacklisted [0,0,0] or null marker
			
			markerSize _this params ["_markerX", "_markerY"];
			_unit setDir markerDir _this;
			_unit setVehiclePosition [_markerPos, [], (_markerX * _markerY) / 2, "NONE"];
			
			true
		};
		
		//--- array [x,y] add z = 0
		if (_this isEqualTypeArray [0,0]) then {_this = _this + [0]};
		
		//--- balcklist [0,0,0]
		if (_this isEqualTo [0,0,0]) throw "position [0,0,0] is blacklisted";
		
		//--- array [x,y,z]
		if (_this isEqualTypeArray [0,0,0]) exitWith
		{
			if (_this select 2 >= SPAWN_PARACHUTE_HEIGHT) exitWith 
			{
				isNil //--- atomic, move unit into parachute as soon as possible
				{
					private _para = createVehicle ["Steerable_Parachute_F", _this, [], 0, "CAN_COLLIDE"]; //--- use precise position
					_para setDir getDir _unit;
					_unit moveInDriver _para;
				};
				
				true
			};
			
			//--- use precise position
			_unit setPosASL AGLToASL _this;
			
			true
		};
		
		//--- bad array
		throw "position format is wrong";
	};
}
catch
{
	//--- optional error message
	["Respawn %1, function call is aborted. Input: %2", _exception, _this] call BIS_fnc_error;
	
 	false
};