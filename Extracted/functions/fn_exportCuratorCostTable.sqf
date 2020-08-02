/*
	Author: Karel Moricky

	Description:
	Generate spreadsheet with object classes and copy it to clipboard.
	The table will generate export code to be used in BIS_fnc_curatorObjectRegisteredTable

	Parameter(s):
		0 (Optional): ARRAY of STRINGs - supported addons (classes from CfgPatches). When empty, all preloaded addons will be added. Use empty string to export just the cost calculation.
		1 (Optional): STRING - format, can be "ods" or "xls"
		2 (Optional): STRING - name of sheet with cost calculation. When empty, the calculation will be inserted on top of the table
		3 (Optional): ARRAY of SIDEs or NUMBERs - filter only objects of listed sides or side IDs. Supported sides are west, east, resistance, civilian, sideUnknown and sideLogic
		4 (Optional): CODE - condition for class to be listed. Config path to the class is passed as an argument (default: {true})
		5 (Optional): CODE - default cost, must return STRING. When empty string is returned, no default cost will be used (default: {""})

	Returns:
	BOOL
*/

startloadingscreen [""];

_defaultCode = {
	private ["_class","_curator"];
	_class = configname _this;
	_curator = getassignedcuratorlogic player;
	if (isnull _curator) then {
		""
	} else {
		private ["_return"];
		_return = "";
		{
			if (_class == (_x select 0)) exitwith {_return = if (_x select 1) then {str (_x select 2)} else {""};};
		} foreach (curatorregisteredobjects _curator);
		_return
	};
};

_addons = _this param [0,[],[[]]];
_format = _this param [1,"ods",[""]];
_sheetCosts = _this param [2,"",[""]];
_sides = _this param [3,[0,1,2,3,4,7],[[],sideunknown]];
_condition = _this param [4,{true},[{}]];
_defaultValue = _this param [5,_defaultCode,[{}]];

if (typename _sides != typename []) then {_sides = [_sides];};
_sides = +_sides;
{
	if (typename _x == typename sideunknown) then {_sides set [_foreachindex,_x call bis_fnc_sideID];};
} foreach _sides;

#include "fn_exportCuratorCostTable_imageLinks.inc"

//--- No addons defined - use all preloaded addons by default
if (count _addons == 0) then {
	{
		_addons = _addons + getarray (_x >> "list");
	} foreach ((configfile >> "cfgaddons" >> "preloadaddons") call bis_fnc_returnChildren);
};
_addonsCount = count _addons;

_br = tostring [13,10];
_tab = "	";
_text = "";
_qt = """";
_qtEmpty = """""";
if (_format == "gsheet") then {
	_qt = """""""""";
	_qtEmpty = """""""""""""";
};

//--- Points
_row = 2;
if (_sheetCosts == "") then {
	_text = _text + "Mission" + _tab;
	_text = _text + missionname + _br;

	_text = _text + "Approx. duration [m]" + _tab;
	_text = _text + "30" + _br;
	_text = _text + _br;

	_text = _text + "Points" + _tab;
	_text = _text + "0.01" + _br;

	_text = _text + "Delay" + _tab;
	_text = _text + "1" + _br;

	_text = _text + "Full points [s]" + _tab;
	_text = _text + "=IF($B$4>0;$B$5/$B$4;0)" + _br;

	_text = _text + "Full points [m]" + _tab;
	_text = _text + "=$B$6 / 24 / 60 / 60" + _br;
	_text = _text + _br;

	_text = _text + "Calculation Coef" + _tab;
	_text = _text + "-0.05" + _br;
	_text = _text + _br;
	_text = _text + _br;

	_row = 13;
} else {
	_sheetCosts = _sheetCosts + ".";
};

