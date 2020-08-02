private _return = [];

// Early leave if we have no inventory metadata
if (isNil {uiNamespace getVariable "BIS_RscRespawnControls_invMetadata"}) exitWith {_return};

private _mode 			= _this param [0, "", [""]];
private _spectateShown 	= missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false];
private _list 			= uiNamespace getVariable [format ["BIS_RscRespawnControls%1_ctrlRoleList", if (_spectateShown) then {"Spectate"} else {"Map"}], controlNull];

switch _mode do
{
	case "set":
	{
		// Saving data to array
		_return 		= true;
		_arrayId 		= -1;
		_setArray 		= _this param [1, [], [[]]];
		_setRole 		= _setArray select 0;
		_setLoadout 	= _setArray select 1;
		_setRoleName 	= _setRole select 0;
		_invMetadata	= uiNamespace getVariable ["BIS_RscRespawnControls_invMetadata", []];
		_arraySize 		= count _invMetadata;

		if (_arraySize > 0) then
		{
			// Check if the same role item already exists
			{
				if (((_x select 0) select 0) == _setRoleName) exitWith {_arrayId = _forEachIndex}
			}
			forEach _invMetadata;

			// Role item doesn't exist, check empty items (deleted roles) in the array
			if (_arrayId < 0) then
			{
				{
					if (count _x == 0) exitWith {_arrayId = _forEachIndex};
				}
				forEach _invMetadata;
			};
		};

		// Store the item in the metadata array
		switch true do
		{
			// Role item is not registered yet and there is no empty item, create the new item and add it to list
			case (_arrayId < 0):
			{
				uiNamespace setVariable ["BIS_RscRespawnControls_invMetadata",(uiNamespace getVariable ["BIS_RscRespawnControls_invMetadata", []]) + [[_setRole,[_setLoadout]]]];

				// List handling
				_id = _list lbAdd _setRoleName;
				_list lbSetPicture [_id,_setRole select 2];

				// Size of array was measured before adding of the item, so it is equal to index of added item now
				_list lbSetData [_id,str _arraySize];

				// Sort the list
				lbSort _list;
			};

			// Role item is not registered yet, but an empty item found, use it and add it to list
			case (count ((uiNamespace getVariable ["BIS_RscRespawnControls_invMetadata", []]) select _arrayId) == 0):
			{
				(uiNamespace getVariable ["BIS_RscRespawnControls_invMetadata", []]) set [_arrayId,[_setRole,[_setLoadout]]];

				// List handling
				_id = _list lbAdd _setRoleName;
				_list lbSetPicture [_id,_setRole select 2];
				_list lbSetData [_id,str _arrayId];
				lbSort _list;
			};

			// Role item is already registered, add the loadout to it
			default
			{
				_roleArray = (uiNamespace getVariable ["BIS_RscRespawnControls_invMetadata", []]) select _arrayId;
				_roleArray set [1,(_roleArray select 1) + [_setLoadout]];
				(uiNamespace getVariable ["BIS_RscRespawnControls_invMetadata", []]) set [_arrayId,_roleArray];

				if (_setRoleName == (_list lbText (lbCurSel _list))) then
				{
					// Refresh loadout combobox
					call (missionNamespace getVariable "BIS_fnc_showRespawnMenuInventoryLoadout");
				};
				// List handling not needed, item already exists
			};
		};
	};

	case "get":
	{
		// Getting data from array, second parameter defines for which role
		_lbId 		= _this param [1, -1, [0]];
		_arrayId 	= call compile (_list lbData _lbId);

		if (!isNil "_arrayId" && {(count (uiNamespace getVariable ["BIS_RscRespawnControls_invMetadata", []])) > _arrayId}) then
		{
			// Returning data array
			_return = (uiNamespace getVariable ["BIS_RscRespawnControls_invMetadata", []]) select _arrayId;
		};
	};

	case "delete":
	{
		// Removing the item from array
		private _lbId 			= _this param [1, -1, [0]];
		private _loadoutId 		= _this param [2, -1, [0]];
		private _arrayId 		= call compile (_list lbData _lbId);
		private _roleItem 		= (uiNamespace getVariable ["BIS_RscRespawnControls_invMetadata", []]) select _arrayId;
		private _loadoutItem 	= _roleItem select 1;

		if (!isNil "_loadoutItem" && {_loadoutId > -1}) then
		{
			_loadoutItem = _loadoutItem - [_loadoutItem select _loadoutId];

			if (count _loadoutItem != 0) then
			{
				_roleItem set [_loadoutId,_loadoutItem];
				(uiNamespace getVariable ["BIS_RscRespawnControls_invMetadata", []]) set [_arrayId, _roleItem];
			}
		}
		else
		{
			(uiNamespace getVariable ["BIS_RscRespawnControls_invMetadata", []]) set [_arrayId, []];
		};

		_return = true;
	};
};

_return;