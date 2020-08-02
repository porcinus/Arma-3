// Wait for status to synchronize
waitUntil {!(isNil "BIS_extracted")};

private _dest = markerPos "BIS_exfil";
private _distMax = 300;
private _distMin = 265;
private _distRange = _distMax - _distMin;

private _maxVD = 2500;
private _minVD = 1000;
private _rangeVD = _maxVD - _minVD;

private _dist = vehicle player distance _dest;

while {!(BIS_extracted)} do {
	waitUntil {
		// Everyone's extracted
		BIS_extracted
		||
		{
			// Wait for player to get close to LZ
			_dist = vehicle player distance _dest;
			_dist <= _distMax
		}
	};
	
	while {
		// Players aren't extracted yet
		!(BIS_extracted)
		&&
		{
			// Players are close enough to LZ
			_dist = vehicle player distance _dest;
			_dist <= _distMax
		}
	} do {
		if (!(BIS_extracted)) then {
			// Calculate difference and ratio
			private _diff = _dist - _distMin;
			
			if (_diff < 0) then {
				// Only increase view distance to the defined limit
				setViewDistance _maxVD;
			} else {
				private _ratio = 1 - (_diff / _distRange);
				
				// Calculate correct view distance based on ratio
				private _VD = _minVD + (_rangeVD * _ratio);
				
				// Set view distance
				setViewDistance _VD;
			};
			
			sleep 0.01;
		};
	};
};

// Set max view distance
setViewDistance _maxVD;

true