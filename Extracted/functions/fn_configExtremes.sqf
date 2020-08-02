/*
	Author: Karel Moricky

	Description:
	Scan config paths and return min and max values for each property.
	Can be used only for properties of type number and array (value is geometric mean of all numbers in the array)

	Parameter(s):
		0: ARRAY of CONFIGs - scanned paths. Most often result of configClasses command
		1: ARRAY or STRINGs - properties, e.g., ["maxRange","reloadTime"]
		2 (Optional): ARRAY of BOOLs - property types. False for normal number, true for logarithmic)
		2 (Optional): ARRAY of NUMBERs - default values in case a property is not found

	Returns:
		ARRAY in format [minValues,maxValues]
		Number of items in each array is the same as number of properties
*/

private ["_paths","_properties","_propertyTypes","_propertyDefaults","_propertiesMax","_propertiesMin","_result"];
_paths = _this param [0,[],[[]]];
_properties = _this param [1,[],[[]]];
_propertyTypes = _this param [2,[],[[]]];
_propertyDefaults = _this param [3,[],[[]]];
{
	_propertyTypes set [_foreachindex, _propertyTypes param [_foreachindex,false,[false]]];
	_propertyDefaults set [_foreachindex, _propertyDefaults param [_foreachindex,0,[0]]];
} foreach _properties;

_propertiesMax = [];
_propertiesMin = [];
_propertiesMax resize (count _properties);
_propertiesMin resize (count _properties);

#define GETVALUE\
	private _value = if (isarray _cfgProperty) then {\
		_value = 1;\
		{_value = _value * (_x call BIS_fnc_parseNumberSafe);} foreach getarray _cfgProperty;\
		sqrt _value\
	} else {\
		getnumber _cfgProperty\
	};

#define SAVEVALUE\
	if (_propertyTypes select _propertyIndex) then {_value = log _value;};\
	if (_value != log 0) then {\
		private _valueMax = _propertiesMax select _propertyIndex;\
		private _valueMin = _propertiesMin select _propertyIndex;\
		_propertiesMax set [_propertyIndex,if (isnil "_valueMax") then {_value} else {_value max _valueMax}];\
		_propertiesMin set [_propertyIndex,if (isnil "_valueMin") then {_value} else {_value min _valueMin}];\
	};

_result = [];
{
	private ["_cfgRoot","_cfgs","_isWeapon"];
	_cfgRoot = _x;
	_cfgs = [_cfgRoot];
	_isWeapon = isnumber (_cfgRoot >> "reloadTime");
	_isEquipment = istext (_cfgRoot >> "ItemInfo" >> "uniformModel"); // Includes uniforms, vests and headgear

	if (_isEquipment) then {
		_cfgs pushback (_cfgRoot >> "ItemInfo");
		//_cfgs pushback (configfile >> "cfgvehicles" >> gettext (_cfgRoot >> "ItemInfo" >> "uniformclass") >> "hitpoints" >> "hitbody");
		//_cfgs  = _cfgs + (configproperties [configfile >> "cfgvehicles" >> gettext (_cfgRoot >> "ItemInfo" >> "uniformclass") >> "hitpoints","isclass _x",true]);
		//_cfgs pushback (configfile >> "cfgvehicles" >> gettext (_cfgRoot >> "ItemInfo" >> "containerClass"));
	} else {
		if (_isWeapon) then {
			_cfgs = [];
			{
				if (_x == "this") then {
					_cfgs pushback _cfgRoot;
				} else {
					private ["_mode"];
					_mode = _cfgRoot >> _x;
					if (getnumber (_mode >> "showtoplayer") == 1 || true) then {_cfgs pushback _mode;};
				};
			} foreach getarray (_x >> "modes");
			{
				_cfgs pushback (configfile >> "cfgmagazines" >> _x);
				_cfgs pushback (configfile >> "cfgammo" >> gettext (configfile >> "cfgmagazines" >> _x >> "ammo"));
			} foreach getarray (_x >> "magazines");
			_cfgs pushback (_cfgRoot >> "weaponslotsinfo");
		};
	};

	//--- Extract values
	{
		private _property = _x;
		private _propertyIndex = _foreachindex;
		if (_isEquipment && {_property in ["armor","passthrough"]}) then {
			private _cfg = _cfgRoot >> "itemInfo" >> "HitpointsProtectionInfo";
			private _condition = "isclass _x && configname _x != 'HitBody'";
			if (getnumber (_cfgRoot >> "itemInfo" >> "type") == 801) then {
				_cfg = configfile >> "cfgvehicles" >> gettext (_cfgRoot >> "ItemInfo" >> "uniformclass") >> "HitPoints";
				_condition = "isclass _x && tolower configname _x in ['hitabdomen','hitarms','hitchest','hitdiaphragm','hitneck','hitpelvis']";
			};
			if (_property == "armor") then {
				{
					private _armor = getnumber (_x >> "armor");
					_value = (_armor / (1 + _armor))^18;
					SAVEVALUE
				} foreach configproperties [_cfg,_condition];
			} else {
				{
					private _armor = getnumber (_x >> "armor");
					private _passThrough = getnumber (_x >> "passThrough");
					_value = (_armor / (1 + _armor))^9 * (1 - _passThrough);
					SAVEVALUE
				} foreach configproperties [_cfg,_condition];
			};
		} else {
			private _cfgsLocal = if (_property == "maxzeroing") then {_propertiesMin set [_propertyIndex,0]; [_cfgRoot]} else {+_cfgs};
			{
				_cfgProperty = _x >> _property;
				if (_isEquipment && {_property == "maximumLoad"}) then {_cfgProperty = configfile >> "cfgvehicles" >> gettext (_x >> "ItemInfo" >> "containerClass") >> _property;};
				if (isnumber _cfgProperty || isarray _cfgProperty) then {
					GETVALUE
					SAVEVALUE
				};
			} foreach _cfgsLocal;
		};
	} foreach _properties;

	//--- When undefined, use root values
	{
		_cfgProperty = _cfgRoot >> _x;
		if (isnil {_propertiesMin select _foreachindex}) then {
			if (isnumber (_cfgProperty) || isarray (_cfgProperty)) then {
				GETVALUE
				if (_propertyTypes select _foreachindex) then {_value = log _value;};
				if (_value == log 0) then {_value = _propertyDefaults select _foreachindex;};
				_propertiesMin set [_foreachindex,_value];
				_propertiesMax set [_foreachindex,_value];
			};
		};
		if (isnil {_propertiesMin select _foreachindex}) then {
			private ["_value"];
			_value = _propertyDefaults select _foreachindex;
			_propertiesMin set [_foreachindex,_value];
			_propertiesMax set [_foreachindex,_value];
		};
	} foreach _properties;
} foreach _paths;
[_propertiesMin,_propertiesMax]