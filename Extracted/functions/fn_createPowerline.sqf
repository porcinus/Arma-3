#define MODEL	"A3\Data_f\proxies\Rope\rope_3m.p3d"
#define LENGTH	2.9

params [
	["_obj1",objnull,[objnull]],
	["_obj2",objnull,[objnull]]
];

private _pos1 = getposasl _obj1;
private _pos2 = getposasl _obj2;

private _posZ1 = _pos1 select 2;
private _posZ2 = _pos2 select 2;

private _dis = _pos1 distance2d _pos2;
private _dir = _pos1 getdir _pos2;

private _segments = [];
private _segmentsCount = ceil (_dis / LENGTH);
private _length = _dis / _segmentsCount;

private _dropMax = -_dis * 0.04;

private _posZPrev = _posZ1;
for "_i" from _length to (_dis + _length * 0.1) step _length do {
	private _drop = _dropMax * sin  ((_i / _dis) * 180);
	private _pos = _pos1 getpos [_i,_dir];
	_pos set [2,linearconversion [0,_dis,_i,_posZ1,_posZ2] + _drop];
	private _posZ = _pos select 2;

	private _line = createSimpleObject [MODEL,_pos];
	_line setdir _dir;
	[_line,90 + atan (((_posZ - _posZPrev)) / _length),0] call bis_fnc_setpitchbank;
	_segments pushback _line;

	_posZPrev = _posZ;
};

_segments