/*
	Generates simple object config data.

	Parameters:
		0: OBJECT or ARRAY - ground position where ground objects will be created (default: position calculated 15 meters away from player)
		1: SCALAR or BOOL - autolog mode (default: false)
			0 or false - no autolog, results will be only stored in clipboard
			1 or true - autolog on, results will be stored in \A3\macros_CfgVehicles_simpleObject_auto_A3.hpp file.
			2 - autlog on + world name, random number and custom suffix are appended to name of generated file to prevent overwriting and provide extra info
		2: ARRAY - classes you want to scan, use [] to scan all (default: []).
		3: OBJECT or ARRAY - sea position where ground objects will be created (default: position calculated 15 meters away from player)
		4: STRING - custom suffix added to filename if autolog is used (default: "").


	Example:
	bis_scriptHandle = [] spawn bis_fnc_diagMacrosSimpleObject;

	Expected output per class (animate and hide arrays can have varying amount of elements):
	#define CFGVEHICLES_SIMPLEOBJECT_class_F\
		class SimpleObject\
		{\
			animate[] =\
			{\
				{"animationName1", 1},\
				{"animationName2", 2}\
			};\
			hide[] =\
			{\
				"animationSelection1",\
				"animationSelection2"\
			};\
			verticalOffsetAsl = 0;\
		};
*/

#define ROUND_DECIMALS(input,accuracy)	round((1/accuracy)*(input))*accuracy
#define GET_OBJECTS						((allMissionObjects "all") + (allSimpleObjects []) - [player])
#define DELETE_OBJECTS(objects)			{deleteVehicle _x} forEach ##objects##;waitUntil{sleep 0.1;{!isNull _x} count ##objects## == 0};##objects## = [];

#define BLOCKED_MODELS					["","\a3\weapons_f\empty.p3d","\a3\weapons_f\dummyweapon.p3d","\a3\weapons_f\dummyweapon_single.p3d","\a3\weapons_f\dummylauncher_single.p3d","\a3\weapons_f\dummypistol_single.p3d"]
#define BLOCKED_TYPES					["man","moduleempty_f","thingeffect","logic","reammobox","lasertarget","nvtarget","artillerytarget","firesectortarget","rope","windanomaly","object","placed_chemlight_green","nvg_targetbase","placed_b_ir_grenade","sound","parachutebase"]

#define STEPS							25

private _pos	  		= param [0, getPos player vectorAdd [0,15,0], [[],objNull]]; if (_pos isEqualType objNull) then {_p = getPos _pos; deleteVehicle _pos; _pos = _p;}; _pos set [2,0];
private _autolog 		= param [1, false, [true,123]];				//0 == false, 1 == true, 2 == true && append extra stuff to the generated filename
private _filter 		= param [2, [], [[],{}]];
private _posSea	  		= param [3, getPos player vectorAdd [0,15,0], [[],objNull]]; if (_posSea isEqualType objNull) then {_p = getPos _posSea; deleteVehicle _posSea; _posSea = _p;}; _posSea set [2,0];
private _logCurrent		= param [4, false, [true]];
private _fileNameSuffix = param [5, "", [""]]; if (_fileNameSuffix != "") then {_fileNameSuffix = "_" + _fileNameSuffix};

private _verticalOffsetIssues = [];

if (_autolog isEqualType 123 && {!(_autolog in [0,1,2,3])}) exitWith {["[x] Parameter 'autolog' valid values are: %1",[0,1,2,3]] call bis_fnc_error};

//re-type bool to scalar
_autolog = [0,1,2,3] select _autolog;

private _filename =	switch (_autolog) do
{
	case 1:
	{
		format["A3\macros_CfgVehicles_simpleObject_auto_A3%1.hpp",_fileNameSuffix];
	};
	case 2:
	{
		format["A3\macros_CfgVehicles_simpleObject_auto_A3_%1_%2%3.hpp",worldName,round random 1000,_fileNameSuffix];
	};
	case 3:
	{
		format["A3\macros_CfgVehicles_simpleObject_manual_A3%1.hpp",_fileNameSuffix];
	};
	default
	{
		""
	};
};

private _path = configFile >> "cfgVehicles";

private _pathText = toUpper configName _path;
private _br = if (_autolog > 0) then {toString [10]} else {toString [13,10]};
private _brMacro =  "\" + _br;

//get list of class names that will be processed
private _result = (_path call bis_fnc_returnChildren) apply {configName _x};
private _resultCount = 0;
private _resultText = "";

