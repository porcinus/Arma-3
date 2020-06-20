enableSaving [true, false]; //NNS

BIS_civilCars = ["C_Offroad_01_F","C_Quadbike_01_F","C_SUV_01_F","C_Van_01_transport_F","C_Truck_02_transport_F"];

//NNS: add debug functions ingame
MENU_COMMS_DEBUG =
[
	// First array: "User menu" This will be displayed under the menu, bool value: has Input Focus or not.
	// Note that as of version Arma 3 1.05, if the bool value is set to false, Custom Icons will not be displayed.
	["Debug Menu", false],
	// Syntax and semantics for following array elements:
	// ["Title_in_menu", [assigned_key], "Submenu_name", CMD, [["expression",script-string]], "isVisible", "isActive" (, optional icon path)]
	// Title_in_menu: string that will be displayed for the player
	// Assigned_key: 0 - no key, 1 - escape key, 2 - key-1, 3 - key-2, ... , 10 - key-9, 11 - key-0, 12 and up... the whole keyboard
	// Submenu_name: User menu name string (eg "#USER:MY_SUBMENU_NAME" ), "" for script to execute.
	// CMD: (for main menu:) CMD_SEPARATOR -1; CMD_NOTHING -2; CMD_HIDE_MENU -3; CMD_BACK -4; (for custom menu:) CMD_EXECUTE -5
	// script-string: command to be executed on activation.  (_target=CursorTarget,_pos=CursorPos)
	// isVisible - Boolean 1 or 0 for yes or no, - or optional argument string, eg: "CursorOnGround"
	// isActive - Boolean 1 or 0 for yes or no - if item is not active, it appears gray.
	// optional icon path: The path to the texture of the cursor, that should be used on this menuitem.
	//["Teleport", [2], "", -5, [["expression", "player setPos _pos;"]], "1", "1", "\A3\ui_f\data\IGUI\Cfg\Cursors\iconcursorsupport_ca.paa"],
	//["Kill Target", [3], "", -5, [["expression", "_target setDamage 1;"]], "1", "1", "\A3\ui_f\data\IGUI\Cfg\Cursors\iconcursorsupport_ca.paa"],
	//["Disabled", [4], "", -5, [["expression", ""]], "1", "0"],
	//["Submenu", [5], "#USER:MENU_COMMS_2", -5, [], "1", "1"]
	["Cheats >", [0], "#USER:MENU_COMMS_DEBUG_CHEATS", -5, [], "1", "1"],
	["Debug >", [0], "#USER:MENU_COMMS_DEBUG_MENU", -5, [], "1", "1"],
	["Time >", [0], "#USER:MENU_COMMS_DEBUG_TIME", -5, [], "1", "1"],
	["Weather >", [0], "#USER:MENU_COMMS_DEBUG_WEATHER", -5, [], "1", "1"],
	["Destruction >", [0], "#USER:MENU_COMMS_DEBUG_DESTRUCTION", -5, [], "1", "1"],
	["Spawn/Delete on pointer >", [0], "#USER:MENU_COMMS_DEBUG_SPAWN", -5, [], "1", "1"],
	["Marker/Pointer >", [0], "#USER:MENU_COMMS_DEBUG_POINTER", -5, [], "1", "1"],
	["Use with extreme caution >", [0], "#USER:MENU_COMMS_DEBUG_EXTREME", -5, [], "1", "1"]
];


