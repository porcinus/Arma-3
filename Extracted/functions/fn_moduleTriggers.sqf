private ["_object","_result"];
_object = _this param [0,objnull,[objnull]];
_result = [];

//--- Scan synchronized objects
{
	if (triggertype _x == "NONE") then {
		_result set [count _result,_x];
	};
} foreach (synchronizedobjects _object);

_result