//apply classname filter
if (_filter isEqualType []) then
{
	if (count _filter > 0) then
	{
		{
			private _class = _x;
			if ({_class == _x} count _result == 0) then {_filter set [_forEachIndex,""]};
		}
		forEach (_filter arrayIntersect _filter); //remove duplicities & process

		_result = _filter - [""];
	};
}
else
{
	_result = _result select _filter;
};

//sort class names alphabetically so that the resulting output can be easilly diff-ed in SVN
_result = _result call BIS_fnc_sortAlphabetically;
_resultCount = count _result;

//macro header
if (_autolog > 0) then
{
_resultText =
"/*
	Automatic export of simpleObject values

	Execute following code to pring the output:
	0 = [] spawn bis_fnc_diagMacrosSimpleObject;

	Function automatically copies result to clipboard. It is also stored in a global variable bis_fnc_diagMacrosSimpleObject_resultText and saved to A3 folder via Julien's extension.
	Simply select all defines (Ctrl + Shift + End from the first item) and paste the new result.

	macros_CfgVehicles_simpleObject_manual_A3.hpp document contains manual replacements of certain defines
*/
////END-OF-HEADER MARK, FOR AUTOMATIC GENERATOR////
";

//clean the macro file and fill it with the header
"bi_Logger" callExtension format["%1<<trunc<<%2",_filename,_resultText];
};

