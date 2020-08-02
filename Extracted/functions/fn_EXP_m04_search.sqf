private _count = count ([] call BIS_fnc_listPlayers);

// Send investigators
{
	[_x, _x getVariable "BIS_alt"] call BIS_fnc_setHeight;

	_x hideObjectGlobal false;
	_x enableSimulationGlobal true;
	_x allowDamage true;
	_x setCaptive false;
} forEach BIS_investigators;

// Choose random foot patrol
BIS_patrol1 = BIS_patrol1A;
if (random 1 >= 0.5) then {{deleteVehicle _x} forEach BIS_patrol1; BIS_patrol1 = BIS_patrol1B} else {{deleteVehicle _x} forEach BIS_patrol1B};

// Choose random technical patrol
BIS_patrol2 = BIS_patrol2A;
if (random 1 >= 0.5) then {{deleteVehicle _x} forEach BIS_patrol2; BIS_patrol2 = BIS_patrol2B} else {{deleteVehicle _x} forEach BIS_patrol2B};

// Choose random road patrol
BIS_patrol6 = BIS_patrol6A;
if (random 1 >= 0.5) then {{deleteVehicle _x} forEach BIS_patrol6; BIS_patrol6 = BIS_patrol6B} else {{deleteVehicle _x} forEach BIS_patrol6B};

if (_count == 1) then {
	// Randomize stockpile guards
	if (random 1 >= 0.5) then {
		private _units = BIS_stockpile - [BIS_stockpileQuad];
		private _delete = _units call BIS_fnc_selectRandom;
		BIS_stockpile = BIS_stockpile - [_delete];
		deleteVehicle _delete;
	};
};

// Send search parties
{
	if (isNull _x) then {
		// Remove deleted units
		BIS_searchers = BIS_searchers - [_x];
		BIS_flashlights = BIS_flashlights - [_x];
	} else {
		// Show remaining units
		if (vehicle _x == _x) then {[_x, _x getVariable "BIS_alt"] call BIS_fnc_setHeight};

		_x hideObjectGlobal false;
		_x enableSimulationGlobal true;
		_x allowDamage true;
		_x setCaptive false;

		if (!(_x isKindOf "Man")) then {BIS_searchers = BIS_searchers - [_x]};

		sleep 0.25;
	};
} forEach BIS_searchers;

{_x disableAI "MOVE"} foreach [BIS_reinf1_1,BIS_reinf1_2,BIS_reinf1_3,BIS_reinf1_4,BIS_reinf1_5,BIS_reinf1_6];

// Turn on vehicle lights and engines
{BIS_garrison1_1 action [_x, BIS_garrison1Truck2]} forEach ["LightOn", "EngineOn"];
{BIS_garrison2_1 action [_x, BIS_garrison2Truck1]} forEach ["LightOn", "EngineOn"];
{BIS_sentry1 action [_x, BIS_sentry1Quad]} forEach ["LightOn", "EngineOn"];
{BIS_sentry2 action [_x, BIS_sentry2Quad]} forEach ["LightOn", "EngineOn"];
{BIS_town1_1 action [_x, BIS_town1Truck1]} forEach ["LightOn", "EngineOn"];
{BIS_check2_1 action [_x, BIS_check2Truck1]} forEach ["LightOn", "EngineOn"];
{BIS_check3_1 action [_x, BIS_check3Truck1]} forEach ["LightOn", "EngineOn"];

// Unhide civilian
[BIS_town1Civ1, BIS_town1Civ1 getVariable "BIS_alt"] call BIS_fnc_setHeight;
BIS_town1Civ1 hideObjectGlobal false;
BIS_town1Civ1 enableSimulationGlobal true;
BIS_town1Civ1 setCaptive false;
BIS_town1Civ1 allowDamage true;

// Turn on stockpile quad
private _unit = BIS_stockpile select 1;
{_unit action [_x, BIS_stockpileQuad]} forEach ["LightOn", "EngineOn"];

// Turn on weapon flashlights
[] spawn {
	scriptName "BIS_fnc_EXP_m04_search: force flashlights";

	private _time = time + 60;

	while {time < _time} do {
		// Force flashlights
		{if (alive _x) then {_x enableGunLights "forceOn"}} forEach BIS_flashlights;
		sleep 5;
	};
};

// Start alert control
{_x call BIS_fnc_EXP_m04_searchAlert} forEach BIS_searchers;
[] spawn BIS_fnc_EXP_m04_alert;

true