//--- Sort units by side (so they are together)
_sideUnits = [[],[],[],[],[],[],[],[]];
_sideVehicles = [[],[],[],[],[],[],[],[]];
_addonsRows = [];
_crewBase = tolower gettext (configfile >> "cfgvehicles" >> "all" >> "crew");
{
	_addon = _x;
	_units = getarray (configfile >> "cfgPatches" >> _x >> "units");
	//_text = _text + _tab + _tab + _tab + _tab + _tab + _tab + _tab + format ["_%1 = [];",_x] + _br;
	//_row = _row + 1;
	{
		_cfg = configfile >> "cfgvehicles" >> _x;
		if (isclass _cfg) then {
			_scope = getnumber (_cfg >> "scope");
			_scopeCurator = if (isnumber (_cfg >> "scopeCurator")) then {getnumber (_cfg >> "scopeCurator")} else {2};
			if (gettext (_cfg >> "simulation") == "UAVPilot") then {_scopeCurator = 2;};
			_side = if ((_x iskindof "allvehicles") || (_x iskindof "logic")) then {getnumber (_cfg >> "side")} else {4};
			if (_side in _sides && _scope > 0 && _scopeCurator > 0) then {
				if (_cfg call _condition) then {
					_unitsSide = _sideUnits select _side;
					_unitsSide set [count _unitsSide,[_cfg,_addon]];
				};
			};
		};
	} foreach _units;

	_addonsRows set [_foreachindex,[]];
	progressloadingscreen (_foreachindex / _addonsCount * 0.5);
} foreach _addons;


//--- Exit here when no units were detected
if ({count _x > 0} count _sideUnits == 0) exitwith {
	copytoclipboard _text;
	endloadingscreen;
	true
};

//--- Objects
_text = _text + "Vehicle Class" + _tab;
_text = _text + "Object" + _tab;
_text = _text + "Name" + _tab;
_text = _text + "Cost" + _tab;
_text = _text + "Value" + _tab;
_text = _text + "Max" + _tab;
_text = _text + "Every" + _tab;
_text = _text + format ["=%1In %1&%2$B$2&%1 min%1",_qt,_sheetCosts] + _tab;
if (_format == "gsheet") then {_text = _text + "Preview" + _tab;};
_text = _text + "Export";
_text = _text + _br;
_emptyTabs = _tab + _tab + _tab + _tab + _tab + _tab + _tab;
if (_format == "gsheet") then {_emptyTabs = _emptyTabs + _tab;};

