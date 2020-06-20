/*
NNS: used to collect intel

example, add into init of a object: this addAction ["displayed text", "scripts\Intel.sqf", "variable_to_trigger", 1.5, true, true, "", "(side _this == side_that_trigger)", 4, false, "", ""];

Possible _arguments usage, also work with a group of argument:
["none"] -> no additionnal action to do.
["setvar","target","MyVariable",value] -> set MyVariable to wanted value for target, will always be global, basically, it is setVariable function.
["markeralpha","target",value] -> alias from setMarkerAlpha
["execvm","script.sqf",[paramslist],remote] -> alias from execVM, if remote is true, execVM will be passed remotely, local if not set




*/

params
[
	["_target",objNull],
	["_caller",objNull],
	["_actionId",objNull],
	["_arguments",[],[]]
];

_actionCompleted = false;

ExecArguments = { //parse and do argument 
	params ["_argument"];
	
	[format ["Intel.sqf : _argument: %1",_argument]] call BIS_fnc_NNS_debugOutput; //debug
	
	if ((_argument select 0) == "none") then {_actionCompleted = true;}; //nothing to do

	if ((_argument select 0) == "setvar") then {(_argument select 1) setVariable [format ["%1", (_argument select 2)], (_argument select 3), true]; _actionCompleted = true;}; //setvar = setVariable alias
	
	if ((_argument select 0) == "markeralpha") then {(_argument select 1) setMarkerAlpha (_argument select 2); _actionCompleted = true;}; //markeralpha = setMarkerAlpha alias
	
	if ((_argument select 0) == "execvm") then { //execvm = execVM alias
		_remoterun = false; if (count _argument == 4) then {_remoterun = _argument select 3;};
		if !(_remoterun) then {_null = (_argument select 2) execVM (_argument select 1); //local run
		} else {[(_argument select 2), (_argument select 1)] remoteExec ["execVM", 0, true];}; //remote
		_actionCompleted = true;
	};
	
	
};









if (count _arguments == 0) exitWith {["Intel.sqf : wrong arguments"] call BIS_fnc_NNS_debugOutput;};

if (typeName (_arguments select 0) == "ARRAY") then {{[_x] call ExecArguments;} forEach _arguments; //group of arguments
} else {[_arguments] call ExecArguments;}; //single argument

if !(_actionCompleted) then {["Intel.sqf : warning, no valid argument passed, typo?"] call BIS_fnc_NNS_debugOutput;};

[name player, localize "STR_NNS_Escape_CollectIntel_collected"] remoteExec ["BIS_fnc_showSubtitle",0,true];
[_target] remoteExec ["removeAllActions",0,true]; //remove action for all clients and JIP


_bgtextures = [
"\a3\missions_f_gamma\data\img\whiteboards\whiteboard_faction_blufor_air_co.paa",
"\a3\missions_f_gamma\data\img\whiteboards\whiteboard_faction_blufor_autonomous_co.paa",
"\a3\missions_f_gamma\data\img\whiteboards\whiteboard_faction_blufor_expo_co.paa",
"\a3\missions_f_gamma\data\img\whiteboards\whiteboard_faction_blufor_ground_co.paa",
"\a3\missions_f_gamma\data\img\whiteboards\whiteboard_faction_blufor_water_co.paa",
"\a3\missions_f_gamma\data\img\whiteboards\whiteboard_faction_blufor_weapons_co.paa",
"\a3\missions_f_gamma\data\img\whiteboards\whiteboard_faction_independent_air_co.paa",
"\a3\missions_f_gamma\data\img\whiteboards\whiteboard_faction_independent_autonomous_co.paa",
"\a3\missions_f_gamma\data\img\whiteboards\whiteboard_faction_independent_expo_co.paa",
"\a3\missions_f_gamma\data\img\whiteboards\whiteboard_faction_independent_ground_co.paa",
"\a3\missions_f_gamma\data\img\whiteboards\whiteboard_faction_independent_water_co.paa",
"\a3\missions_f_gamma\data\img\whiteboards\whiteboard_faction_independent_weapons_co.paa",
"\a3\missions_f_gamma\data\img\whiteboards\whiteboard_faction_opfor_air_co.paa",
"\a3\missions_f_gamma\data\img\whiteboards\whiteboard_faction_opfor_autonomous_co.paa",
"\a3\missions_f_gamma\data\img\whiteboards\whiteboard_faction_opfor_expo_co.paa",
"\a3\missions_f_gamma\data\img\whiteboards\whiteboard_faction_opfor_ground_co.paa",
"\a3\missions_f_gamma\data\img\whiteboards\whiteboard_faction_opfor_water_co.paa",
"\a3\missions_f_gamma\data\img\whiteboards\whiteboard_faction_opfor_weapons_co.paa",
"\a3\missions_f_gamma\data\img\whiteboards\whiteboard_sp_fd05_co.paa",
"\a3\missions_f_gamma\data\img\whiteboards\whiteboard_sp_fd07_co.paa",
"\a3\missions_f_gamma\data\img\whiteboards\whiteboard_sp_fd06_co.paa",
"\a3\missions_f_gamma\data\img\whiteboards\whiteboard_sp_fd08_co.paa",
"\a3\missions_f_gamma\data\img\whiteboards\whiteboard_sp_fd09_co.paa",
"\a3\missions_f_gamma\data\img\whiteboards\whiteboard_sp_fd10_co.paa",
"\a3\missions_f_epa\data\img\whiteboards\mapboard_altis_c_in1_co.paa",
"\a3\missions_f_epa\data\img\whiteboards\mapboard_stratis_c_in1_co.paa",
"\a3\missions_f_epa\data\img\whiteboards\whiteboard_a_in_camp_co.paa",
"\a3\missions_f_epa\data\img\whiteboards\whiteboard_a_in_lz_co.paa",
"\a3\missions_f_epa\data\img\whiteboards\whiteboard_briefing_a_m01_co.paa",
"\a3\missions_f_epa\data\img\whiteboards\whiteboard_briefing_a_m02_co.paa",
"\a3\missions_f_epa\data\img\whiteboards\whiteboard_briefing_a_m03_co.paa",
"\a3\missions_f_epa\data\img\whiteboards\whiteboard_briefing_a_m04_co.paa",
"\a3\missions_f_epa\data\img\whiteboards\whiteboard_briefing_a_m05_co.paa",
"\a3\missions_f_epa\data\img\whiteboards\whiteboard_briefing_a_out_co.paa",
"\a3\missions_f_epa\data\img\papermaps\papermap_briefing_b_hub01_co.paa",
"\a3\missions_f_epa\data\img\papermaps\papermap_briefing_b_m01_co.paa",
"\a3\missions_f_epa\data\img\papermaps\papermap_briefing_b_m02_co.paa",
"\a3\missions_f_epa\data\img\papermaps\papermap_briefing_b_m03_co.paa",
"\a3\missions_f_epa\data\img\papermaps\papermap_briefing_b_m05_co.paa",
"\a3\missions_f_epa\data\img\papermaps\papermap_briefing_b_m06_co.paa",
"\a3\missions_f_epa\data\img\papermaps\papermap_briefing_b_out2_co.paa"
];

for [{_i=0},{_i<7},{_i=_i+1}] do {
	_rnd = _bgtextures call BIS_fnc_selectRandom;
	_target setObjectTextureGlobal [0,_rnd];
	sleep .5;
}; 
_target setObjectTextureGlobal [0,"#(rgb,8,8,3)color(0,0,0,1)"];