MENU_COMMS_DEBUG_CHEATS = [
	["Cheats", false],
	["Teleport player",[0],"",-5,[["expression", "player setPos _pos; ['Teleport player',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1","\A3\ui_f\data\IGUI\Cfg\Cursors\tactical_ca.paa"],
	["God mode for player",[0],"",-5,[["expression", "player allowDamage false; ['God mode for player',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1"],
	["God mode for group",[0],"",-5,[["expression", "_tmpGrp = group player; {_x allowDamage false;} forEach (units _tmpGrp); ['God mode for group',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1"],
	["Take leadership",[0],"",-5,[["expression", "[group player, player] remoteExec ['selectLeader', groupOwner group player]; ['Take leadership',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1"],
	["Disable all effects (player/group)",[0],"",-5,[["expression", "_tmpGrp = group player; {_x allowDamage true;} forEach (units _tmpGrp); ['Disable all effects (player/group)',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1"]
];

MENU_COMMS_DEBUG_MENU = [
	["Debug Menu", false],
	["Add to action menu",[0],"",-5,[["expression", "if (isNil {player getVariable 'addDebugActionMenu'}) then {player setVariable ['addDebugActionMenu',true]; _debugactionmenuid = player addAction ['Debug command', 'showCommandingMenu ""#USER:MENU_COMMS_DEBUG""',cursorTarget, 0, true, true, '', '']; player setVariable ['DebugActionMenu_id',_debugactionmenuid];}; ['Add to action menu',false,true,true,true] call BIS_fnc_NNS_debugOutput;"]],"1","1"],
	["Remove from action menu",[0],"",-5,[["expression", "player setVariable ['addDebugActionMenu',nil]; player removeAction (player getVariable ['DebugActionMenu_id',0]); ['Remove from action menu',false,true,true,true] call BIS_fnc_NNS_debugOutput;"]],"1","1"],
	["Enable debug output to chatbox",[0],"",-5,[["expression", "missionNamespace setVariable ['DebugOutputs_enable',true,true]; missionNamespace setVariable ['DebugOutputs_Chatbox',true,true]; ['Enable debug output to chatbox',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1"],
	["Disable debug output",[0],"",-5,[["expression", "missionNamespace setVariable ['DebugOutputs_Chatbox',false,true]; ['Disable debug output',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1"]
];

MENU_COMMS_DEBUG_TIME = [
	["Time", false],
	["Clock : 0:00",[0],"",-5,[["expression", "skipTime(-daytime+24)%24; ['Clock : 0:00',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1"],
	["Clock : 4:00",[0],"",-5,[["expression", "skipTime(4-daytime+24)%24; ['Clock : 4:00',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1"],
	["Clock : 8:00",[0],"",-5,[["expression", "skipTime(8-daytime+24)%24; ['Clock : 8:00',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1"],
	["Clock : 16:00",[0],"",-5,[["expression", "skipTime(16-daytime+24)%24; ['Clock : 16:00',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1"],
	["Clock : 22:00",[0],"",-5,[["expression", "skipTime(22-daytime+24)%24; ['Clock : 22:00',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1"],
	["Multiplier : 1x",[0],"",-5,[["expression", "setTimeMultiplier 1; ['Time Multiplier : 1x',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1"],
	["Multiplier : 2x",[0],"",-5,[["expression", "setTimeMultiplier 2; ['Time Multiplier : 2x',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1"],
	["Multiplier : 5x",[0],"",-5,[["expression", "setTimeMultiplier 5; ['Time Multiplier : 5x',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1"],
	["Multiplier : 10x",[0],"",-5,[["expression", "setTimeMultiplier 10; ['Time Multiplier : 10x',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1"],
	["Multiplier : 20x",[0],"",-5,[["expression", "setTimeMultiplier 20; ['Time Multiplier : 20x',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1"],
	["/!\ Multiplier : 120x",[0],"",-5,[["expression", "setTimeMultiplier 120; ['/!\ Time Multiplier : 120x',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1"]
];

MENU_COMMS_DEBUG_WEATHER = [
	["Weather", false],
	["Sunny, without Fog",[0],"",-5,[["expression", "86300 setOvercast 0; 86300 setRain 0; 86300 setFog 0;skipTime 24; ['Weather : Sunny, without Fog',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1"],
	["Sunny, with Fog",[0],"",-5,[["expression", "86300 setOvercast 0; 86300 setRain 0; 86300 setFog 0.5;skipTime 24; ['Weather : Sunny, with Fog',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1"],
	["Rain, without Fog",[0],"",-5,[["expression", "86300 setOvercast 1; 86300 setRain 1; 86300 setFog 0;skipTime 24; ['Weather : Rain, without Fog',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1"],
	["Rain, with Fog",[0],"",-5,[["expression", "86300 setOvercast 1; 86300 setRain 1; 86300 setFog 0.5;skipTime 24; ['Weather : Rain, with Fog',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1"]
];

MENU_COMMS_DEBUG_DESTRUCTION = [
	["Destruction", false],
	["Kill unit", [0], "", -5, [["expression", "_target setDamage 1; ['Kill unit',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]], "1", "1", "\A3\ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"],
	["Kill group", [0], "", -5, [["expression", "_tmpGrp = group _target;if((group player)!=_tmpGrp) then {{_x setDamage 1;} forEach (units _tmpGrp);}; ['Kill group',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]], "1", "1", "\A3\ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"],
	["Kill all enemies (500m)",[0],"",-5,[["expression", "_sidetokill = side player; if (side player == west) then {_sidetokill = east;} else {_sidetokill = west;}; {if (side _x == _sidetokill) then {_x setDamage 1;};} forEach nearestObjects [player, ['man'], 500]; ['Kill all enemies (500m)',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1"],
	["82mm Mortar (120m) on pointer",[0],"",-5,[["expression", "_null = [player,_pos,""mortar""] execVM 'scripts\ClusterBomb.sqf'; ['82mm Mortar (120m) on pointer',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1","\A3\ui_f\data\IGUI\Cfg\Cursors\selectOver_ca.paa"],
	["Cluster bomb (80m) on pointer",[0],"",-5,[["expression", "_null = [player,_pos,""cluster""] execVM 'scripts\ClusterBomb.sqf'; ['Cluster bomb (80m) on pointer',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1","\A3\ui_f\data\IGUI\Cfg\Cursors\selectOver_ca.paa"],
	["MK82 bomb on pointer",[0],"",-5,[["expression", "_null = [player,_pos,""mk82""] execVM 'scripts\ClusterBomb.sqf'; ['MK82 bomb on pointer',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1","\A3\ui_f\data\IGUI\Cfg\Cursors\attack_ca.paa"]
];

MENU_COMMS_DEBUG_SPAWN = [
	["Spawn/Delete on pointer", false],
	["Spawn Civilian vehicle",[0],"",-5,[["expression", "_veh = createVehicle [(selectRandom BIS_civilCars), _pos, [], 0, ""NONE""]; ['Spawn Civilian vehicle',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1","\A3\ui_f\data\IGUI\Cfg\Cursors\tactical_ca.paa"],
	["Spawn empty T-140K",[0],"",-5,[["expression", "_veh = createVehicle [""O_MBT_04_command_F"", _pos, [], 0, ""NONE""]; ['Spawn empty T-140K',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1","\A3\ui_f\data\IGUI\Cfg\Cursors\tactical_ca.paa"],
	["Spawn BLUFOR group",[0],"",-5,[["expression", "_newGrp = grpNull; _newGrp = [_pos, west, missionConfigFile >> ""CfgGroups"" >> ""West"" >> ""BLU_F"" >> ""Infantry"" >> ""EfM_W_Squad01"", [], [], [0.2, 0.3]] call BIS_fnc_spawnGroup; _newGrp deleteGroupWhenEmpty true; _newGrp enableDynamicSimulation true; ['Spawn BLUFOR group',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1","\A3\ui_f\data\IGUI\Cfg\Cursors\tactical_ca.paa"],
	["Spawn FIA group",[0],"",-5,[["expression", "_newGrp = grpNull; _newGrp = [_pos, east, missionConfigFile >> ""CfgGroups"" >> ""East"" >> ""OPF_G_F"" >> ""Infantry"" >> ""EfM_E_Squad01"", [], [], [0.2, 0.3]] call BIS_fnc_spawnGroup; _newGrp deleteGroupWhenEmpty true; _newGrp enableDynamicSimulation true; ['Spawn FIA group',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1","\A3\ui_f\data\IGUI\Cfg\Cursors\tactical_ca.paa"],
	["Delete unit", [0], "", -5, [["expression", "{_target deleteVehicleCrew _x} forEach crew _target; deleteVehicle _target; ['Delete unit',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]], "1", "1", "\A3\ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"],
	["Count all units", [0], "", -5, [["expression", "_null = execVM 'scripts\DebugCountUnits.sqf';"]], "1", "1"],
	["Count all units continuous", [0], "", -5, [["expression", "_null = execVM 'scripts\DebugCountUnitsLoop.sqf';"]], "1", "1"],
	["Count all units disable", [0], "", -5, [["expression", "missionNamespace setVariable ['DebugCountUnitsLoop',false,true];"]], "1", "1"]
];

MENU_COMMS_DEBUG_POINTER = [
	["Marker/Pointer", false],
	["Add Green arrows to player group",[0],"",-5,[["expression", "_tmpGrp = group player; {_null = [_x,'green',true] execVM 'scripts\AttachArrow.sqf';} forEach (units _tmpGrp); ['Add Green arrows to player group',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1"],
	["Remove arrows from player group",[0],"",-5,[["expression", "_tmpGrp = group player; {_oldhandle = _x getVariable ['debug_arrow_handle',-1]; if(_oldhandle!=-1) then {_x removeMPEventHandler ['MPRespawn', _oldhandle];}else{_x removeAllMPEventHandlers 'MPRespawn';}; _attached = attachedObjects _x; {deleteVehicle _x;} forEach (_attached); _x setVariable ['debug_arrow_handle',-1];} forEach (units _tmpGrp); ['Remove arrows from player group',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1"],
	["Add Blue arrows to BLUFOR units (500m)",[0],"",-5,[["expression", "_tmpGrp = group player; {if (((group _x) != _tmpGrp) && (side _x == west)) then {_null = [_x,'blue'] execVM 'scripts\AttachArrow.sqf';};} forEach nearestObjects [player, ['man'], 500]; ['Add Blue arrows to BLUFOR units (500m)',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1"],
	["Remove arrows from BLUFOR units",[0],"",-5,[["expression", "_tmpGrp = group player; {if (((group _x) != _tmpGrp) && (side _x == west)) then {_x removeAllMPEventHandlers 'MPKilled'; _attached = attachedObjects _x; {deleteVehicle _x;} forEach (_attached);};} forEach allUnits; ['Remove arrows from BLUFOR units',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1"],
	["Add Red arrows to OPFOR units (500m)",[0],"",-5,[["expression", "_tmpGrp = group player; {if (((group _x) != _tmpGrp) && (side _x == east)) then {_null = [_x,'red'] execVM 'scripts\AttachArrow.sqf';};} forEach nearestObjects [player, ['man'], 500]; ['Add Red arrows to OPFOR units (500m)',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1"],
	["Remove arrows from OPFOR units",[0],"",-5,[["expression", "_tmpGrp = group player; {if (((group _x) != _tmpGrp) && (side _x == east)) then {_x removeAllMPEventHandlers 'MPKilled'; _attached = attachedObjects _x; {deleteVehicle _x;} forEach (_attached);};} forEach allUnits; ['Remove arrows from OPFOR units',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1"],
	["Display triggers on map",[0],"",-5,[["expression", "_null = execVM 'scripts\DebugMapTriggers.sqf'; ['Display triggers on map',false,true,true,true] call BIS_fnc_NNS_debugOutput;"]],"1","1"],
	["Hide triggers on map",[0],"",-5,[["expression", "_tmp = player getVariable ['draw_debug_trigger_handle',objNull]; if !(_tmp isEqualTo objNull) then {(findDisplay 12 displayCtrl 51) ctrlRemoveEventHandler ['Draw', _tmp]; player setVariable ['draw_debug_trigger_handle',objNull];}; ['Hide triggers on map',false,true,true,true] call BIS_fnc_NNS_debugOutput;"]],"1","1"]
];

MENU_COMMS_DEBUG_EXTREME = [
	["Use with extreme caution", false],
	["Hide terrain objects (1km)",[0],"",-5,[["expression", "{_x hideObjectGlobal true;_x enableSimulationGlobal false;} foreach nearestTerrainObjects [player,[],1000]; ['Hide terrain objects (1km)',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1", "\A3\ui_f\data\IGUI\Cfg\Cursors\selectOver_ca.paa"],
	["Restore terrain objects (1km)",[0],"",-5,[["expression", "{_x setDamage 0;_x hideObjectGlobal false;_x enableSimulationGlobal true;} foreach nearestTerrainObjects [player,[],1000]; ['Restore terrain objects (1km)',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1", "\A3\ui_f\data\IGUI\Cfg\Cursors\selectOver_ca.paa"],
	["/!\ Destroy terrain objects (1km)",[0],"",-5,[["expression", "{_x setDamage 1;} foreach nearestTerrainObjects [player,[],1000]; ['/!\ Destroy terrain objects (1km)',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1", "\A3\ui_f\data\IGUI\Cfg\Cursors\selectOver_ca.paa"],
	["/!\ Remove objects (500m)",[0],"",-5,[["expression", "{if(group _x != group player && typeOf vehicle _x != 'Sign_Arrow_Large_Green_F') then {_x removeAllMPEventHandlers 'MPKilled';deleteVehicle _x;};} forEach nearestObjects [player, ['all'], 500]; ['/!\ Remove objects (500m)',false,true,false,true] call BIS_fnc_NNS_debugOutput;"]],"1","1", "\A3\ui_f\data\IGUI\Cfg\Cursors\selectOver_ca.paa"]
];


/*






attack_ca.paa
freelook_ca.paa
iconComplex_ca.paa    ***
iconCursorSupport_ca.paa
selectOver_ca.paa
tactical_ca.paa
weapon_ca.paa
board_ca.paa








*/
