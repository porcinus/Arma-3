private _disabled 		= false;
private _disabledText 	= "";
private _spectate		= missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false];
private _var			= if (_spectate) then {"Spectate"} else {"Map"};
private _ctrlWarning 	= uiNamespace getVariable [format ["BIS_RscRespawnControls%1_ctrlWarning", _var], controlNull];
private _testArray 		=
[
	[uiNamespace getVariable [format ["BIS_RscRespawnControls%1_ctrlLocList", _var], controlNull], uiNamespace getVariable ["BIS_RscRespawnControls_positionDisabled", []]],
	[uiNamespace getVariable [format ["BIS_RscRespawnControls%1_ctrlRoleList", _var], controlNull], uiNamespace getVariable ["BIS_RscRespawnControls_roleDisabled", []]],
	[uiNamespace getVariable [format ["BIS_RscRespawnControls%1_ctrlComboLoadout", _var], controlNull], uiNamespace getVariable ["BIS_RscRespawnControls_loadoutDisabled", []]]
];

// Check if anything is disabled
{
	private _list 			= _x param [0, controlNull, [controlNull]];
	private _array 			= _x param [1, [], [[]]];
	private _curSel 		= lbCurSel _list;
	private _curSelText 	= _list lbText _curSel;
	private _isPosition		= _list in [uiNamespace getVariable ["BIS_RscRespawnControlsMap_ctrlLocList", controlNull], uiNamespace getVariable ["BIS_RscRespawnControlsSpectate_ctrlLocList", controlNull]];
	private _metadataLoc	= if (_isPosition) then {["get", _curSel] call BIS_fnc_showRespawnMenuPositionMetadata} else {[]};

	if (_isPosition) then
	{
		{
			private _item 		= _x param [0,"",["",0]];
			private _message 	= _x param [1,"",[""]];
			private _uniqueID 	= _x param [2,"",[""]];

			private _object = (_metadataLoc select 0) select 0;

			if (!isNil "_object") then
			{
				private _objectID = call
				{
					if (_object isEqualType "") exitWith {_object};
					if (_object isEqualType objNull) exitWith {[_object] call BIS_fnc_objectVar};
					""
				};
				
				if (_objectID isEqualTo _uniqueID) then
				{
					_disabledText = _message;
					_disabled = true;
				};
			};
		}
		forEach _array;
	}
	else
	{
		{
			private _item 		= _x param [0,"",["",0]];
			private _message 	= _x param [1,"",[""]];
			private _uniqueID 	= _x param [2,"",[""]];

			if (_item isEqualTo _curSelText) exitWith
			{
				_disabledText = _message;
				_disabled = true;
			};
		}
		forEach _array;
	};

	if (_disabled) exitWith {};
}
forEach _testArray;

// In case of disabled selection show warning and disable timer/button
if (_disabled) then
{
	uiNamespace setVariable ["BIS_RscRespawnControls_disabledSelection", true];

	private _message = "<img image='#(argb,8,8,3)color(0,0,0,0)' size='0.1' /><br /><t align='center'>" + _disabledText + "</t>";

	_ctrlWarning ctrlSetStructuredText parseText _message;
	_ctrlWarning ctrlShow true;
	ctrlSetFocus _ctrlWarning;
}
else
{
	uiNamespace setVariable ["BIS_RscRespawnControls_disabledSelection", false];

	_ctrlWarning ctrlSetStructuredText parseText "";
	_ctrlWarning ctrlShow false;
};

_disabled;