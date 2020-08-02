private ["_marker", "_alpha", "_curAlpha"];
_marker = _this param [0, "", [""]];
_alpha = _this param [1, 0, [0]];
_curAlpha = markerAlpha _marker;

while {(abs (_curAlpha - _alpha)) > 0.01} do 
{
	if (_curAlpha < _alpha) then 
	{
		_curAlpha = _curAlpha + 0.1;
	} 
	else 
	{
		_curAlpha = _curAlpha - 0.1;
	};
	_marker setMarkerAlpha _curAlpha;
	
	sleep 0.05;
};

true