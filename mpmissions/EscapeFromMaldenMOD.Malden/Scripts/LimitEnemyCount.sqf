/*
NNS : Limit number of enemies by removing certain building

example : [] execVM 'scripts\LimitEnemyCount.sqf';
*/

_enable = false;
if !(isNil "BIS_LimitEnemyCount") then {_enable = BIS_LimitEnemyCount;};
if !(_enable) exitWith {["LimitEnemyCount.sqf : Not limiting enemy amount"] call BIS_fnc_NNS_debugOutput;};

_building_list = [
BIS_Tower_SaintLouis,
BIS_Tower_Larche,
BIS_Tower_LaTrinite1,
BIS_Tower_LaTrinite2,
BIS_Tower_Arudy,
BIS_Tower_Pessagne,
BIS_Tower_Chapoi,
BIS_Tower_Port2,
BIS_Tower_Port3,
BIS_Tower_Houdan,
BIS_Tower_Dourdan,
checkpoint_03_tower_0,
objective_9_tower_1,
objective_9_tower_0];


// delete object from the list
{
	if !(_x isEqualTo objNull) then {
		[format["LimitEnemyCount.sqf : %1 deleted",_x]] call BIS_fnc_NNS_debugOutput;
		deleteVehicle _x;
	};
} forEach _building_list;
