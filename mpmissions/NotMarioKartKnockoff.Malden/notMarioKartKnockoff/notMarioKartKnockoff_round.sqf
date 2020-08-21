/*
NNS
Not Mario Kart Knockoff
Player side round script.
*/

["notMarioKartKnockoff_round.sqf: Start"] call NNS_fnc_debugOutput;

waitUntil {sleep 1; missionNamespace getVariable ["MKK_area", -1] != -1}; //wait for area to be set


fn_setAslZ = { //update ASL position array with offset, used to set proper Z when in building
	params [["_pos", []], ["_ref", objNull], ["_Zoffset", 0]];
	if (count _pos < 3 || {isNull _ref}) exitWith {_pos}; //only compatible with 3D position array
	private _objAsl = ((getPosASL _ref) select 2); //reference object ASL position
	private _posIntersect = lineIntersectsSurfaces [[_pos select 0, _pos select 1, _objAsl + 1], [_pos select 0, _pos select 1, _objAsl - 1]]; //intersection with surface
	if (count _posIntersect > 0) then {_tmp = _posIntersect select 0 select 0; _pos = [_tmp select 0, _tmp select 1, (_tmp select 2) + _Zoffset]; //valid intersection
	} else {_pos set [2, (getTerrainHeightASL _pos) + _Zoffset]}; //update Z with terrain height
	_pos; //return new position
};

fn_pointsUpdate = { //attacker and victim points
	//if balloon mode: remove a point from victim. if steal is true, add a point to attacker
	//if deathmatch mode : add a point to attacker
	params ["_attacker","_victim",["_steal",false]];
	
	if (!(isNull _attacker) && {!(isNull _victim)}) then {
		private _gameMode = MKK_mode; //game mode: -1:vote, 0:random, 1:balloon, 2:deathmatch, 3:team deathmatch, 4:freeplay
		if (_gameMode == 1) then { //balloon mode: remove a point from victim
			private _tmpPoint = _victim getVariable ["MKK_points", 0]; //get victim points
			if (_tmpPoint > 0) then {_victim setVariable ["MKK_points", _tmpPoint - 1, true]}; //only remove a point when victim points over 0
		};
		if (_steal || {_gameMode != 1}) then { //not balloon mode or steal is true, add a point to attacker
			if (_attacker isEqualTo _victim) then {_attacker setVariable ["MKK_points", (_attacker getVariable ["MKK_points", 0]) - 1, true]; //attacker is victim, remove a point
			} else {
				if (!(_steal) || (_steal && {_victim getVariable ["MKK_points", 0] > 0})) then { //attacker not victim, add a point
					if (!(MKK_mode == 3) || (MKK_mode == 3 && {(_attacker getVariable ["MKK_team", -1]) != (_victim getVariable ["MKK_team", -1])})) then { //team deathmatch point fix
						_attacker setVariable ["MKK_points", (_attacker getVariable ["MKK_points", 0]) + 1, true];
					};
				};
			};
		};
	};
};

fn_realSpeed = {((velocity (_this select 0)) vectorDistance [0,0,0]) * 3.6}; //get speed of a object based on its velocity vector

fn_explosion = { //delete original object, spawn a explosion and affect nearby kart
	params ["_object","_vehArray",["_explosionSize", 0]];
	private _objPos = getPos _object; deleteVehicle _object; //get original object position then delete it
	{
		_pos = getPos _x; //position of current kart in array
		_dist = _pos distance2D _objPos; //distance between original object and current kart
		if (_dist < 10 && {!(_x getVariable ["MKK_inv", false])}) then { //under 10m and not invulnerable
			_force = linearConversion [0, 10, _dist, 40, 1, true]; //compute force to apply
			_tmpVec = _objPos vectorFromTo _pos; //force vector
			_x setVelocity [(_tmpVec select 0) * _force, (_tmpVec select 1) * _force, _tmpVec select 2]; //update kart velocity
			if (_dist < 3) then {[player, driver _x] call fn_pointsUpdate}; //under 3 meter, update score
		};
	} forEach _vehArray;
	_explosion = createMine [["Claymore_F","DemoCharge_F","SatchelCharge_F"] select _explosionSize, _objPos, [], 0]; //spawn explosive
	_explosion setDamage 1; //detonate
	sleep 1; deleteVehicle _explosion; //wait 1sec then delete explosion
};

fn_createSound = { //[_source,"_class"] call fn_createSound
	params ["_source","_class",["_duration",15],["_attach",true]];
	_durationIndex = MKK_itemSoundClassArr find _class; //search class in class duration array
	if !(_durationIndex == -1) then {_duration = MKK_itemSoundDuraArr select _durationIndex}; //class found, overwrite duration var
	_soundObject = "#particlesource" createVehicle (getPos _source); //sound object
	if (_attach) then {_soundObject attachTo [_source, [0, 0, 0]]}; //attach to source
	[_soundObject, _class] remoteExec ["say3D", 0]; //play sound remote
	[_duration, _soundObject] spawn {sleep (_this select 0); deleteVehicle (_this select 1)}; //wait and delete sound object
	_soundObject; //return sound source
};


//item functions
fn_null = {objNull}; //placeholder function for dev

fn_itemBoost = { //vehicle boost
	[] spawn {
		_veh = vehicle player; //backup player vehicle
		[_veh,"MKK_boost"] call fn_createSound; //create sound source
		_tmpPos = getPos _veh; _tmpPos set [2, 0.6]; //proper Z position
		_obj = createVehicle ["Land_Can_V3_F", _tmpPos, [], 0, "CAN_COLLIDE"]; //create can
		_obj setVectorUp [-1 + (random 2), -1 + (random 2), -1 + (random 2)]; //random vector
		_flame = "#particlesource" createVehicleLocal [0, 0, 0];
		_flame setParticleClass "RocketBackfireRPGNT";
		_flame attachTo [_veh, [-0.25, -0.8, -0.7]];
		for "_i" from 0 to 2 do { //progressive boost
			if (([_veh] call fn_realSpeed) < 150) then { //under 150kmh
				_vehVector = velocity _veh; //velocity vector
				_veh setVelocity [(_vehVector select 0) * 1.3, (_vehVector select 1) * 1.3, _vehVector select 2]; //update velocity
			}; sleep 0.2;
		};
		deleteVehicle _flame; //delete flame
		sleep 4; //wait a bit
		deleteVehicle _obj; //delete can
	};
};

