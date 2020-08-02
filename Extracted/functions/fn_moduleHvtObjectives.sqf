#define INSTANCE 	{ _this call BIS_fnc_moduleHvtObjectivesInstance; }
#define OBJECTIVE 	{ _this call BIS_fnc_moduleHvtObjective; }

private ["_logic", "_units", "_activated"];
_logic 		= _this param [0, objNull, [objNull]];
_units 		= _this param [1, [], [[]]];
_activated 	= _this param [2, true, [true]];

if (_activated) then
{
	// The type of module
	switch (typeOf _logic) do
	{
		case "ModuleHvtObjectivesInstance_F" :
		{
			private ["_endGameThreshold"];
			_endGameThreshold = _logic getVariable ["EndGameThreshold", 3];

			["Initialize", [_logic, _endGameThreshold]] call INSTANCE;
		};

		case "ModuleHvtSimpleObjective_F" :
		{
			_logic setVariable ["typeCustom", "Simple"];
		};

		case "ModuleHvtStartGameObjective_F" :
		{
			_logic setVariable ["typeCustom", "StartGame"];
		};

		case "ModuleHvtEndGameObjective_F" :
		{
			_logic setVariable ["typeCustom", "EndGame"];
		};
	};
};

true;