/*
NNS
"Lottery" script to allow player to "win" a weapon.

Note:
There are no easy way (to my knowledge) to filter weapons by kind using CfgWeapons as main class.
But this way allow to keep attachement and also recover used magazines.

Example:
	On server : [LotteryWeaponSpawner] execVM "scripts\LotteryWeapon.sqf";
	On clients : 
		missionNamespace setVariable ["LotteryWpnReq", true, true]; //request a "roll"
		missionNamespace setVariable ["LotteryWpnRes", true, true]; //remove spawned weapon
	
Dependencies:
	in description.ext:
		class CfgFunctions {
			class NNS {
				class missionfunc {
					file = "nns_functions";
					class debugOutput {};
				};
			};
		};
		
	in stringtable.csv:
		STR_NNS_lottery_title, STR_NNS_lottery_weapon_won, STR_NNS_lottery_weapon_pickAmmo lines
		
	nns_functions folder:
		fn_debugOutput.sqf
		
	script folder:
		LotteryWeapon.sqf
	
*/

params [
["_spawnObject", objNull], //object to use as spawn point, table highly recommended
["_allowedKind", ["Rifle_Base_F","Pistol_Base_F","Launcher_Base_F"]] //allowed kind
];

if !(typeName _spawnObject == "OBJECT") exitWith {["LotteryWeapon.sqf : spawn object needed"] call NNS_fnc_debugOutput};

if (count _allowedKind == 0) then {_allowedKind = ["Weapon_Base_F","Pistol_Base_F","Launcher_Base_F"]}; //allowed kind not set, set to default
_allowedKind = _allowedKind apply {toLower _x}; //lowercase allowed kind

_spawnDir = getDir _spawnObject; //object direction
_spawnVectorDir = vectorDir _spawnObject; //object direction vector
_tmpBox = boundingBoxReal _spawnObject; //bounding box of object
_spawnSizeX = abs (((_tmpBox select 1) select 0) - ((_tmpBox select 0) select 0)); //object X size
_spawnSizeY = abs (((_tmpBox select 1) select 1) - ((_tmpBox select 0) select 1)); //object Y size
_spawnSizeZ = abs (((_tmpBox select 1) select 2) - ((_tmpBox select 0) select 2)); //object Z size
_spawnLocation = getPos _spawnObject; //object to location

if !(isSimpleObject _spawnObject) then { //not a simple object, required for proper colision
	["LotteryWeapon.sqf : converting spawn object to simple object"] call NNS_fnc_debugOutput;
	_tmpPos = getPosASL _spawnObject; //spawn object position
	_tmpObj = createSimpleObject [typeOf _spawnObject, [0,0,0]]; //create simple object
	_tmpObj setDir _spawnDir; //set direction
	_tmpObj setPosASL _tmpPos; //set position
	_tmpObj setVectorUp surfaceNormal _tmpPos; //proper vector up
	deleteVehicle _spawnObject; //delete old spawn object
	_spawnObject = _tmpObj; //replace spawn object pointer
};

LotteryWpnMag = createVehicle ["Box_NATO_Ammo_F", [0,0,0], [], 0, "CAN_COLLIDE"]; //create magazines holder
LotteryWpnMag allowDamage false; //disable damage
LotteryWpnMag hideObjectGlobal true; //hide object
LotteryWpnMag enableSimulationGlobal true; //hide object
LotteryWpnMag setPos _spawnLocation; //set position
clearMagazineCargoGlobal LotteryWpnMag; //clear magazines holder
publicVariable "LotteryWpnMag"; //public object

_magsHolderVisual = createVehicle ["Land_Ammobox_rounds_F", [0,0,0], [], 0, "CAN_COLLIDE"]; //create visual magazines box
_magsHolderVisual setDir (_spawnDir + 90); _magsHolderVisualDir = vectorDir _magsHolderVisual; //set direction and backup direction vector
_tmpBox = boundingBoxReal _magsHolderVisual; //bounding box
_magsHolderVisualSizeX = abs (((_tmpBox select 1) select 1) - ((_tmpBox select 0) select 1)); //object width
_magsHolderVisual attachTo [_spawnObject, [(_spawnSizeX - _magsHolderVisualSizeX) / 2, 0, (_spawnSizeZ + abs (((_tmpBox select 1) select 2) - ((_tmpBox select 0) select 2))) / 2]]; //attach ontop of spawn object
_magsHolderVisual setVectorDir _magsHolderVisualDir; //set proper direction vector
[_magsHolderVisual, [localize "STR_NNS_lottery_weapon_pickAmmo", {(_this select 1) action ["Gear", LotteryWpnMag]}, nil, 1.5, true, false, "", "true", 3]] remoteExec ["addAction", 0, true]; //add action

