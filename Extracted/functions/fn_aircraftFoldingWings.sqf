/*
	Author: Bravo Zero One development
	- John_Spartan

	Description:
	- This function is designed to prevent take off with folded wings on the Jets DLC aircraft that have such useraction/function enabled.

	Exucution:
	- Call the function via int EH on each aircrfat config
		class Eventhandlers: Eventhandlers
		{
			engine = "_this call bis_fnc_aircraftFoldingWings";
			gear = "_this call bis_fnc_aircraftFoldingWings";
		};

	Requirments:
	- Compatible aircrfat must have a config definition for all subsytems that will be invoked by this function

		example of cfgVehicles subclass definitions;
		class AircraftAutomatedSystems
		{
			wingStateControl = 1;																				//enable automated wing state control to prevent player to take off with folded wings
			wingFoldAnimations[] = {"wing_fold_l","wing_fold_r","wing_fold_cover_l", "wing_fold_cover_r"};		//foldable wing animation list
			wingStateFolded = 1;																				//animation state when folded
			wingStateUnFolded = 0;																				//animation state when un-folded
			wingAutoUnFoldSpeed = 40;																			//speed treshold when triger this feature, and unfold wings for player

		};

	Parameter(s):
		_this select 0: mode (Scalar)
		0: plane/object


	Returns: nothing
	Result: Aircrfat should not be able to take off/ fly with wings folded

*/

private _plane = param [0, objNull]; if (isNull _plane || {!local _plane || {!alive _plane}}) exitWith {};
private _state = param [1, false, [true]];

private _script = _plane getVariable ["bis_wingsCheckScript",scriptNull];

//start the script
if (_state) then
{
	if (!isNull _script) exitWith {};

	_script = _plane spawn
	{
		scriptName "bis_fnc_aircraftFoldingWings_automatedUnfolding";

		params ["_plane"];

		private _configPath = configFile >> "CfgVehicles" >> typeOf _plane  >> "AircraftAutomatedSystems";

		private _wingStateControl 		= (_configPath >> "wingStateControl") call BIS_fnc_getCfgDataBool;	if (!_wingStateControl) exitWith {};
		private _wingFoldAnimationsList = (_configPath >> "wingFoldAnimations" ) call BIS_fnc_getCfgData;
		private _wingStateFolded 		= (_configPath >> "wingStateFolded") call BIS_fnc_getCfgData;
		private _wingStateUnFolded 		= (_configPath >> "wingStateUnFolded") call BIS_fnc_getCfgData;
		private _wingAutoUnFoldSpeed 	= (_configPath >> "wingAutoUnFoldSpeed") call BIS_fnc_getCfgData;

		while {alive _plane && local _plane} do
		{
			waitUntil
			{
				sleep 0.1;
				getPos _plane select 2 < 1
			};

			{
				if (_plane animationPhase _x >= _wingStateFolded) then
				{
					if (isEngineOn _plane && speed _plane > _wingAutoUnFoldSpeed) then
					{
						_plane animate [_x,_wingStateUnFolded];
					};
				};
			}
			foreach _wingFoldAnimationsList;

			sleep 1.0;
		};
	};

	_plane setVariable ["bis_wingsCheckScript",_script];

	//["[ ] Wing state check script running (%1).",_script] call bis_fnc_logFormat;
}
//terminate script
else
{
	if (isNull _script) exitWith {};

	//["[ ] Wing state check script (%1) terminated!",_script] call bis_fnc_logFormat;

	terminate _script;
	_plane setVariable ["bis_wingsCheckScript",scriptNull];
};