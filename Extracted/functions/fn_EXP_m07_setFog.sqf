params ["_time", "_settings"];
_settings params ["_new1", "_new2", "_new3"];

// Grab current fog
private _curFog = fogParams;
_curFog params ["_old1", "_old2", "_old3"];

// Calculate differences
private _diff1 = _new1 - _old1;
private _diff2 = _new2 - _old2;
private _diff3 = _new3 - _old3;

// Calculate when the transformation should end
private _timeEnd = time + _time;

while {time <= _timeEnd} do {
	// Calculate where we are along the transformation
	private _timeNow = time;
	private _percent = 1 - ((_timeEnd - _timeNow) / _time);
	
	// Apply transformation
	1 setFog [_old1 + (_diff1 * _percent), _old2 + (_diff2 * _percent), _old3 + (_diff3 * _percent)];
	sleep 1;
};

// Set final state
1 setFog [_new1, _new2, _new3];

true