fn_itemBarrelExp = { //spawn a explosive barrel, explode if collide with a physx object or after 10sec
	[] spawn {
		_veh = vehicle player; //backup player vehicle
		_vehDir = getDir _veh; //vehicle direction
		_kartList = MKK_karts; //global to local kart list
		_kartCount = (count _kartList) - 1; //kart count - 1
		_tmpPos = _veh getPos [2.5, _vehDir]; //2.5m infront of player
		_tmpPos set [2, 0.4]; //proper Z position
		[_veh,"MKK_throw"] call fn_createSound; //create sound source
		_obj = createVehicle ["Land_MetalBarrel_F", _tmpPos, [], 0, "CAN_COLLIDE"]; //create barrel
		_obj setDir _vehDir; //random starting direction
		_obj allowDamage false; //disable object damage
		_vehVector = vectorDir _veh; //player vehicle direction vector
		_obj setVelocity [(_vehVector select 0) * 50, (_vehVector select 1) * 50, 2]; //set barrel velocity
		_time = (call MKK_fnc_time); //start time
		_boom = false; //item will explode
		while {sleep 0.15; !(isNull _obj) && {!(_boom)}} do {
			if (((call MKK_fnc_time) - _time) > 10) then {_boom = true; //timeout
			} else {if !((_kartList findIf {((_x distance2D _obj) < 2) && {!(_x getVariable ["MKK_inv", false])}}) == -1) then {_boom = true}};
			if (_boom) then {[_obj, _kartList] call fn_explosion}; //spawn explosion
		};
	};
};

fn_itemFakeBox = { //spawn a fake item box, explode on its own after 60sec
	[] spawn {
		_veh = vehicle player; //backup player vehicle
		_kartList = MKK_karts; //global to local kart list
		_kartCount = (count _kartList) - 1; //kart count - 1
		_tmpPos = _veh getPos [2.5, (getDir _veh) + 180]; //2.5m behind of player
		//_tmpPos set [2, (getTerrainHeightASL _tmpPos) + 0.5]; //proper ASL position
		_tmpPos = [_tmpPos, _veh, 0.5] call fn_setAslZ; //proper ASL position
		_obj = createSimpleObject ["Land_Balloon_01_air_F", _tmpPos]; //create item box
		[_obj, [0, "notMarioKartKnockoff\img\objs\itembox.paa"]] remoteExec ["setObjectTexture", 0, true]; //set global texture
		_obj setDir (random 360); //random starting direction
		_obj setPosASL _tmpPos; //re-set object position
		_time = (call MKK_fnc_time); //start time
		_boom = false; //item will explode
		while {sleep 0.15; !(isNull _obj) && {!(_boom)}} do {
			if (((call MKK_fnc_time) - _time) > 60) then {_boom = true; //timeout
			} else {if !((_kartList findIf {((_x distance2D _obj) < 2) && {!(_x getVariable ["MKK_inv", false])}}) == -1) then {_boom = true}};
			if (_boom) then {[_obj, _kartList] call fn_explosion}; //spawn explosion
		};
	};
};

fn_itemMine = { //spawn a land mine, explode on its own after 60sec
	[] spawn {
		_veh = vehicle player; //backup player vehicle
		_kartList = MKK_karts; //global to local kart list
		_kartCount = (count _kartList) - 1; //kart count - 1
		_tmpPos = _veh getPos [2.5, (getDir _veh) + 180]; //2.5m behind of player
		//_tmpPos set [2, (getTerrainHeightASL _tmpPos) + 0.08]; //proper ASL position
		_tmpPos = [_tmpPos, _veh, 0.08] call fn_setAslZ; //proper ASL position
		_obj = createSimpleObject ["ATMine", _tmpPos]; //create mine
		_obj setDir (random 360); //random direction
		_obj setPosASL _tmpPos; //re-set object position
		_time = (call MKK_fnc_time); //start time
		_boom = false; //item will explode
		while {sleep 0.15; !(isNull _obj) && {!(_boom)}} do {
			if (((call MKK_fnc_time) - _time) > 60) then {_boom = true; //timeout
			} else {if !((_kartList findIf {((_x distance2D _obj) < 2) && {!(_x getVariable ["MKK_inv", false])}}) == -1) then {_boom = true}};
			if (_boom) then {[_obj, _kartList, 1] call fn_explosion}; //spawn explosion
		};
	};
};

fn_itemOilSpill = { //spawn a oil spill, expire after 60sec
	[] spawn {
		_veh = vehicle player; //backup player vehicle
		_kartList = MKK_karts; //global to local kart list
		_kartSlide = []; {_kartSlide pushBack 0} forEach _kartList; //karts that are sliding on oil spill array
		_kartCount = (count _kartList) - 1; //kart count - 1
		_tmpPos = _veh getPos [2.5, (getDir _veh) + 180]; //2.5m behind of player
		_obj = createVehicle ["Oil_Spill_F", _tmpPos, [], 0, "CAN_COLLIDE"]; //create oil spill
		_obj setDir (random 360); //random direction
		_obj setPos _tmpPos; //re-set object position
		_time = (call MKK_fnc_time); //start time
		while {sleep 0.15; ((call MKK_fnc_time) - _time) < 60} do { //not expired
			for "_i" from 0 to _kartCount do { //near kart detection loop
				_tmpKart = _kartList select _i; //current kart
				if (((_tmpPos distance2D _tmpKart) < 2) && {([_tmpKart] call fn_realSpeed) > 10} && {!(_tmpKart getVariable ["MKK_inv", false])} && {(((call MKK_fnc_time) - (_kartSlide select _i)) > 1)}) then {
					_kartSlide set [_i, (call MKK_fnc_time)]; //set sliding start time
					_torque = linearConversion [20, 100, [_tmpKart] call fn_realSpeed, 400, 800, false]; //compute torque to apply to kart
					_torque = _torque * selectRandom [1,-1]; //random torque direction
					_tmpKart addTorque [0, 0, _torque]; //apply torque to kart
					[_tmpKart,"MKK_spinout"] call fn_createSound; //create sound source
				};
			};
		};
		deleteVehicle _obj; //delete oil spill
	};
};

fn_itemInvincibility = { //make player "invincible" for 10sec
	[] spawn {
		MKK_invEnd = (call MKK_fnc_time) + 12; //update invincibility ending time
		_veh = vehicle player; //backup player vehicle
		if !(_veh getVariable ["MKK_inv", false]) then { //not already invincible
			_veh setVariable ["MKK_inv", true, true]; //set global invincibility to true
			_kartList = MKK_karts; //global to local kart list
			_kartCount = (count _kartList) - 1; //kart count - 1
			_obj = createSimpleObject ["Sign_Sphere200cm_F", [0,0,0]]; //create sphere
			//_obj setObjectTextureGlobal [0, "#(argb,8,8,1)color(0,0,0.5,1,ca)"]; //set global texture
			_obj attachTo [_veh, [0,0,-0.7]]; //attach ball to player
			_objSound = [_veh, "MKK_invincibility"] call fn_createSound; //create sound source
			[_obj] remoteExec ["MKK_fnc_objectRainbow", 0]; //rainbow
			_lastHit = 0; //last hit time
			while {sleep 0.25; (call MKK_fnc_time) < MKK_invEnd} do { //invincibility not expired loop
				if (isNull _objSound) then {_objSound = [_veh, "MKK_invincibility"] call fn_createSound}; //recreate sound source
				{
					_pos = getPos _x; //position of current kart in array
					if ((_pos distance2D _veh) < 2.75 && {!(_x getVariable ["MKK_inv", false])}) then { //under 2.75m and not invulnerable
						if (MKK_mode == 1 && {(call MKK_fnc_time) - _lastHit > 3.5}) then { //balloon mode, steal a point only each 3.5 sec
							[player, driver _x, true] call fn_pointsUpdate; //big impact force, steal balloon if possible
							_lastHit = call MKK_fnc_time; //update last hit time
						};
						_tmpVec = (getPos _veh) vectorFromTo _pos; //force vector
						_x setVelocity [(_tmpVec select 0) * 20, (_tmpVec select 1) * 20, _tmpVec select 2]; //update kart velocity
					};
				} forEach _kartList;
			};
			deleteVehicle _obj; //delete ball
			deleteVehicle _objSound; //delete sound source
			_veh setVariable ["MKK_inv", false, true]; //set global invincibility to false
		};
	};
};