//--- Parse units
_allUnits = [];
_allUnitRows = [];
_sideUnitsCount = count _sideUnits;
{
	if (count _x > 0) then {
		_sideID = _foreachindex;
		_side = _sideID call bis_fnc_sideType;
		_text = _text + _br + (_side call bis_fnc_sideName) + _br;// + _emptyTabs + format ["_%1 = [",str _side] + _br;
		_row = _row + 2;

		//--- Sort categories
		_units = [];
		_unitsSorted = [];
		_vehicleClasses = [];
		{
			_cfg = _x select 0;
			_class = configname _cfg;
			_addon = _x select 1;

			if (isclass _cfg) then {
				_units set [count _units,_x];
				_vehicleClass = tolower gettext (_cfg >> "vehicleClass");
				_category = tolower gettext (_cfg >> "category");
				if (_category != "") then {_vehicleClass = _vehicleClass + " / " + _category;};
				if !(_vehicleClass in _vehicleClasses) then {
					_vehicleClasses set [count _vehicleClasses,_vehicleClass];
					_unitsSorted set [count _unitsSorted,[]];
				};
			};
		} foreach _x;
		_vehicleClasses = _vehicleClasses call bis_fnc_sortAlphabetically;

		//--- Sort units according to categories
		{
			_cfg = _x select 0;
			_vehicleClass = tolower gettext (_cfg >> "vehicleClass");
			_category = tolower gettext (_cfg >> "category");
			if (_category != "") then {_vehicleClass = _vehicleClass + " / " + _category;};
			_vehicleClassID = _vehicleClasses find _vehicleClass;
			_array = _unitsSorted select _vehicleClassID;
			_array set [count _array,_x];
		} foreach _units;

		//--- Export units
		{
			{
				_cfg = _x select 0;
				_class = configname _cfg;
				_addon = _x select 1;

				_vehicleClass = tolower gettext (_cfg >> "vehicleClass");
				_category = tolower gettext (_cfg >> "category");
				if (_category != "") then {_vehicleClass = _vehicleClass + " / " + _category;};

				_text = _text + _vehicleClass + _tab;
				_textSide = if (_class iskindof "allvehicles") then {str ((getnumber (_cfg >> "side") min 3) call bis_fnc_sidetype)} else {"EMPTY"};
				_text = _text + format ["=hyperlink(%1https://community.bistudio.com/wiki/Arma_3_CfgVehicles_%3#%2%1;%1%2%1)",_qt,_class,_textSide] + _tab;
				if (_format == "gsheet") then {
					_text = _text + gettext (_cfg >> "displayName") + _tab;
				} else {
					_text = _text + format ["=hyperlink(%1https://community.bistudio.com/wiki/File:Arma3_CfgVehicles_%2.jpg%1;%1%3%1)",_qt,_class,gettext (_cfg >> "displayName")] + _tab;
				};
				_text = _text + (_cfg call _defaultValue) + _tab;
				_text = _text + format ["=%2$B$9 * INDIRECT(%1D%1&ROW())",_qt,_sheetCosts] + _tab;
				_text = _text + format ["=if (INDIRECT(%1D%1&ROW()) > 0;ROUNDDOWN (ABS(1 / INDIRECT(%1E%1&ROW())))&%1x%1;%1-%1)",_qt] + _tab;
				_text = _text + format ["=if (AND(INDIRECT(%1D%1&ROW()) > 0;%2$B$4 > 0);%2$B$7 / (1 / ABS(INDIRECT(%1E%1&ROW())));%1-%1)",_qt,_sheetCosts] + _tab;
				_text = _text + format ["=if (AND(INDIRECT(%1D%1&ROW()) > 0;%2$B$4 > 0);ROUNDDOWN ((%2$B$2 / 60 / 24) / INDIRECT(%1G%1&ROW()))&%1x%1;%1-%1)",_qt,_sheetCosts] + _tab;
				if (_format == "gsheet") then {
					_classID = _imagesCfgVehicles find (tolower _class);
					if (_classID >= 0) then {
						_link = _imagesCfgVehicles select (_classID + 1);
						if (_link != "") then {
							_text = _text + format ["=image(%1%2%1)",_qt,_link] + _tab;
						};
					};
				};
				_text = _text + format ["=IF(NOT(ISBLANK(INDIRECT(%1D%1&ROW())));%1'%3',%1&INDIRECT(%1D%1&ROW())&%1,%1;%2)",_qt,_qtEmpty,_class] + _tab;
				_text = _text + _br;

				_classLower = tolower _class;
				if !(_classLower in _allUnits) then {
					_allUnits set [count _allUnits,_classLower];
					_allUnitRows set [count _allUnitRows,_row];
				};
				_addonRows = _addonsRows select (_addons find _addon);
				_addonRows set [count _addonRows,_row];
				_row = _row + 1;

				//--- Register vehicle
				if (gettext (_cfg >> "crew") != _crewBase) then {
					_vehiclesSide = _sideVehicles select _sideID;
					_vehiclesSide set [count _vehiclesSide,[_cfg]];
				};
			} foreach _x;
		} foreach _unitsSorted;
		//_text = _text + _emptyTabs + "0];" + _br;
		//_row = _row + 1;
	};
	progressloadingscreen (0.5 + 0.5 * (_foreachindex / _sideUnitsCount));
} foreach _sideUnits;

//--- Vehicles
_text = _text + _br;
_text = _text + _br;
_row = _row + 2;
_text = _text + "Vehicle Class" + _tab;
_text = _text + "Vehicle" + _tab;
_text = _text + "Name" + _tab;
_text = _text + "Cost" + _tab;
_text = _text + "Value" + _tab;
_text = _text + "Max" + _tab;
_text = _text + "Every" + _tab;
_text = _text + format ["=%1In %1&%2$B$2&%1 min%1",_qt,_sheetCosts] + _tab;
_text = _text + _br;
_row = _row + 1;

