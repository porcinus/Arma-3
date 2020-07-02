//NNS : varible to ignore unit for compute group center
player setVariable ["recovery",true,true];
[] spawn {sleep 5; player setVariable ["recovery",false,true];};

//NNS : suspend distance travel record
player setVariable ["distance_traveled_suspended",true,false];
[] spawn {sleep 11; player setVariable ["distance_traveled_suspended",false,false];};

_tmp_saved_loadout = player getVariable["tmp_saved_loadout",[]];
if (uniform player == "U_C_Poloshirt_stripped" && {count _tmp_saved_loadout > 0}) then { //NNS : restore old loadout : O_Saved_Loadout selected
	removeAllWeapons player;
	removeGoggles player;
	removeHeadgear player;
	removeVest player;
	removeUniform player;
	removeAllAssignedItems player;
	clearAllItemsFromBackpack player;
	removeBackpack player;
	player setUnitLoadout(_tmp_saved_loadout);
	player setAmmo [primaryWeapon player, 1000]; //refill primary weapon magazine
	["God", "Previous loadout restored, Main magazine refilled"] call BIS_fnc_showSubtitle;
} else {
	_null = execVM 'scripts\PlayerLimitEquipment.sqf'; //NNS : Limit equipment
};

//NNS : move player respawn
if (vehicle player == player) then { //not spawned in vehicle
	_old_pos = getPos player; //initial position
	_new_pos = [_old_pos, 0, 50, 4, 0, 0.5, 0] call BIS_fnc_findSafePos; //select new position under 50m, random direction
	if (_old_pos distance2D _new_pos > 50) then {_new_pos = _old_pos getPos [random 10, random 360];}; //BIS_fnc_findSafePos failed
	player setpos [_new_pos select 0, _new_pos select 1, 0]; //move player
	player setDir ((player getRelDir _old_pos)+(getDir player)); //direction to initial position
	if (BIS_loadoutLevel == 0) then {
		_tmpmarker_name = format["tmpmarker%1",name player]; //marker name to avoid "colision"
		[_tmpmarker_name,_old_pos,_new_pos,"ColorBlack",0.3,0.75,30] call NNS_fnc_MapDrawLine; //draw line from initial to new position
	};
};

/*
_playerMoved = false;
if ({_x != player && {vehicle _x == _x} && {alive _x}} count (units BIS_grpMain) == 0) then { //all players in a vehicle
	_playersVehicles = []; //vehicle list
	{
		if (vehicle _x != _x && {alive _x} && {alive (vehicle _x)}) then { //unit alive and in vehicle
			_vehi = vehicle _x; //unit vehicle
			if !(_vehi in _playersVehicles) then {_playersVehicles pushBack _vehi;}; //add vehicle to list
		};
	} forEach (units BIS_grpMain); //units loop
	
	{
		if !(_playerMoved) then { //player not moved yet
			_playerMoved = player moveInAny _x;
		};
	} forEach _playersVehicles; //vehicle loop
};

if !(_playerMoved) then { //player not moved for whatever reason
	_old_pos = getPos player; //initial position
	_new_pos = [_old_pos, 0, 50, 4, 0, 0.5, 0] call BIS_fnc_findSafePos; //select new position under 50m, random direction
	if (_old_pos distance2D _new_pos > 50) then {_new_pos = _old_pos getPos [random 10, random 360];}; //BIS_fnc_findSafePos failed
	player setpos [_new_pos select 0, _new_pos select 1, 0]; //move player
	player setDir ((player getRelDir _old_pos)+(getDir player)); //direction to initial position
	if (BIS_loadoutLevel == 0) then {
		_tmpmarker_name = format["tmpmarker%1",name player]; //marker name to avoid "colision"
		[_tmpmarker_name,_old_pos,_new_pos,"ColorBlack",0.3,0.75,30] call NNS_fnc_MapDrawLine; //draw line from initial to new position
	};
};
*/

//NNS : more realistic aim
player setCustomAimCoef 0.75;
player setUnitRecoilCoefficient 0.70;
if (BIS_loadoutLevel == 0) then {player enablestamina false;}; //maraton mode

//NNS : allow player to heal and repair
if (BIS_loadoutLevel == 0) then {
	player setUnitTrait ["Medic",true];
	player setUnitTrait ["Engineer",true];
};

// If respawn tickets were disabled, remove the initial ticket for each of the players
if (missionNamespace getVariable "BIS_respawnTickets" == 0) then {[(_this select 0),-1] call BIS_fnc_respawnTickets};

// Delete the dead body if all players are far away
_null = (_this select 1) execVM "Scripts\BuryCorpse.sqf";


//NNS : attach IR beam to right shoulder
//if(!(irbeam isEqualTo objNull)) then {irbeam attachTo [player, [0,-0.03,0.07], "RightShoulder"];};

//NNS : add debug menu
if !(isNil {player getVariable 'addDebugActionMenu'}) then {
	_debugactionmenuid = player addAction ["Debug command", "showCommandingMenu '#USER:MENU_COMMS_DEBUG'",cursorTarget, 0, true, true, "", ""];
	player setVariable ['DebugActionMenu_id',_debugactionmenuid];
};