fn_itemSmoke = { //spawn a smoke grenade
	[] spawn {
		_veh = vehicle player; //backup player vehicle
		_tmpPos = _veh getPos [2, (getDir _veh) + 180]; //2m behind of player
		_smoke = createVehicle [format ["SmokeShell%1",selectRandom ["","Red","Green","Yellow","Purple","Blue","Orange"]], _tmpPos, [], 0, "CAN_COLLIDE"];
	};
};

fn_itemMissile = { //spawn a unguided dar missile
	[] spawn {
		_tmpPos = (vehicle player) getPos [2.5, getDir (vehicle player)]; //2.5m infront of player
		_tmpPos set [2, 0.4]; //proper Z position
		_obj = createVehicle ["M_AT", _tmpPos, [], 0, "CAN_COLLIDE"]; //create missile
		_obj setDir getDir (vehicle player); //random starting direction
		_objPos = getPos _obj; //recover missile position
		while {!isNull _obj} do {_tmpObjPos = getPos _obj; if !([0,0,0] isEqualTo _tmpObjPos) then {_objPos = _tmpObjPos}}; //while missile object not null, backup if valid position
		_victim = MKK_karts findIf {((_x distance2D _objPos) < 3) && {!(_x getVariable ["MKK_inv", false])}}; //check if a player near last position
		if !(_victim == -1) then {[player, driver (MKK_karts select _victim)] call fn_pointsUpdate}; //a player found, update score
	};
};

fn_itemHedgehog = { //spawn a Czech hedgehog, expire after 60sec
	[] spawn {
		_veh = vehicle player; //backup player vehicle
		_tmpPos = _veh getPos [2, (getDir _veh) + 180]; //2m behind of player
		//_tmpPos set [2, getTerrainHeightASL _tmpPos]; //proper terrain height
		_tmpPos = [_tmpPos, _veh] call fn_setAslZ; //proper ASL position
		_obj = createSimpleObject ["Land_CzechHedgehog_01_new_F", _tmpPos]; //create hedgehog
		_obj setDir (random 360); //random direction
		_obj setPosASL _tmpPos; //re-set object position
		_time = (call MKK_fnc_time) + 60; //end time
		waitUntil {sleep 10; _time < (call MKK_fnc_time)}; //wait expiration
		deleteVehicle _obj; //delete oil spill
	};
};













//items vars
_itemsFuncArr = [
/*0*/		fn_itemBoost, //boost x1
/*1*/		fn_itemBoost, //boost x2
/*2*/		fn_itemBoost, //boost x3
/*3*/		fn_itemBoost, //infinite boost for 5sec
/*4*/		fn_itemBarrelExp, //explosive barrel x1
/*5*/		fn_itemBarrelExp, //explosive barrel x2
/*6*/		fn_itemBarrelExp, //explosive barrel x3
/*7*/		fn_itemFakeBox, //fake box
/*8*/		fn_itemOilSpill, //oil spill x1
/*9*/		fn_itemOilSpill, //oil spill x2
/*10*/	fn_itemOilSpill, //oil spill x3
/*11*/	fn_itemInvincibility, //invincibility
/*12*/	fn_itemMine, //mine x1
/*13*/	fn_itemMine, //mine x2
/*14*/	fn_itemMine, //mine x3
/*15*/	fn_itemSmoke, //smoke
/*16*/	fn_itemMissile, //missile x1
/*17*/	fn_itemMissile, //missile x2
/*18*/	fn_itemMissile, //missile x3
/*19*/	fn_itemHedgehog //czech hedgehog
];

_itemsCountArr = [ //item count
/*0*/		1, //boost x1
/*1*/		2, //boost x2
/*2*/		3, //boost x3
/*3*/		999, //infinite boost for 5sec
/*4*/		1, //explosive barrel x1
/*5*/		2, //explosive barrel x2
/*6*/		3, //explosive barrel x3
/*7*/		1, //fake box
/*8*/		1, //oil spill x1
/*9*/		2, //oil spill x2
/*10*/	3, //oil spill x3
/*11*/	1, //invincibility
/*12*/	1, //mine x1
/*13*/	2, //mine x2
/*14*/	3, //mine x3
/*15*/	1, //smoke
/*16*/	1, //missile x1
/*17*/	2, //missile x2
/*18*/	3, //missile x3
/*19*/	1 //czech hedgehog
];

_itemsTimeoutArr = [ //item timeout
/*0*/		-1, //boost x1
/*1*/		-1, //boost x2
/*2*/		-1, //boost x3
/*3*/		5, //infinite boost for 5sec
/*4*/		-1, //explosive barrel x1
/*5*/		-1, //explosive barrel x2
/*6*/		-1, //explosive barrel x3
/*7*/		-1, //fake box
/*8*/		-1, //oil spill x1
/*9*/		-1, //oil spill x2
/*10*/	-1, //oil spill x3
/*11*/	-1, //invincibility
/*12*/	-1, //mine x1
/*13*/	-1, //mine x2
/*14*/	-1, //mine x3
/*15*/	-1, //smoke
/*16*/	-1, //missile x1
/*17*/	-1, //missile x2
/*18*/	-1, //missile x3
/*19*/	-1 //czech hedgehog
];

_itemsParentArr = [ //item link to index (count - 1)
/*0*/		-1, //boost x1
/*1*/		0, //boost x2
/*2*/		1, //boost x3
/*3*/		-1, //infinite boost for 5sec
/*4*/		-1, //explosive barrel x1
/*5*/		4, //explosive barrel x2
/*6*/		5, //explosive barrel x3
/*7*/		-1, //fake box
/*8*/		-1, //oil spill x1
/*9*/		8, //oil spill x2
/*10*/	9, //oil spill x3
/*11*/	-1, //invincibility
/*12*/	-1, //mine x1
/*13*/	12, //mine x2
/*14*/	13, //mine x3
/*15*/	-1, //smoke
/*16*/	-1, //missile x1
/*17*/	16, //missile x2
/*18*/	17, //missile x3
/*19*/	-1 //czech hedgehog
];