{
	if (count _x > 0) then {
		_textVehicle = "";
		_rowVehicle = 2;
		{
			_cfg = _x select 0;
			_vehicle = configname _cfg;
			if (isclass _cfg) then {
				_vehicleID = _allUnits find (tolower _vehicle);
				_crew = tolower gettext (_cfg >> "crew");
				_crewID = _allUnits find _crew;
				if (_vehicleID >= 0 && _crewID >= 0) then {
					_vehicleCondition = "";
					_vehicleText = "";

					_vehicleRow = _allUnitRows select _vehicleID;
					_vehicleCondition = _vehicleCondition + format ["ISBLANK(D%1)=false;",_vehicleRow];
					_vehicleText = _vehicleText + format ["+D%1",_vehicleRow];
					_allUnitRows set [_vehicleID,_row + _rowVehicle];

					_crewCount = _vehicle call bis_fnc_crewcount;
					_crewRow = _allUnitRows select _crewID;
					_vehicleCondition = _vehicleCondition + format ["ISBLANK(D%1)=false;",_crewRow];
					_vehicleText = _vehicleText + format ["+(D%1*%2)",_crewRow,_crewCount];

					_textVehicle = _textVehicle + gettext (_cfg >> "vehicleClass") + _tab;
					_textVehicle = _textVehicle + _vehicle + _tab;
					_textVehicle = _textVehicle + gettext (_cfg >> "displayName") + _tab;
					_textVehicle = _textVehicle + format ["=IF(AND(%3true);%4;%2)",_qt,_qtEmpty,_vehicleCondition,_vehicleText] + _tab;
					_textVehicle = _textVehicle + format ["=%2$B$9 * INDIRECT(%1D%1&ROW())",_qt,_sheetCosts] + _tab;
					_textVehicle = _textVehicle + format ["=if (NOT(INDIRECT(%1D%1&ROW())=%2);ROUNDDOWN (ABS(1 / INDIRECT(%1E%1&ROW())))&%1x%1;%1-%1)",_qt,_qtEmpty] + _tab;
					_textVehicle = _textVehicle + format ["=if (AND(NOT(INDIRECT(%1D%1&ROW())=%2);%3$B$4 > 0);%3$B$7 / (1 / ABS(INDIRECT(%1E%1&ROW())));%1-%1)",_qt,_qtEmpty,_sheetCosts] + _tab;
					_textVehicle = _textVehicle + format ["=if (AND(NOT(INDIRECT(%1D%1&ROW())=%2);%3$B$4 > 0);ROUNDDOWN ((%3$B$2 / 60 / 24) / INDIRECT(%1G%1&ROW()))&%1x%1;%1-%1)",_qt,_qtEmpty,_sheetCosts] + _tab;
					_textVehicle = _textVehicle + "" + _tab;
					_textVehicle = _textVehicle + _br;
					_rowVehicle = _rowVehicle + 1;
				};
			};
		} foreach _x;
		if (_textVehicle != "") then {

			_side = _foreachindex call bis_fnc_sideType;
			_text = _text + _br + (_side call bis_fnc_sideName) + _br;
			_text = _text + _textVehicle;
			_row = _row + _rowVehicle;
		};
	};
} foreach _sideVehicles;

//--- Groups
_text = _text + _br;
_text = _text + _br;
_row = _row + 2;
_text = _text + "Type" + _tab;
_text = _text + "Group" + _tab;
_text = _text + "Name" + _tab;
_text = _text + "Cost" + _tab;
_text = _text + "Value" + _tab;
_text = _text + "Max" + _tab;
_text = _text + "Every" + _tab;
_text = _text + format ["=%1In %1&%2$B$2&%1 min%1",_qt,_sheetCosts] + _tab;
_text = _text + _br;
_row = _row + 1;
{
	//--- Side
	{
		//--- Faction
		{
			//--- Type
			_type = configname _x;
			{
				//--- Group
				_group = configname _x;
				_groupCondition = "";
				_groupText = "";
				_compatible = true;
				_cost = 0;
				{
					//--- Unit
					_vehicle = tolower gettext (_x >> "vehicle");
					_vehicleID = _allUnits find _vehicle;
					if (_vehicleID >= 0) then {
						_vehicleRow = _allUnitRows select _vehicleID;
						_groupCondition = _groupCondition + format ["NOT(D%1=%2);",_vehicleRow,_qtEmpty];
						_groupText = _groupText + format ["+D%1",_vehicleRow];
					} else {
						_compatible = _compatible && false;
					};
				} foreach (_x call bis_fnc_returnchildren);
				if (_compatible) then {
					_text = _text + _type + _tab;
					_text = _text + _group + _tab;
					_text = _text + gettext (_x >> "name") + _tab;
					_text = _text + format ["=IF(AND(%3true);%4;%2)",_qt,_qtEmpty,_groupCondition,_groupText] + _tab;
					_text = _text + format ["=%2$B$9 * INDIRECT(%1D%1&ROW())",_qt,_sheetCosts] + _tab;
					_text = _text + format ["=if (NOT(INDIRECT(%1D%1&ROW())=%2);ROUNDDOWN (ABS(1 / INDIRECT(%1E%1&ROW())))&%1x%1;%1-%1)",_qt,_qtEmpty] + _tab;
					_text = _text + format ["=if (AND(NOT(INDIRECT(%1D%1&ROW())=%2);%3$B$4 > 0);%3$B$7 / (1 / ABS(INDIRECT(%1E%1&ROW())));%1-%1)",_qt,_qtEmpty,_sheetCosts] + _tab;
					_text = _text + format ["=if (AND(NOT(INDIRECT(%1D%1&ROW())=%2);%3$B$4 > 0);ROUNDDOWN ((%3$B$2 / 60 / 24) / INDIRECT(%1G%1&ROW()))&%1x%1;%1-%1)",_qt,_qtEmpty,_sheetCosts] + _tab;
					_text = _text + "" + _tab;
					_text = _text + _br;
					_row = _row + 1;
				};
			} foreach (_x call bis_fnc_returnchildren);
		} foreach (_x call bis_fnc_returnchildren);
	} foreach (_x call bis_fnc_returnchildren);
} foreach ((configfile >> "cfgGroups") call bis_fnc_returnchildren);

