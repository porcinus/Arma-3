_mode = _this param [0,"",[""]];
_dataArray = _this param [1,[missionnamespace,"","",-1,-1],[[]]];
_namespace = _dataArray select 0;
_roleName = _dataArray param [1,"",[""]];
_invIdentity = _dataArray param [2,"",[""]];

_limits = [-1,-1];
_baseName = "BIS_RscRespawnControls_limits";

switch (_mode) do {
	case "set": {
		_roleLimit = _dataArray select 3;
		_invLimit = _dataArray select 4;
		
		//Functions
		_fnc_set = {
			_array = _namespace getVariable [_var,[]];
			if ((count _array) > 0) then {
				//check if the role is in the limit array already
				_itemId = -1;
				_item = [];
				{
					if (((_x select 0) select 0) == _roleName) exitWith {_itemId = _forEachIndex;_item = _x};
				} forEach _array;
				
				//check if the inventory is in item already
				if (_itemId != -1) then {
					_invArray = _item select 1;
					_invItemId = -1;
					_invItem = [];
					{
						if ((_x select 0) == _invIdentity) exitWith {_invItemId = _forEachIndex;_invItem = _x};
					} forEach _invArray;
					
					if (_invItemId != -1) then {	//inventory is already in here, just check limits and add 1 to register number
						_oldLimit = _invItem select 1;
						if (_oldLimit != _invLimit) then {_invItem set [1,_invLimit];_invItem set [2,(_invItem select 2) + (_invLimit - _oldLimit)];_invItem set [3,(_invItem select 2) + 1];};
						_invArray set [_invItemId,_invItem];
					} else {	//we don't have this inventory here yet
						_invArray = _invArray + [[_invIdentity,_invLimit,_invLimit,1]];
					};
					_item set [1,_invArray];
					_roleArray = _item select 0;
					_oldRoleLimit = _roleArray select 1;
					if (_oldRoleLimit != _roleLimit) then {_roleArray set [1,_roleLimit];_roleArray set [2,(_roleArray select 2) + (_roleLimit - _oldLimit)];_item set [0,_roleArray]};	//check if the limit for role is correct and fix it eventually
					_array set [_itemId,_item];
				} else {	//we don't have this role here yet 
					_array = _array + [[[_roleName,_roleLimit,_roleLimit],[[_invIdentity,_invLimit,_invLimit,1]]]];
				};
			} else {
				_array = [[[_roleName,_roleLimit,_roleLimit],[[_invIdentity,_invLimit,_invLimit,1]]]];
			};
			
			_namespace setVariable [_var,_array,true];
		};
		
		//Main
		switch (typeName _namespace) do {
			case (typeName missionNamespace): {
				_var = _baseName + "Global";
				call _fnc_set;
			};
			case (typeName sideUnknown): {
				_var = _baseName + str _namespace;
				_namespace = missionNamespace;
				call _fnc_set;
			};
			case (typeName grpNull);
			case (typeName objNull): {
				_var = _baseName;
				call _fnc_set;
			};
		};
	};
	case "delete": {		//TODO!
		
		switch (typeName _namespace) do {
			case (typeName missionNamespace): {
				
			};
			case (typeName sideUnknown): {
				
			};
			case (typeName grpNull);
			case (typeName objNull): {
				
			};
		};
	};
	case "change": {		//TODO!
		_change = _dataArray select 3;
		
		_fnc_change = {
			_array = _namespace getVariable [_var,[]];
			{
				_arrayItem = _x;
				_arrayId = _forEachIndex;
	
				_roleArray = _arrayItem select 0;
				if (_roleName == _roleArray select 0) exitWith {	//correct role found
					_invArray = _arrayItem select 1;
					{
						if (_invIdentity == _x select 0) exitWith {	//correct loadout found
							_invArrayItem = _x;
							_invArrayId = _forEachIndex;
							
							_invArrayItem set [2,(_invArrayItem select 2) + _change];
							_invArray set [_invArrayId,_invArrayItem];
							_roleArray set [2,(_roleArray select 2) + _change];
							
							_arrayItem set [0,_roleArray];
							_arrayItem set [1,_invArray];
							_array set [_arrayId,_arrayItem];
							
							_namespace setVariable [_var,_array,true];
						};
					} forEach _invArray;
					
				};
			} forEach _array;
		};
		
		switch (typeName _namespace) do {
			case (typeName missionNamespace): {
				_var = _baseName + "Global";
				call _fnc_change;
			};
			case (typeName sideUnknown): {
				_var = _baseName + str _namespace;
				_namespace = missionNamespace;
				call _fnc_change;
			};
			case (typeName grpNull);
			case (typeName objNull): {
				_var = _baseName;
				call _fnc_change;
			};
		};
	};
	case "get": {
		//Functions
		_fnc_get = {
			_array = _namespace getVariable [_var,[]];
			if ((count _array) > 0) then {
				if (_roleName != "") then {		//--role and inventory passed as parameters, looking for both of them
					//find role
					_itemId = -1;
					_item = [];
					{
						if (((_x select 0) select 0) == _roleName) exitWith {_itemId = _forEachIndex;_item = _x};
					} forEach _array;
					
					if (_itemId != -1) then {	//role found
						_roleArray = _item select 0;
						_roleLimit = _roleArray select 1;
						if !(_roleLimit > -1) then {	//no role limit defined, try to find inventory and get its limit
							_invArray = _item select 1;
							_invItemId = -1;
							_invItem = [];
							{
								if ((_x select 0) == _invIdentity) exitWith {_invItemId = _forEachIndex;_invItem = _x};
							} forEach _invArray;
							
							if (_invItemId != -1) then {	//inventory found, return limit for inventory
								_curInvLimit = _invItem select 2;
								_limits = [-1,_curInvLimit];
							};
						} else {	//there is a role limit defined, ignore limits for loadouts
							_curRoleLimit = _roleArray select 2;
							_limits = [_curRoleLimit,-1];
						};
					};
				} else {		//--only role passed as a parameter, look only for role
					//find role
					_itemId = -1;
					_item = [];
					{
						if (((_x select 0) select 0) == _roleName) exitWith {_itemId = _forEachIndex;_item = _x};
					} forEach _array;
					
					if (_itemId != -1) then {	//role found
						_roleArray = _item select 0;
						_curRoleLimit = _roleArray select 2;
						_limits = [_curRoleLimit,-1];
					};
				};
			};
		};
		
		//Main
		switch (typeName _namespace) do {
			case (typeName missionNamespace): {
				_var = _baseName + "Global";
				call _fnc_get;
			};
			case (typeName sideUnknown): {
				_var = _baseName + str _namespace;
				_namespace = missionNamespace;
				call _fnc_get;
			};
			case (typeName grpNull);
			case (typeName objNull): {
				_var = _baseName;
				call _fnc_get;
			};
		};
	};
};

_limits