{
	private ["_animateText","_hideText"];

	hintSilent format ["Progress: %1%2",floor(_forEachIndex / (_resultCount max 1) * 1000)/10,"%"];

	private _class = _x;

	//make sure there are no leftovers
	private _objects = GET_OBJECTS;
	if (count _objects > 0) then {DELETE_OBJECTS(_objects)};

	/*----------------------------------------------------------------------------------------------

		CALCULATE VALUES FOR PARAMETERS

	----------------------------------------------------------------------------------------------*/

	private _animate = [];	//[["animationName1", 1], ["animationName2", 2]];
	private _hide = [];		//["animationSelection1", "animationSelection2"];
	private _verticalOffsetAsl = 0;
	private _verticalOffsetWorld = 0;
	private _scope = getNumber(configfile >> "CfgVehicles" >> _class >> "scope");

	if (_scope > 0) then
	{
		private _model = toLower getText(configfile >> "CfgVehicles" >> _class >> "model");

		if (_model in BLOCKED_MODELS || {{_class isKindOf _x} count BLOCKED_TYPES > 0}) exitWith {};

		if (_logCurrent) then {["[ ] Processing class: %1",_class] call bis_fnc_logFormat;};

		private _position = [_pos,_posSea] select (_class isKindOf "ship");

		private _object = createVehicle [_class, _position, [], 0, "NONE"];

		//disable and repos object
		if ({_class isKindOf _x} count ["air","ship","tank","car","staticweapon"] == 0) then
        {
            _object enableSimulation false;
        };

		private _heightWorldDisabled = getPosWorld _object select 2;
		private _heightATLDisabled = getPosATL _object select 2;

		private _data 			= [_object,true] call BIS_fnc_simpleObjectData;
		_animate 				= _data select 4;	// [["animationName1", 1], ["animationName2", 2]];
		_hide 					= _data select 5;	// ["animationSelection1", "animationSelection2"];

		if ({_class isKindOf _x} count ["air","ship","tank","car","staticweapon"] > 0) then
		{
			private _verticalOffsetAsl_start = _data select 3;
			private _verticalOffsetWorld_start = ROUND_DECIMALS((getPosWorld _object select 2) - _heightWorldDisabled, 0.001);

			private _heightASL_collection = [];
			private _heightATL_collection = [];
			private _heightWorld_collection = [];

			for "_i" from 1 to STEPS do
			{
				_heightASL_collection pushBack (getPosASL _object select 2);
				_heightATL_collection pushBack (getPosATL _object select 2);
				_heightWorld_collection pushBack (getPosWorld _object select 2);

				sleep 0.1;
			};

			//compute avg heights (needed for further computing)
			private _heightASL_avg = 0; {_heightASL_avg = _heightASL_avg + _x} forEach _heightASL_collection; _heightASL_avg = _heightASL_avg / STEPS;
			private _heightATL_avg = 0; {_heightATL_avg = _heightATL_avg + _x} forEach _heightATL_collection; _heightATL_avg = _heightATL_avg / STEPS;
			private _heightWorld_avg = 0; {_heightWorld_avg = _heightWorld_avg + _x} forEach _heightWorld_collection; _heightWorld_avg = _heightWorld_avg / STEPS;

			//compute min,max offsets
			private _verticalOffsetAsl_min = +_heightASL_collection;
			_verticalOffsetAsl_min sort true;
			_verticalOffsetAsl_min = ROUND_DECIMALS((_verticalOffsetAsl_min param [0,0]) - _heightASL_avg, 0.001);
			private _verticalOffsetAsl_max = +_heightASL_collection;
			_verticalOffsetAsl_max sort false;
			_verticalOffsetAsl_max = ROUND_DECIMALS((_verticalOffsetAsl_max param [0,0]) - _heightASL_avg, 0.001);
			private _verticalOffsetWorld_min = +_heightWorld_collection;
			_verticalOffsetWorld_min sort true;
			_verticalOffsetWorld_min = ROUND_DECIMALS((_verticalOffsetWorld_min param [0,0]) - _heightWorld_avg, 0.001);
			private _verticalOffsetWorld_max = +_heightWorld_collection;
			_verticalOffsetWorld_max sort false;
			_verticalOffsetWorld_max = ROUND_DECIMALS((_verticalOffsetWorld_max param [0,0]) - _heightWorld_avg, 0.001);

			//compute avg 'verticalOffsetAsl' and 'verticalOffsetWorld'
			if (_object isKindOf "ship") then
			{
				_verticalOffsetAsl = ROUND_DECIMALS(_heightWorld_avg - _heightASL_avg, 0.001);
				_verticalOffsetWorld = ROUND_DECIMALS(_heightWorld_avg - _heightWorldDisabled, 0.001);
			}
			else
			{
				_verticalOffsetAsl = ROUND_DECIMALS(_heightWorld_avg - _heightASL_avg + _heightATL_avg, 0.001);
				_verticalOffsetWorld = ROUND_DECIMALS(_heightWorld_avg - _heightWorldDisabled + _heightATLDisabled, 0.001);
			};

			private _verticalOffsetAsl_delta = [abs(_verticalOffsetAsl_start - _verticalOffsetAsl),abs _verticalOffsetAsl_min,abs _verticalOffsetAsl_max];
			_verticalOffsetAsl_delta sort false;
			_verticalOffsetAsl_delta = _verticalOffsetAsl_delta param [0,0];

			private _verticalOffsetWorld_delta = [abs(_verticalOffsetWorld_start - _verticalOffsetWorld),abs _verticalOffsetWorld_min,abs _verticalOffsetWorld_max];
			_verticalOffsetWorld_delta sort false;
			_verticalOffsetWorld_delta = _verticalOffsetWorld_delta param [0,0];

			if (_verticalOffsetAsl_delta > 0.02) then {_verticalOffsetIssues pushBack format ["[!][Asl][%1] error: %6| min-max: [%4,%5] | avg: %2 | start: %3",_class,_verticalOffsetAsl,_verticalOffsetAsl_start,_verticalOffsetAsl_min,_verticalOffsetAsl_max,abs(_verticalOffsetAsl-_verticalOffsetAsl_start)]};
			if (_verticalOffsetWorld_delta > 0.02) then {_verticalOffsetIssues pushBack format ["[!][Wrd][%1] error: %6| min-max: [%4,%5] | avg: %2 | start: %3",_class,_verticalOffsetWorld,_verticalOffsetWorld_start,_verticalOffsetWorld_min,_verticalOffsetWorld_max,abs(_verticalOffsetWorld-_verticalOffsetWorld_start)]};
		}
		else
		{
			_verticalOffsetAsl = _data select 3;
			_verticalOffsetWorld = ROUND_DECIMALS((getPosWorld _object select 2) - _heightWorldDisabled, 0.001);
		};

		private _initAnims 		= _data select 8;
		private _initTexs 		= _data select 9;

		//prevent unneeded definitions created by rounding errors
		if (abs _verticalOffsetAsl < 0.002) then {_verticalOffsetAsl = 0};

		private _timeMax = time + 10;

		//repos object to makes sure it cannot collide with other objects on the spawn point, if not properly deleted
		_object setPos [100,100,0];

		waitUntil
		{
			deleteVehicle _object;
			sleep 0.05;

			isNull _object || {time > _timeMax}
		};

		if (!isNull _object) then {["[x] Object %1 classname %2 wasn't deleted!",_object,_class] call bis_fnc_logFormat;};

		private _simulation = toLower getText(configfile >> "CfgVehicles" >> _class >> "simulation");
		private _eden = if (_scope == 2 && {_simulation in ["airplanex","car","carx","helicopterrtd","shipx","submarinex","tankx","thing","thingx"]}) then {1} else {0};

		/*----------------------------------------------------------------------------------------------

			FORMAT ANIMATE PARAMETER

		----------------------------------------------------------------------------------------------*/
		//prepare substring with "animate" config parameter
		private _animateCount = count _animate;

		//if _animate is not an empty array...
		if (_animateCount > 0) then
		{
			//format opening text
			_animateText = "		animate[] =" + _brMacro + "		{" + _brMacro;

			//format individual elements of the _animate array
			{
				if (count _x == 2) then
				{
					//format an element (= a pair)
					_animateText = _animateText + format ["			{""%1"", %2}", (_x select 0), (_x select 1)];

					//append a comma after each but the last element
					if (_forEachIndex < (_animateCount - 1)) then
					{
						_animateText = _animateText + ",";
					};

					//append newline
					_animateText = _animateText + _brMacro;
				}
				//if an element in _animate is not a pair (array of size 2). Should never happen, but... you know ;)
				else
				{
					["[x] Animate array for class %1 contains a non-pair element. Element excluded from output.", _class] call bis_fnc_error;
				};
			}
			forEach _animate;

			//format closing text
			_animateText = _animateText + "		};" + _brMacro;
		}
		//if _animate is an empty array...
		else
		{
			_animateText = "		animate[] = {};" + _brMacro;
		};

		/*----------------------------------------------------------------------------------------------

			FORMAT HIDE PARAMETER

		----------------------------------------------------------------------------------------------*/
		//prepare substring with "hide" config parameter
		private _hideCount = count _hide;

		//if _hide is not an empty array...
		if (_hideCount > 0) then
		{
			//format opening text
			_hideText = "		hide[] =" + _brMacro + "		{" + _brMacro;

			//format individual elements of the _hide array
			{
				//format an element
				_hideText = _hideText + format ["			""%1""", _x];

				//append a comma after each but the last element
				if (_forEachIndex < (_hideCount - 1)) then
				{
					_hideText = _hideText + ",";
				};

				//append newline
				_hideText = _hideText + _brMacro;
			}
			forEach _hide;

			//format closing text
			_hideText = _hideText + "		};" + _brMacro;
		}
		//if _animate is an empty array...
		else
		{
			_hideText = "		hide[] = {};" + _brMacro;
		};

		//do not create macro if there are only default values
		if (_eden == 0 && {_verticalOffsetAsl == 0 && {_verticalOffsetWorld == 0 && {_animateCount == 0 &&  {_hideCount == 0}}}}) exitWith {};


		/*----------------------------------------------------------------------------------------------

			FORMAT VERTICALOFFSETS & SCOPE PARAMETERS

		----------------------------------------------------------------------------------------------*/

		//prepare substring with "verticalOffsetAsl" config parameter
		_verticalOffsetAsl 		= format ["		verticalOffset = %1;\", _verticalOffsetAsl] + _br;
		_verticalOffsetWorld 	= format ["		verticalOffsetWorld = %1;\", _verticalOffsetWorld] + _br;
		_eden 					= format ["		eden = %1;\", _eden] + _br;

		private _init = if (_initAnims || _initTexs) then
		{
			"		init = [this, '', []] call bis_fnc_initVehicle;\" + _br;
		}
		else
		{
			"		init = '';\" + _br;
		};

		private _singleEntry =
			"#define " + _pathText + "_SIMPLEOBJECT_" + _x + _brMacro +
			"	class SimpleObject" + _brMacro +
			"	{" + _brMacro +
					_eden +
					_animateText +
					_hideText +
					_verticalOffsetAsl +
					_verticalOffsetWorld +
					_init +
			"	};" + _br +
			_br;

		//print the new entry into the macro file
		if (_autolog > 0) then
		{
			"bi_Logger" callExtension format["%1<<app<<%2",_filename,_singleEntry];
		};

		/*----------------------------------------------------------------------------------------------

			CONSTRUCT FINAL OUTPUT

		----------------------------------------------------------------------------------------------*/
		//build complete string for one config class (which is in _class)
		_resultText = _resultText + _singleEntry;
	};
}
forEach _result;

//to make sure we have it somewhere in case clipboard is overriden
bis_fnc_diagMacrosSimpleObject_resultText = _resultText;
bis_fnc_diagMacrosSimpleObject_verticalOffsetIssues = _verticalOffsetIssues;

copyToClipboard _resultText;
hint "Finished diagMacrosSimpleObject";

["[!] Script 'diagMacrosSimpleObject' completed!"] call bis_fnc_logFormat;

if (count _verticalOffsetIssues > 0) then
{
	["[!] Following issues in vertical offsets (World or ASL) detected:"] call bis_fnc_logFormat;
	["[!] -------------------------------------------------------------"] call bis_fnc_logFormat;

	{["%1",_x] call bis_fnc_logFormat} forEach _verticalOffsetIssues;
};

_resultText