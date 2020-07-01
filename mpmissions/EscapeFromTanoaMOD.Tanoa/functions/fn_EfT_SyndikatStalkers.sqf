/*
Create Syndikat group and let it stalk players - as they are spawned in jungle, set aimingAccuracy to very low
*/

// Params
params
[
	["_axisX",0,[999]], // X axis
	["_axisY",0,[999]] // Y axis
];

_newGrp = grpNull;
_newGrp = [[_axisX,_axisY,0], Resistance, configFile >> "CfgGroups" >> "Indep" >> "IND_C_F" >> "Infantry" >> (selectRandom ["BanditCombatGroup","BanditFireTeam","BanditShockTeam"]), [], [], [0.2, 0.2]] call BIS_fnc_spawnGroup;

//NNS: higher enemy amount
if (BIS_EnemyAmount > 0) then {
	format ["I_C_Soldier_Bandit_%1_F", 1 + ceil(random 7)] createUnit [_newGrp, _newGrp, "", 0.5, "PRIVATE"];
	format ["I_C_Soldier_Bandit_%1_F", 1 + ceil(random 7)] createUnit [_newGrp, _newGrp, "", 0.5, "PRIVATE"];
};

if (BIS_EnemyAmount > 1) then {
	format ["I_C_Soldier_Bandit_%1_F", 1 + ceil(random 7)] createUnit [_newGrp, _newGrp, "", 0.5, "PRIVATE"];
	format ["I_C_Soldier_Bandit_%1_F", 1 + ceil(random 7)] createUnit [_newGrp, _newGrp, "", 0.5, "PRIVATE"];
};

// Enable Dynamic simulation
_newGrp enableDynamicSimulation true;

{_x setSkill ["aimingAccuracy",0.05]} forEach (units _newGrp);
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach units _newGrp};

// Stalk players
waitUntil {sleep 5; simulationEnabled (leader _newGrp)};

_stalk = [_newGrp,group (allPlayers select 0)] spawn BIS_fnc_stalk;
/*
waitUntil {sleep 5; {(_x distance leader _newGrp) < (1500)} count allPlayers == 0};
{deleteVehicle _x} forEach (units _newGrp);
deleteGroup _newGrp;
*/