_itemsImgArr = [ //item images
/*0*/		"notMarioKartKnockoff\img\items\ui_boost1.paa", //boost x1
/*1*/		"notMarioKartKnockoff\img\items\ui_boost2.paa", //boost x2
/*2*/		"notMarioKartKnockoff\img\items\ui_boost3.paa", //boost x3
/*3*/		"notMarioKartKnockoff\img\items\ui_boostinf.paa", //infinite boost for 10sec
/*4*/		"notMarioKartKnockoff\img\items\ui_barrelexp1.paa", //explosive barrel x1
/*5*/		"notMarioKartKnockoff\img\items\ui_barrelexp2.paa", //explosive barrel x2
/*6*/		"notMarioKartKnockoff\img\items\ui_barrelexp3.paa", //explosive barrel x3
/*7*/		"notMarioKartKnockoff\img\items\ui_fakeitembox.paa", //fake box
/*8*/		"notMarioKartKnockoff\img\items\ui_oilspill1.paa", //oil spill x1
/*9*/		"notMarioKartKnockoff\img\items\ui_oilspill2.paa", //oil spill x2
/*10*/	"notMarioKartKnockoff\img\items\ui_oilspill3.paa", //oil spill x3
/*11*/	"notMarioKartKnockoff\img\items\ui_inv.paa", //invincibility
/*12*/	"notMarioKartKnockoff\img\items\ui_mine1.paa", //mine x1
/*13*/	"notMarioKartKnockoff\img\items\ui_mine2.paa", //mine x2
/*14*/	"notMarioKartKnockoff\img\items\ui_mine3.paa", //mine x3
/*15*/	"notMarioKartKnockoff\img\items\ui_smoke.paa", //smoke
/*16*/	"notMarioKartKnockoff\img\items\ui_missile1.paa", //missile x1
/*17*/	"notMarioKartKnockoff\img\items\ui_missile2.paa", //missile x2
/*18*/	"notMarioKartKnockoff\img\items\ui_missile3.paa", //missile x3
/*19*/	"notMarioKartKnockoff\img\items\ui_hedgehog.paa" //czech hedgehog
];

_itemsNameArr = [ //item name
/*0*/		format ["%1 (x1)", localize "STR_MKK_item_boost"], //boost x1
/*1*/		format ["%1 (x2)", localize "STR_MKK_item_boost"], //boost x2
/*2*/		format ["%1 (x3)", localize "STR_MKK_item_boost"], //boost x3
/*3*/		format ["%1 (5sec)", localize "STR_MKK_item_boost"], //infinite boost for 10sec
/*4*/		format ["%1 (x1)", localize "STR_MKK_item_barrelexp"], //explosive barrel x1
/*5*/		format ["%1 (x2)", localize "STR_MKK_item_barrelexp"], //explosive barrel x2
/*6*/		format ["%1 (x3)", localize "STR_MKK_item_barrelexp"], //explosive barrel x3
/*7*/		localize "STR_MKK_item_fakebox", //fake box
/*8*/		format ["%1 (x1)", localize "STR_MKK_item_oilspill"], //oil spill x1
/*9*/		format ["%1 (x2)", localize "STR_MKK_item_oilspill"], //oil spill x2
/*10*/	format ["%1 (x3)", localize "STR_MKK_item_oilspill"], //oil spill x3
/*11*/	localize "STR_MKK_item_inv", //invincibility
/*12*/	format ["%1 (x1)", localize "STR_MKK_item_mine"], //mine x1
/*13*/	format ["%1 (x2)", localize "STR_MKK_item_mine"], //mine x2
/*14*/	format ["%1 (x3)", localize "STR_MKK_item_mine"], //mine x3
/*15*/	localize "STR_MKK_item_smoke", //smoke
/*16*/	format ["%1 (x1)", localize "STR_MKK_item_missile"], //missile x1
/*17*/	format ["%1 (x2)", localize "STR_MKK_item_missile"], //missile x2
/*18*/	format ["%1 (x3)", localize "STR_MKK_item_missile"], //missile x3
/*19*/	localize "STR_MKK_item_hedgehog" //czech hedgehog
];


_playerActionsIdArr = []; //debug

//debug force item action and jump, only here in solo
if !(isMultiplayer) then {
	for "_i" from 0 to (count _itemsNameArr) - 1 do {
		_tmpActionId = player addAction [format ["Debug: item: %1", _itemsNameArr select _i], {MKK_item = _this select 3 select 0; MKK_itemCount = _this select 3 select 1; MKK_pickedItem = true}, [_i, _itemsCountArr select _i], 1.5, false];
		_playerActionsIdArr pushBack _tmpActionId; //add to array
	};
	
	_tmpActionId = player addAction ["Debug: jump: small", {(vehicle player) setVelocity [0, 0, 10]}, [], 1.5, false];
	_playerActionsIdArr pushBack _tmpActionId; //add to array
	
	_tmpActionId = player addAction ["Debug: jump: big", {(vehicle player) setVelocity [0, 0, 20]}, [], 1.5, false];
	_playerActionsIdArr pushBack _tmpActionId; //add to array
};

MKK_itemsAllowedArr = [0,2,4,6,7,8,10,11,12,14,15,16,17,18,19]; //item enabled, 0,1,2,4,6,7,8,10,11,12,14,15,16,17,18,19
if (MKK_mode != 1) then {MKK_itemsAllowedArr append [5,13]}; //not in balloon mode: add infinite boost, explosive barrel x2, mine x2
MKK_itemsAgressiveArr = [0,4,5,6,7,11,12,13,14,16,17,18,19]; //item to keep when time under 5 min

/*
MKK_itemsAllowedArr = [11];
MKK_itemsAgressiveArr = [11];
*/

MKK_itemSoundClassArr = [ //sound classes, used as index for duration
	"MKK_itemboxhit",
	"MKK_boost",
	"MKK_itemselection",
	"MKK_spinout",
	"MKK_invincibility",
	"MKK_throw"
];

MKK_itemSoundDuraArr = [ //sounds duration
	0.6,
	1.6,
	3.2,
	1.3,
	12.0,
	0.5
];


if (player getVariable ["MKK_pointsLast", -999] == -999) then { //player points should be legit
	player setVariable ["MKK_points", (MKK_modePointArr select MKK_mode) select MKK_modeRules, true]; //start player starting points
} else { //player left vehicle and enter back
	player setVariable ["MKK_points", player getVariable "MKK_pointsLast", true]; //retore player points
};

_handleGui = scriptNull; //gui handle
_handleItems = scriptNull; //items handle
_handleSubtitles = scriptNull; //subtitles/points handle
_handleBalloon = scriptNull; //balloon handle

MKK_item = -1; //player item
MKK_pickedItem = false; //player has picked item
MKK_itemForced = -1; //forced item, used to update
MKK_itemCount = 0; //item player still have
MKK_itemPending = false; //item selection rolling
MKK_invEnd = -1; //invincibility expiration

_boxs = missionNamespace getVariable ["MKK_boxs", []]; //recover boxs array
if (count _boxs > 0) then {_boxs = _boxs select MKK_area}; //select right itembox array

