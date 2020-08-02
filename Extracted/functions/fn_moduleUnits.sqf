private ["_object","_result","_units","_sync"];
_object = _this param [0,objnull,[objnull]];
_result = [];
_units = _object getvariable ["units","0"];

//--- Return objects in editor layer
if (_units isequaltype []) exitwith {
	_result = getMissionLayerEntities -((_units param [0,-1]) + 1);
	if (count _result > 0) then {_result = _result param [0,[]];};
	_result
};

//--- Use synchronization
_unitsID = parsenumber _units;
switch _unitsID do {

	case 0;
	case 1: {

		//--- Scan synchronized objects
		{
			_sync = _x;
			if ({_sync iskindof _x} count ["Logic","EmptyDetector"] == 0) then {
				if (_unitsID > 0) then {
					_result = _result + [_x] + (units _x - [_x]);
				} else {
					_result set [count _result,_x];
				};
			};
		} foreach (synchronizedobjects _object);

	};
	case 2: {
		{
			_result = _result + list _x;
		} foreach (_object call bis_fnc_moduleTriggers);
	};
};

_result