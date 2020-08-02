private _list 			= _this param [0, controlNull, [controlNull]];
private _count 			= lbSize _list;
private _array 			= [];
private _var			= if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {"Spectate"} else {"Map"};
private _isPosition		= _list in [uiNamespace getVariable ["BIS_RscRespawnControlsMap_ctrlLocList", controlNull], uiNamespace getVariable ["BIS_RscRespawnControlsSpectate_ctrlLocList", controlNull]];

switch true do
{
	case (_list == uiNamespace getVariable [format ["BIS_RscRespawnControls%1_ctrlLocList", _var], controlNull]): 		{_array = uiNamespace getVariable ["BIS_RscRespawnControls_positionDisabled", []];};
	case (_list == uiNamespace getVariable [format ["BIS_RscRespawnControls%1_ctrlRoleList", _var], controlNull]): 		{_array = uiNamespace getVariable ["BIS_RscRespawnControls_roleDisabled", []];};
	case (_list == uiNamespace getVariable [format ["BIS_RscRespawnControls%1_ctrlComboLoadout", _var], controlNull]):	{_array = uiNamespace getVariable ["BIS_RscRespawnControls_loadoutDisabled", []];};
};

private _blockedIDs = [];
private _textArray 	= [];

{
	_blockedIDs pushBack (_x select 2);
	_textArray pushBack (_x select 0);
}
forEach _array;

for "_i" from 0 to (_count - 1) do
{
	private _item			= _list lbText _i;
	private _metadataLoc 	= ["get", _i] call BIS_fnc_showRespawnMenuPositionMetadata;
	private _object 		= (_metadataLoc select 0) select 0;

	// If we are dealing with a non position item / list we make sure text is not in disabled ones
	// If dealing with a position we check it's object instead
	private _isDisabled = call
	{
		if (!_isPosition) exitWith {_item in _textArray};
		if (isNil "_object") exitWith {false};
		if (_object isEqualType objNull) exitWith {([_object] call BIS_fnc_objectVar) in _blockedIDs};
		if (_object isEqualType "") exitWith {_object in _blockedIDs};
		false
	};
	
	if (_isDisabled) then
	{
		// Item is disabled
		_list lbSetColor [_i, [0.4,0.4,0.4,1]];
		_list lbSetSelectColor [_i, [0.4,0.4,0.4,1]];
		_list lbSetPictureColor [_i, [0.4,0.4,0.4,1]];
		_list lbSetPictureColorSelected [_i, [0.4,0.4,0.4,1]];
	}
	else
	{
		// Item is enabled
		_list lbSetColor [_i, [1,1,1,1]];
		_list lbSetSelectColor [_i, [0,0,0,1]];
		_list lbSetPictureColor [_i, [1,1,1,1]];
		_list lbSetPictureColorSelected [_i, [0,0,0,1]];
	};
};