_agressiveMode = false; //round has switch to agressive mode var

if (count _boxs > 0) then { //item box are set
	while {sleep 1; (call MKK_fnc_time) < MKK_roundEnd && {(vehicle player) != player}} do { //main loop
		if (!(_agressiveMode) && {(MKK_roundEnd - (call MKK_fnc_time)) < 300}) then { //under 5min remaining, switch to agressive mode
			MKK_itemsAllowedArr = MKK_itemsAgressiveArr; //switch item array
			_agressiveMode = true; //set agressive var
			_minutes = (MKK_roundEnd - (call MKK_fnc_time)) / 60;
			[localize "STR_MKK_server", format [localize "STR_MKK_game_roundendsinagressive", [format ["%1 %2", round (MKK_roundEnd - (call MKK_fnc_time)), localize "STR_MKK_seconds"], format ["%1 %2", round _minutes, "minutes"]] select (_minutes > 1)]] call MKK_fnc_displaySubtitle;
		};
		
		if (isNull _handleGui) then {
			_handleGui = [_itemsCountArr, _itemsTimeoutArr , _itemsImgArr, _itemsNameArr] spawn { //item selection / GUI related stuff routine
				params ["_itemsCountArr", "_itemsTimeoutArr", "_itemsImgArr", "_itemsNameArr"];
				disableSerialization;
				
				waitUntil {sleep 0.1; !isNull (findDisplay 46) || !((vehicle player) != player)}; //wait for mission screen to open
				_missionDisplay = findDisplay 46; //found the screen object
				
				["notMarioKartKnockoff_round.sqf: gui routine started"] call NNS_fnc_debugOutput; //debug
				
				_agressiveMode = false; //round has switch to agressive mode var
				
				_itemGrpWidth = safezoneH / 7; //image width
				_itemGrpHeight = _itemGrpWidth; //image height
				
				//create item group
				_itemGrp = _missionDisplay ctrlCreate ["RscControlsGroupNoScrollbars", -1]; //create control
				_itemGrp ctrlSetPosition [safeZoneX + ((safeZoneW - _itemGrpWidth) / 2), safeZoneY + 0.1]; //set position and size
				_itemGrp ctrlCommit 0; //commit control
				
				_itemImgCtrlArr = []; //contain all items picture control
				{ //fill array
					_tmpCtrl = _missionDisplay ctrlCreate ["RscPictureKeepAspect", -1, _itemGrp]; //create control
					_tmpCtrl ctrlSetPosition [0, 0, _itemGrpWidth, _itemGrpHeight]; //set position and size
					_tmpCtrl ctrlSetText _x; _tmpCtrl ctrlShow false; //image path and hide control
					_tmpCtrl ctrlCommit 0; _itemImgCtrlArr pushBack _tmpCtrl; //commit and add to array
				} forEach _itemsImgArr;
				
				_itemSelectArr = +(MKK_itemsAllowedArr); //used to avoid consecutive item
				
				_lastItem = -1; //last update item
				_lastItemCount = -1; //last update item count
				_itemSelectStart = -1; //item pending start
				_itemSubtitleHandle = scriptNull; //store subtitle handle for item
				
				while {sleep 0.15; (call MKK_fnc_time) < MKK_roundEnd && {(vehicle player) != player}} do {
					if (!(_agressiveMode) && {(MKK_roundEnd - (call MKK_fnc_time)) < 300}) then { //under 5min remaining, switch to agressive mode
						_itemSelectArr = +(MKK_itemsAgressiveArr); //force reset item array
						_agressiveMode = true; //set agressive var
					};
					
					if (MKK_itemPending) then { //item still not selected
						if (_itemSelectStart == -1) then {
							_itemSelectStart = (call MKK_fnc_time); //item pending start
							[(vehicle player),"MKK_itemselection"] call fn_createSound; //create sound source
						};
						
						MKK_item = selectRandom _itemSelectArr; //select a random item
						_itemSelectArr deleteAt (_itemSelectArr find MKK_item); //remove from item array
						if (count _itemSelectArr == 0) then { //empty item array
							_itemSelectArr = +(MKK_itemsAllowedArr); //reset array
							_itemSelectArr = _itemSelectArr call BIS_fnc_arrayShuffle; //shuffle array
						};
					};
					
					if (!(MKK_itemCount == _lastItemCount) || {MKK_itemPending}) then { //need to update image
						if !(_lastItem == -1) then {
							(_itemImgCtrlArr select _lastItem) ctrlShow false; //hide last item image
							_lastItemCount = MKK_itemCount; //update last count var
							if (MKK_itemCount < 1 && {!isNull _itemSubtitleHandle}) then {terminate _itemSubtitleHandle}; //kill item subtitle
						};
						
						if (MKK_itemCount > 0 || {MKK_itemPending}) then { //at least one item left or item selection in progress
							if !(MKK_itemForced == -1) then {
								(_itemImgCtrlArr select MKK_itemForced) ctrlShow true; //show new forced item image
								_lastItem = MKK_itemForced; //update last item var
							} else {
								if !(MKK_item == -1) then {
									(_itemImgCtrlArr select MKK_item) ctrlShow true; //show new item image
									_lastItem = MKK_item; //update last item var
								};
							};
						};
						
						if (MKK_itemPending && {(call MKK_fnc_time) - _itemSelectStart > 3}) then { //item selection timeout
							MKK_itemCount = _itemsCountArr select MKK_item; //update item count
							MKK_itemPending = false; //reset selection var
							_itemSelectStart = -1; //reset item select start time
							_itemSubtitleHandle = [localize "STR_MKK_player_youpicked", _itemsNameArr select MKK_item, true] call MKK_fnc_displaySubtitle; //advice player
						};
					};
				};
				
				//clean all controls
				{ctrlDelete _x} forEach _itemImgCtrlArr; //delete picture controls
				ctrlDelete _itemGrp; //delete control group
				
				["notMarioKartKnockoff_round.sqf: gui routine killed"] call NNS_fnc_debugOutput; //debug
			};
		};
		
		if (isNull _handleItems) then {
			_handleItems = [_itemsFuncArr,_itemsTimeoutArr,_itemsParentArr,_boxs] spawn { //items / player stuff routine
				params ["_itemsFuncArr", "_itemsTimeoutArr", "_itemsParentArr", "_boxs"];
				
				["notMarioKartKnockoff_round.sqf: items routine started"] call NNS_fnc_debugOutput; //debug
				
				_boxsPos = []; {_boxsPos pushBack (getPos _x)} forEach _boxs; //box position array
				_boxsCount = (count _boxs) - 1; //backup boxs count for distance loop
				_itemTimeoutHandle = scriptNull; //handle id for timeout based items
				
				while {sleep 0.1; (call MKK_fnc_time) < MKK_roundEnd && {(vehicle player) != player}} do { //loop until player exit vehicle
					if (!(MKK_pickedItem) && {!(MKK_itemPending)}) then { //player doesn't hold a item and not selecting item
						if (fuel (vehicle player) > 0) then { //can pick item only if tank not empty
							_pos = getPos (vehicle player); //current position
							_nearObj = []; //reset near objects array
							for "_i" from 0 to _boxsCount do {if ((_pos distance2D (_boxsPos select _i)) < 1.5) then {_nearObj pushBack (_boxs select _i)}}; //near box detection
							_validBoxIndex = _nearObj findIf {!(_x getVariable "picked")}; //search a valid box
							if !(_validBoxIndex == -1) then { //valid box found
								[(_nearObj select _validBoxIndex),"MKK_itemboxhit",10,false] call fn_createSound; //play picked sound
								(_nearObj select _validBoxIndex) setVariable ["picked", true, true]; //set box picked var
								MKK_pickedItem = true; //set item picked var
								MKK_itemPending = true; //item pending
							};
						};
					} else { //player hold a item
						if ((inputAction "vehicleTurbo" > 0) && {!(MKK_itemPending)} && {!(MKK_item == -1)}) then { //turbo key pressed and still have some item
							MKK_itemCount = MKK_itemCount - 1; //decrease item count
							
							_null = call (_itemsFuncArr select MKK_item); //call function
							
							_itemTimeout = _itemsTimeoutArr select MKK_item;
							if (!(_itemTimeout == -1) && {isNull _itemTimeoutHandle}) then { //item has timeout but not init
								//if !(isNull _itemTimeoutHandle) then {terminate _itemTimeoutHandle}; //timeout handle not null, kill it
								_itemTimeoutHandle = [_itemTimeout] spawn { //start timeout script
									_time = (call MKK_fnc_time) + (_this select 0); //end time
									waitUntil {sleep 0.5; (call MKK_fnc_time) > _time}; //timeout
									MKK_itemCount = 0; //reset item count
								};
							};
							
							if (MKK_itemForced == -1) then {MKK_itemForced = _itemsParentArr select MKK_item; //forced item not set, set forced item to item parent
							} else {MKK_itemForced = _itemsParentArr select MKK_itemForced}; //set forced item to forced item parent
							
							sleep 0.25; //wait before allow now laungh
						};
						
						if (MKK_itemCount < 1 && {!(MKK_itemPending)} && {!(MKK_item == -1)}) then {
							MKK_item = -1; //reset item
							MKK_itemForced = -1; //reset forced item
							MKK_pickedItem = false; //reset item picked
						};
					};
				};
				
				["notMarioKartKnockoff_round.sqf: items routine killed"] call NNS_fnc_debugOutput; //debug
			};
		};
		
		if (isNull _handleSubtitles) then {
			_handleSubtitles = [] spawn { //subtitle and score box routine
				["notMarioKartKnockoff_round.sqf: subtitle/scorebox routine started"] call NNS_fnc_debugOutput; //debug
				
				disableSerialization;
				
				waitUntil {sleep 0.1; !isNull (findDisplay 46) || !((vehicle player) != player)}; //wait for mission screen to open
				_missionDisplay = findDisplay 46; //found the screen object
				
				//create score control
				_scoreCtrl = _missionDisplay ctrlCreate ["RscStructuredText", -1]; //create title control, require idc
				_scoreCtrl ctrlSetStructuredText parseText format ["<t size='1' align='center'>%1</t>", localize "STR_MKK_game_waitscoreupdate"]; //set text
				_scoreCtrl ctrlSetPosition [safeZoneX, safeZoneY, safeZoneW, 0]; _scoreCtrl ctrlCommit 0; //set width only, needed to get proper height
				_scoreCtrlPos = ctrlPosition _scoreCtrl; //control position
				_scoreCtrl ctrlSetPosition [
					safeZoneX + safeZoneW - (ctrlTextWidth _scoreCtrl), //x
					safeZoneY + safeZoneH - (ctrlTextHeight _scoreCtrl), //y
					(ctrlTextWidth _scoreCtrl), //w
					(ctrlTextHeight _scoreCtrl) //h
				]; //set proper position and size
				_scoreCtrl ctrlSetBackgroundColor [0.05, 0.05, 0.05, 0.8]; //background
				_scoreCtrl ctrlCommit 0; //commit
				
				_loop = 0;
				_remainingTime = -1;
				_subtitleTrigger = [1800,1200,600,60,45,30,15,10,5]; //30, 20, 10, 1min, 45, 30, 15, 10, 5sec
				
				while {sleep 1; (call MKK_fnc_time) < MKK_roundEnd && {(vehicle player) != player}} do { //loop until player exit vehicle
					_remainingTime = round (MKK_roundEnd - (call MKK_fnc_time)); //round remaining time
					
					if (_loop == 2) then { //every 2 sec
						if (_remainingTime > 0) then { //some time remain
							_nearIndex = _subtitleTrigger findIf {abs (_x - _remainingTime) < 2};
							if !(_nearIndex == -1) then {
								_minutes = (_subtitleTrigger select _nearIndex) / 60;
								["", format [localize "STR_MKK_game_roundendsin", [format ["%1 %2", (_subtitleTrigger select _nearIndex), localize "STR_MKK_seconds"], format ["%1 %2", round _minutes, "minutes"]] select (_minutes > 1)]] call MKK_fnc_displaySubtitle;
							};
						};
					};
					
					//reset points related vars
					_playersPointsArr = []; //[points, player]
					_playersPointsStrArr = []; //string array
					_playersPointsStr = ""; //string to display
					
					_currentGameMode = MKK_mode; //recover current game mode
					if !(_currentGameMode == -1) then {
						_playersPointsStrArr pushBack format ["<t size='1' font='PuristaBold' underline='1' align='center'>%1</t>", [MKK_modeNameArr select MKK_mode] call MKK_fnc_strUnbreakSpace]; //game mode header
					};
					
					_remainingTime = floor (_remainingTime); //round remaining time
					if (_remainingTime < 0) then {_remainingTime = 0}; //avoid negative time
					_playersPointsStrArr pushBack format ["<t size='1'><t align='left'>%1:</t>&#160;&#160;&#160;<t align='right'>%2&#160;%3</t></t>", [localize "STR_MKK_game_remainingtime"] call MKK_fnc_strUnbreakSpace, floor (_remainingTime), localize "STR_MKK_seconds"];
					_playersPointsStrArr pushBack format ["<t size='1' font='PuristaBold' underline='1' align='center'>%1</t>", [localize "STR_MKK_game_currentscore"] call MKK_fnc_strUnbreakSpace]; //player header
					
					if (MKK_mode == 3) then { //team deathmatch mode
						_playersPointsArr = [[], [], [], []]; //player points array: [[[points, player],...], [[points, player],...], ...]
						_teamsPointsArr = [[-1, 0, _playersPointsArr select 0], [-1, 1, _playersPointsArr select 1], [-1, 2, _playersPointsArr select 2], [-1, 3, _playersPointsArr select 3]]; //teams scores array: [score, team index, player array pointer]
						
						{ //all players loop
							if (_x getVariable ["MKK_init", false] && {_x getVariable ["MKK_team", -1] != -1}) then { //player in a kart, team set with points over 0
								_tmpTeam = _x getVariable "MKK_team"; //current player team
								_tmpPoints = _x getVariable "MKK_points"; //recover player selected team and points
								
								_tmpTeamPointsArr = _teamsPointsArr select _tmpTeam; //team points array pointer
								if (_tmpTeamPointsArr select 0 == -1) then {_tmpTeamPointsArr set [0, 0]}; //init team score if needed
								_tmpTeamPointsArr set [0, (_tmpTeamPointsArr select 0) + _tmpPoints]; //add player points to its team
								
								_tmpPlayersPointsArr = _playersPointsArr select _tmpTeam; //players points array pointer
								_tmpPlayersPointsArr pushBack [_tmpPoints, name (_x)]; //add to array
							};
						} forEach allPlayers;
						
						/*
						//debug fake entry
						_playersPointsArr = [[[15,"15esfs"], [1,"1esk uut fs"], [5,"5esdd dfs"], [20,"20es fj hjs"]],
						[[15,"15es ffs"], [2,"2ess dh fs"], [8,"8es ddt rhs"], [10,"10gfhd hjs"]],
						[[1,"1e dysfs"], [10,"10es ktr h fs"], [2,"2esd rthd fs"], [5,"5esjyyt s"]],
						[[25,"25eh sj gjs"], [3,"3eszht rtrb trs"], [5,"5estr hd  dfs"], [30,"30esrth hjs"]]];
						_teamsPointsArr = [[15, 0, _playersPointsArr select 0], [2, 1, _playersPointsArr select 1], [25, 2, _playersPointsArr select 2], [3, 3, _playersPointsArr select 3]]; //teams scores array: [score, team index, player array pointer]
						*/
						
						for "_i" from 0 to 3 do {(_playersPointsArr select _i) sort false}; //sort players arrays by points
						_teamsPointsArr sort false; //sort teams array
						
						_teamColorStrArr = [localize "STR_MKK_Gamemode_teamdeathmatch_blueteam", localize "STR_MKK_Gamemode_teamdeathmatch_redteam", localize "STR_MKK_Gamemode_teamdeathmatch_greenteam", localize "STR_MKK_Gamemode_teamdeathmatch_yellowteam"]; //team to localized name array
						_teamColorArr = ["#0000ff", "#ff0000", "#00ff00", "#ffff00"]; //team to color array
						
						_firstTeam = true; _teamPaddingStr = "";
						{
							_tmpTeamPoints = _x select 0; //recover points
							if (_tmpTeamPoints != -1) then { //not empty team
								_tmpTeamName = _teamColorStrArr select (_x select 1); //team name
								_tmpTeamColor = _teamColorArr select (_x select 1); //color name
								if !(_firstTeam) then {_teamPaddingStr = "<br/>"}; _firstTeam = false; //allow to add a line return before team title
								_playersPointsStrArr pushBack format ["%1<t size='1'><t align='left' color='%2'>&#160;%3</t>&#160;&#160;&#160;&#160;<t align='right'>%4&#160;</t></t>", _teamPaddingStr, _tmpTeamColor, [_tmpTeamName] call MKK_fnc_strUnbreakSpace, _tmpTeamPoints]; //add to str array
								
								_tmpPlayersArr = _x select 2; //players array
								{
									_tmpPlayerPoints = _x select 0; //recover points
									_tmpPlayerName = _x select 1; //player name
									_playersPointsStrArr pushBack format ["<t size='1'><t align='left'>&#160;&#160;&#160;&#160;%1</t>&#160;&#160;&#160;&#160;<t align='right'>%2&#160;</t></t>", [_tmpPlayerName] call MKK_fnc_strUnbreakSpace, _tmpPlayerPoints]; //add to str array
								} forEach _tmpPlayersArr;
							};
						} forEach _teamsPointsArr;
						
						_playersPointsStr = _playersPointsStrArr joinString "<br/>"; //array to string
					} else { //any other modes
						{ //all players loop
							if (_x getVariable ["MKK_init", false]) then { //player in a kart
								_points = _x getVariable ["MKK_points", -1];
								_playersPointsArr pushBack [_points, name (_x)]; //add to array
							};
						} forEach allPlayers;
						/*
						//debug fake entry
						_playersPointsArr pushBack [100, "tests"]; _playersPointsArr pushBack [20, "hd djfg fjgdg"]; _playersPointsArr pushBack [1500, "-gfdhj -gfj -"]; _playersPointsArr pushBack [25, "gfhsj sj ggsj s"]; _playersPointsArr pushBack [10, "sfgj"]; _playersPointsArr pushBack [1, "ytyjtyty"];
						*/
						_playersPointsArr sort false; //sort array by points

						{
							_tmpPoints = _x select 0; //recover points
							_tmpPlayerName = _x select 1; //player name
							_playersPointsStrArr pushBack format ["<t size='1'><t align='left'>&#160;%1</t>&#160;&#160;&#160;&#160;<t align='right'>%2&#160;</t></t>",[_tmpPlayerName] call MKK_fnc_strUnbreakSpace, _tmpPoints]; //add to str array
						} forEach _playersPointsArr;
						_playersPointsStr = _playersPointsStrArr joinString "<br/>"; //array to string
					};
					
					//update players points control
					_scoreCtrl ctrlSetStructuredText parseText _playersPointsStr; //set text
					
					_scoreCtrlPos = ctrlPosition _scoreCtrl; //control position
					_scoreCtrl ctrlSetPosition [safeZoneX + safeZoneW - (ctrlTextWidth _scoreCtrl), safeZoneY + safeZoneH - (ctrlTextHeight _scoreCtrl), (ctrlTextWidth _scoreCtrl), (ctrlTextHeight _scoreCtrl)]; //set position and size
					_scoreCtrl ctrlCommit 0; //commit
					
					//need to be done twice for proper height
					_scoreCtrlPos = ctrlPosition _scoreCtrl;
					_scoreCtrl ctrlSetPosition [safeZoneX + safeZoneW - (ctrlTextWidth _scoreCtrl), safeZoneY + safeZoneH - (ctrlTextHeight _scoreCtrl), (ctrlTextWidth _scoreCtrl), (ctrlTextHeight _scoreCtrl)];
					_scoreCtrl ctrlCommit 0;
					
					if (_loop == 2) then {_loop = 0} else {_loop = _loop + 1}; //reset loop count
				};
				
				ctrlDelete _scoreCtrl; //delete score box control
				
				["notMarioKartKnockoff_round.sqf: subtitle/scorebox routine killed"] call NNS_fnc_debugOutput; //debug
			};
		};
		
		if ((MKK_mode == 1) && {isNull _handleBalloon}) then {
			_handleBalloon = [] spawn { //balloon game mode specific routine
				["notMarioKartKnockoff_round.sqf: balloon routine started"] call NNS_fnc_debugOutput; //debug
				
				_veh = vehicle player; //backup player vehicle
				_spectatorMode = false; //spectator mode var
				
				//compute balloon size
				_tmpObj = createSimpleObject ["Land_Balloon_01_air_F", [0,0,0], true]; //create balloon
				_tmpObjBox = boundingBoxReal _tmpObj; //bounding box of object
				deleteVehicle _tmpObj; //delete object
				
				_tmpObjSize = 100; //oversized dimension
				for "_i" from 0 to 2 do { //loop oll axis
					_tmpSize = abs (((_tmpObjBox select 1) select _i) - ((_tmpObjBox select 0) select _i)); //current axis size
					if (_tmpSize < _tmpObjSize) then {_tmpObjSize = _tmpSize}; //lower size
				};
				_balloonSize = _tmpObjSize; //object size
				
				_lastBalloonCount = player getVariable ["MKK_points", 0]; //recover player points
				if (_lastBalloonCount > 10) then {_lastBalloonCount = 10}; //limit to 10 balloons to display
				if (_lastBalloonCount < 0) then {_lastBalloonCount = 0}; //avoid negative count
				_balloonObjArr = []; //store balloons objects
				
				for "_i" from 0 to 9 do {
					if (_i < _lastBalloonCount) then {
						_tmpPos = [0,0,0] getPos [((_lastBalloonCount * _balloonSize) / pi) / 2, (360 / _lastBalloonCount) * _i]; //balloon position
						_tmpPos set [2, 1]; //update Z position
						_tmpObj = createSimpleObject ["Land_Balloon_01_air_F", getPosASL _veh]; //create balloon
						_tmpObj attachTo [_veh, _tmpPos]; //attach balloon to player vehicle
				    _balloonObjArr pushBack _tmpObj; //add balloon to array
			    } else {_balloonObjArr pushBack objNull}; //add null object to array
				};
				
				waitUntil {sleep 0.1; (call MKK_fnc_time) > MKK_introEnd && {(vehicle player) != player}}; //wait for intro finishec
				
				MKK_lastColl = 0; //time of last epe collision
				_collisionHandle = (vehicle player) addEventHandler ["EpeContactStart", {
					params ["_attacker", "_victim", "_sel1", "_sel2", "_force"]; //sel1-2 not used
					if ((call MKK_fnc_time) - MKK_lastColl > 0.5 && {_victim in MKK_karts} && {([_attacker] call fn_realSpeed) > 50} && {!(_victim getVariable ["MKK_inv", false])} && {_force > 100} && {abs ([getDir _attacker, _attacker getDir _victim] call MKK_fnc_angleDiff) < 60}) then { //last collision happened over 0.5sec ago
						[player, driver _victim, true] call fn_pointsUpdate; //big impact force, steal balloon if possible
					};
					
					MKK_lastColl = call MKK_fnc_time; //update last collision time
				}];
				
				_loop = 0;
				while {sleep 0.1; (call MKK_fnc_time) < MKK_roundEnd && {(vehicle player) != player}} do { //loop until player exit vehicle
					if (_loop == 5) then { //0.5sec loop
						_balloonCount = player getVariable ["MKK_points", 0]; //recover player points
						if (_balloonCount > 10) then {_balloonCount = 10}; //limit to 10 balloons to display
						if (_balloonCount < 0) then {_balloonCount = 0}; //avoid negative count
						
						if !(_balloonCount == _lastBalloonCount) then { //need to update balloon objects
							for "_i" from 0 to 9 do { //balloon loop
								if (_i < _balloonCount) then {
									_tmpPos = [0,0,0] getPos [((_balloonCount * _balloonSize) / pi) / 2, (360 / _balloonCount) * _i]; //balloon position
									_tmpPos set [2, 1]; //update Z position
									if (isNull (_balloonObjArr select _i)) then { //current index contain null object
										_tmpObj = createSimpleObject ["Land_Balloon_01_air_F", getPosASL _veh]; //create balloon
										_tmpObj attachTo [_veh, _tmpPos]; //attach balloon to player vehicle
								    _balloonObjArr set [_i, _tmpObj]; //update array
									} else {
										(_balloonObjArr select _i) attachTo [_veh, _tmpPos]; //update balloon position
									};
						    } else {
						    	if !(isNull (_balloonObjArr select _i)) then { //object not null
						    		deleteVehicle (_balloonObjArr select _i); //delete object
						    		_balloonObjArr set [_i, objNull]; //update array
						    	};
						    };
							};
							
							_lastBalloonCount = _balloonCount; //backup balloons count
						};
						
						if (_balloonCount < 1 && {!(_spectatorMode)}) then { //no more balloon and no already in spectator mode
							[_veh, 0] remoteexec ["setFuel", _veh]; //empty vehicle tank
							_spectatorMode = true; //update spectator var
							(vehicle player) removeEventHandler ["EpeContactStart", _collisionHandle]; //remove collision handle
							waitUntil {sleep 0.1; !(MKK_itemPending)}; //wait until item selected
							MKK_item = -1; //reset player item
							MKK_pickedItem = false; //reset player has picked item
							MKK_itemForced = -1; //reset forced item
							MKK_itemCount = 0; //reset item player still have
							sleep 2; //wait 2 sec
							["Initialize", [player]] call BIS_fnc_EGSpectator; //switch to spectator mode
						} else {
							if (_balloonCount > 0) then {[_veh, 1] remoteexec ["setFuel", _veh]}; //refuel player vehicle if some balloon left
						};
					};
					
					if (_loop == 5) then {_loop = 0} else {_loop = _loop + 1}; //reset loop count
				};
				
				(vehicle player) removeEventHandler ["EpeContactStart", _collisionHandle]; //remove collision handle
				{deleteVehicle _x} forEach _balloonObjArr; //delete all balloons
				["Terminate", [player]] call BIS_fnc_EGSpectator; //exit spectator mode
				
				["notMarioKartKnockoff_round.sqf: balloon routine killed"] call NNS_fnc_debugOutput; //debug
			};
		};
	};
};

//terminate all scripts
/*
if !(isNull _handleGui) then {terminate _handleGui};
if !(isNull _handleItems) then {terminate _handleItems};
if !(isNull _handleSubtitles) then {terminate _handleSubtitles};
if !(isNull _handleBalloon) then {terminate _handleBalloon};
*/

for "_i" from ((count _playerActionsIdArr) - 1) to 0 step -1  do { player removeAction _i}; //remove item debug actions

player setVariable ["MKK_pointsLast", player getVariable "MKK_points"]; //backup player points

["Terminate", [player]] call BIS_fnc_EGSpectator; //force exit spectator mode
player allowDamage false; //disable player damage
(vehicle player) allowDamage false; //disable player vehicle damage, exit spectator mode re-enable it

//waitUntil {sleep 0.1; (call MKK_fnc_time) > MKK_roundEnd}; //wait for score screen script end
["notMarioKartKnockoff_round.sqf: End"] call NNS_fnc_debugOutput;