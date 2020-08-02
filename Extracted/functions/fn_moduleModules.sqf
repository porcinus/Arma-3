private ["_object","_result"];
_object = _this param [0,objnull,[objnull]];
_result = [];

//--- Scan synchronized objects
{
	if (_x iskindof "Logic") then {
		_result set [count _result,_x];
	};
} foreach (synchronizedobjects _object);

_result