//--- Script export
_sheetName = if (_format == "gsheet") then {
	format ["=%1_%1&getCurrentSheetName()",_qt] + _tab + "(Tools > Script Gallery > getCurrentSheetName)";
} else {
	format ["=%1_%1&MID(CELL(%1FILENAME%1);FIND(%1#$%1;CELL(%1FILENAME%1))+2;LEN(CELL(%1FILENAME%1)))",_qt] + _tab;
};
_arguments = "";
{
	if (_foreachindex == 3) then {_x = _sides;};
	if (_foreachindex > 0) then {_arguments = _arguments + ","};
	if (isnil "_x") then {_arguments = _arguments + "nil";} else {_arguments = _arguments + str _x;};
} foreach _this;
_text = _text + _br;
_text = _text + _br;
_text = _text + "Export" + _br;
_text = _text + "Prefix" + _tab;
_text = _text + _sheetName + _br;
_text = _text + format ["=%1Copy the code below and paste it to your script%1&CHAR(10)&%1Use BIS_fnc_curatorObjectRegisteredTable%1&CHAR(10)&%1to assign the values to a Curator%1",_qt] + _br;
_text = _text + _br;
_row = _row + 3;
_text = _text + format ["// Generated by %1",_fnc_scriptName] + _br;
//_text = _text + format ["// %1",_addons] + _br;
_text = _text + format ["// [%1] call %2;",_arguments,_fnc_scriptName] + _br;
//_textAll = format ["=$B$%2&%1 = (%1&CHAR(10)",_qt,_row];
_textAll = format ["=$B$%2&%1 = %1",_qt,_row];
{
	_rows = _addonsRows select _foreachindex;
	if (count _rows > 0) then {
		//_text = _text + format ["=$B$%3&%1_%2 = [%1",_qt,_x,_row];
		_text = _text + format ["=%1_%2 = [%1",_qt,_x,_row];
		{
			_text = _text + format ["&I%1",_x];
		} foreach _rows;
		_text = _text + format ["&%1'',0%1&%1];%1",_qt] + _br;
		//_textAll = _textAll + format ["&CHAR(9)&$B$%3&%1_%2 + %1&CHAR(10)",_qt,_x,_row];
		//_textAll = _textAll + format ["&$B$%3&%1_%2+%1",_qt,_x,_row];
		_textAll = _textAll + format ["&%1_%2+%1",_qt,_x,_row];
	};
} foreach _addons;
//_textAll = _textAll + format ["&CHAR(9)&%1[]%1&CHAR(10)&%1);%1",_qt] + _br;
_textAll = _textAll + format ["&%1[];%1",_qt] + _br;
_text = _text + _textAll;

copytoclipboard _text;
endloadingscreen;
true