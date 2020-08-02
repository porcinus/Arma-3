
_return = [];
if (isNil {uiNamespace getVariable "BIS_RscRespawnControls_posMetadata"}) exitWith {_return};

with uiNamespace do {
	_mode = _this select 0;
	_lbId = _this select 1;
	_list = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_ctrlLocList} else {BIS_RscRespawnControlsMap_ctrlLocList};
	
	switch _mode do {
		
		case "set": {
			//--- Saving data to array
			_return = "";
			_new = true;
			_arrayId = 0;
			_arraySize = count BIS_RscRespawnControls_posMetadata;
			
			if (_arraySize > 0) then {
				for "_i" from 0 to (_arraySize - 1) do {
					_item = BIS_RscRespawnControls_posMetadata select _i;
					if (count _item == 0) exitWith {_arrayId = _i; _new = false};
				};
			};
			
			if (_new) then {
				BIS_RscRespawnControls_posMetadata = BIS_RscRespawnControls_posMetadata + [_this select 2];
				_arrayId = (count BIS_RscRespawnControls_posMetadata) - 1;
			} else {
				BIS_RscRespawnControls_posMetadata set [_arrayId,_this select 2];
			};
			
			_list lbSetData [_lbId,str _arrayId];
			_return = _arrayId;	//returning ID of item in array
		};
		
		case "get": {
			//--- Getting data from array
			_arrayId = call compile (_list lbData _lbId);
			//if ((count BIS_RscRespawnControls_posMetadata) > _arrayId) then {
			if (!(isNil "_arrayId") && {(count BIS_RscRespawnControls_posMetadata) > _arrayId}) then {
				_return = BIS_RscRespawnControls_posMetadata select _arrayId;	//returning data array
			};
		};
		
		case "update": {
			//--- Updating already existing item
			_arrayId = call compile (_list lbData _lbId);
			BIS_RscRespawnControls_posMetadata set [_arrayId,_this select 2];
			_return = _lbId;		//returning ID of updated item
		};
		
		case "delete": {
			//--- Removing the item from array
			_arrayId = call compile (_list lbData _lbId);
			BIS_RscRespawnControls_posMetadata set [_arrayId,[]];
			_return = true;
		};
		
	};
};

_return