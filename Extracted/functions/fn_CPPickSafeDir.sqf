/*
	Author: Josef Zemanek

	Description:
	Combat Patrol safe azimuth picker.
*/

_landDirsArr = switch (_this select 0) do {
	case 0: {BIS_CP_landDirsArr};
	case 1: {BIS_CP_landDirsArr_insertion};
	case 2: {BIS_CP_landDirsArr_exfil};
};

_landDirInterval = selectRandom _landDirsArr;
_landDirStart = _landDirInterval select 0;
_landDirEnd = _landDirInterval select 1;
_landDirSize = _landDirEnd - _landDirStart;
_landDir = _landDirStart + random _landDirSize;

_landDir