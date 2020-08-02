/*
	Author: Josef Zemanek

	Description:
	Combat Patrol empty position locator
*/

params [
	"_center",
	["_vehType", "B_Soldier_F"]
];

private _emptyPosRad = -1;
private _foundPos = [];

while {_emptyPosRad < 100 && (count _foundPos == 0 || if (count _foundPos == 0) then {TRUE} else {surfaceIsWater _foundPos})} do {
	_foundPos = _center findEmptyPosition [0, _emptyPosRad, _vehType];
	_emptyPosRad = _emptyPosRad + 1;
};

if (_emptyPosRad < 100) then {
	_foundPos
} else {
	_center
}