//set proper spawn location
_spawnLocation = _spawnLocation getPos [_magsHolderVisualSizeX, _spawnDir - 90]; //offset x position
_spawnLocation = _spawnLocation getPos [_spawnSizeY / 4, _spawnDir + 180]; //offset y position
_spawnLocation set [2, _spawnSizeZ + 0.3]; //update Z position + 30cm

_tmpAllowedClasses = "(getNumber (_x >> 'type') in [1,2,4]) && {getNumber (_x >> 'scope') == 2}" configClasses (configFile >> "CfgWeapons"); //extract all weapons
_allowedClasses = [];
{ //isKindOf equivalent for CfgWeapons
	_parents = [configFile >> "CfgWeapons" >> (configName _x), true] call BIS_fnc_returnParents; //recover parent classes
	if (_parents findIf {(toLower _x) in _allowedKind} == -1) then {} else {_allowedClasses pushBack _x}; //allowed kind
} forEach _tmpAllowedClasses;

if ((count _allowedClasses) == 0) exitWith {[format ["LotteryWeapon.sqf : no class found for defined kind : %1", _allowedKind]] call NNS_fnc_debugOutput};
[format ["LotteryWeapon.sqf : %1 classes found for defined kind : %2", count _allowedClasses, _allowedKind]] call NNS_fnc_debugOutput; //debug

_magazines = []; //share same index as weapon class
{_magazines pushBack (getArray (configfile >> "CfgWeapons" >> (configName _x) >> "magazines"))} forEach _allowedClasses; //magazines class

while {sleep 0.5; true} do {
	_request = missionNamespace getVariable ["LotteryWpnReq", false]; //roll request
	_reset = missionNamespace getVariable ["LotteryWpnRes", false]; //reset request
	
	if (_reset) then {
		missionNamespace setVariable ["LotteryWpnRes", false, true]; //reset variable 
		_conflitObjs = nearestObjects [_spawnLocation, ["ThingX"], 10, true]; //look for conflicting objects around spawn
		{if (typeOf _x == "WeaponHolderSimulated") then {_x setPos [0,0,0]; deleteVehicle _x}} forEach _conflitObjs; //delete all vehicles in spawn area
	};
	
	_conflitObjs = []; //reset conflict array
	if (_request) then {
		missionNamespace setVariable ["LotteryWpnReq", false, true]; //reset current "roll"
		
		_tmpConflitObjs = nearestObjects [_spawnLocation, ["ThingX"], 10, true]; //look for conflicting objects around spawn
		{if (typeOf _x == "WeaponHolderSimulated") then {_conflitObjs pushBack _x}} forEach _tmpConflitObjs; //filter array
		
		if (count _conflitObjs == 0) then { //no objects in spawn area
			_classToUse = selectRandom _allowedClasses; //select a random class
			_tmpWpn = createVehicle ["WeaponHolderSimulated", [0,0,0], [], 0, "CAN_COLLIDE"]; //create weapon holder
			_tmpWpn setDir _spawnDir; //set vehicle direction and get direction vector
			_tmpWpn setPos _spawnLocation; //set position
			_tmpWpn addWeaponCargoGlobal [configName _classToUse, 1]; //add weapon to weapon holder
			
			_tmpMags = getArray (configfile >> "CfgWeapons" >> (configName _classToUse) >> "magazines"); //recover magazine classes
			if (count _tmpMags > 0) then { //magazine classes found
				_magsCount = 3; //will spawn 3 magazines
				if !(_tmpWpn isKindOf "Launcher_Base_F") then {_magsCount = _magsCount + 3}; //add 3 if not launcher
				clearMagazineCargoGlobal LotteryWpnMag; //clear magazines holder
				LotteryWpnMag addMagazineCargoGlobal [_tmpMags select 0, _magsCount]; //add magazines to magazines holder
			};
			
			[localize "STR_NNS_lottery_title", format [localize "STR_NNS_lottery_vehicle_won", [_classToUse] call BIS_fnc_displayName]] remoteExec ["BIS_fnc_showSubtitle",0];
		} else {
			[format ["LotteryWeapon.sqf : objects conflict spawn of weapon : %1", _conflitObjs]] call NNS_fnc_debugOutput; //debug
		}
	};
};
