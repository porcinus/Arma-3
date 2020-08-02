disableSerialization;

private _mode 			= _this param [0,"",[""]];
private _state 			= "";
private _defaultMsgPos 	= localize "STR_A3_RscRespawnControls_PositionUnavailable";
private _defaultMsgRole = localize "STR_A3_RscRespawnControls_RoleUnavailable";
private _defaultMsgLoad = localize "STR_A3_RscRespawnControls_LoadoutUnavailable";
private _spectate 		= missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false];
private _var			= if (_spectate) then {"Spectate"} else {"Map"};

with uiNamespace do
{
	// Gets proper default message for given list
	private _fnc_defaultMessage =
	{
		private _list 	= _this param [0, controlNull, [controlNull]];

		private _result = switch true do
		{
			case (_list == uiNamespace getVariable [format ["BIS_RscRespawnControls%1_ctrlLocList", _var], controlNull]): {_defaultMsgPos};
			case (_list == uiNamespace getVariable [format ["BIS_RscRespawnControls%1_ctrlRoleList", _var], controlNull]): {_defaultMsgRole};
			case (_list == uiNamespace getVariable [format ["BIS_RscRespawnControls%1_ctrlComboLoadout", _var], controlNull]): {_defaultMsgLoad};
			default {""};
		};

		_result;
	};

	// Returns proper data array for given list
	private _fnc_getArray =
	{
		private _list 	= _this param [0, controlNull, [controlNull]];

		private _array 	= switch true do
		{
			case (_list == uiNamespace getVariable [format ["BIS_RscRespawnControls%1_ctrlLocList", _var], controlNull]): 		{uiNamespace getVariable ["BIS_RscRespawnControls_positionDisabled", []]};
			case (_list == uiNamespace getVariable [format ["BIS_RscRespawnControls%1_ctrlRoleList", _var], controlNull]): 		{uiNamespace getVariable ["BIS_RscRespawnControls_roleDisabled", []]};
			case (_list == uiNamespace getVariable [format ["BIS_RscRespawnControls%1_ctrlComboLoadout", _var], controlNull]): 	{uiNamespace getVariable ["BIS_RscRespawnControls_loadoutDisabled", []]};
			default {[]};
		};

		_array;
	};

	// Saves new array in proper data array for given list
	private _fnc_setArray =
	{
		private _list 		= _this param [0, controlNull, [controlNull]];
		private _newArray 	= _this param [1, [], [[]]];

		switch true do
		{
			case (_list == uiNamespace getVariable [format ["BIS_RscRespawnControls%1_ctrlLocList", _var], controlNull]): 		{uiNamespace setVariable ["BIS_RscRespawnControls_positionDisabled", _newArray]};
			case (_list == uiNamespace getVariable [format ["BIS_RscRespawnControls%1_ctrlRoleList", _var], controlNull]): 		{uiNamespace setVariable ["BIS_RscRespawnControls_roleDisabled", _newArray]};
			case (_list == uiNamespace getVariable [format ["BIS_RscRespawnControls%1_ctrlComboLoadout", _var], controlNull]): 	{uiNamespace setVariable ["BIS_RscRespawnControls_loadoutDisabled", _newArray]};
		};
	};

	// Main disable function
	private _fnc_disable =
	{
		private _list 		= _this param [1, controlNull, [controlNull]];
		private _item 		= _this param [2,"",["",0]];	//name (string) or id (number)
		private _message 	= _this param [3,"",[""]];
		private _uniqueID 	= _this param [4,"",[""]];
		private _name 		= if (typeName _item == typeName "") then {_item} else {_list lbText _item};

		if (_message == "") then {_message = [_list] call _fnc_defaultMessage};

		_inArray = false;	//check if item isn't in the array already
		{if ((_x select 0) == _name) exitWith {_inArray = true}} forEach ([_list,_var] call _fnc_getArray);

		if !(_inArray) then {
			_newArray = ([_list] call _fnc_getArray) + [[_name,_message,_uniqueID]];
			[_list,_newArray] call _fnc_setArray;
			[_list] call BIS_fnc_showRespawnMenuDisableItemDraw;
			_state = "disabled";
		} else {
			_state = "none";
		};
	};

	// Main enable function
	private _fnc_enable =
	{
		private _list 		= _this param [1, controlNull, [controlNull]];
		private _item 		= _this param [2,"",["",0]];	//name (string) or id (number)
		private _message 	= _this param [3,"",[""]];
		private _uniqueID	= _this param [4,"",[""]];
		private _name 		= if (typeName _item == typeName "") then {_item} else {_list lbText _item};

		if (_message == "") then {
			//--- no message, remove only item with given name
			_array = [_list] call _fnc_getArray;
			_deleteArray = [];
			{
				if ((_x select 0) == _name) then {
					_deleteArray = _deleteArray + [_x];
				};
			} forEach _array;

			if ((count _deleteArray) > 0) then {
				_newArray = _array - _deleteArray;
				[_list,_newArray] call _fnc_setArray;
				[_list] call BIS_fnc_showRespawnMenuDisableItemDraw;
				_state = "enabled";
			} else {
				_state = "none";
			};

		} else {
			//--- message defined, remove all items with the same message
			_deleted = false;
			_array = [_list] call _fnc_getArray;
			_deleteArray = [];
			{
				if ((_x select 1) == _message) then {
					_deleteArray = _deleteArray + [_x];
				};
			} forEach _array;

			if ((count _deleteArray) > 0) then {
				_newArray = _array - _deleteArray;
				[_list,_newArray] call _fnc_setArray;
				[_list] call BIS_fnc_showRespawnMenuDisableItemDraw;
				_state = "enabled";
			} else {
				_state = "none";
			};
		};
	};

	// Main state function
	private _fnc_state =
	{
		private _list 		= _this param [1, controlNull, [controlNull]];
		private _item 		= _this param [2,"",["",0]];	//name (string) or id (number)
		private _message 	= _this param [3,"",[""]];
		private _uniqueID 	= _this param [4,"",[""]];
		private _name 		= if (typeName _item == typeName "") then {_item} else {_list lbText _item};

		if (_message == "") then
		{
			//--- no message, process only item with given name
			_inArray = false;
			{if ((_x select 0) == _name) exitWith {_inArray = true}} forEach ([_list] call _fnc_getArray);
			if (_inArray) then {_state = "disabled"} else {_state = "enabled"};
		}
		else
		{
			//--- message defined, process all items with the same message <---- NOT WORKING! NEEDS TO BE FIXED IF WE WANT IT, REMOVE IT OTHERWISE
			_returnArray = [];
			{if ((_x select 1) == _message) then {_returnArray = _returnArray + [_x select 0]}} forEach ([_list] call _fnc_getArray);
			_state = _returnArray;
		};
	};

	// Main
	switch (_mode) do
	{
		case "disable":
		{
			_this call _fnc_disable;
			if (_state == "disabled") then {call BIS_fnc_showRespawnMenuDisableItemCheck};
		};

		case "enable":
		{
			_this call _fnc_enable;
			if (_state == "enabled") then {call BIS_fnc_showRespawnMenuDisableItemCheck};
		};

		case "state":
		{
			_this call _fnc_state;
		};
	};
};

_state;