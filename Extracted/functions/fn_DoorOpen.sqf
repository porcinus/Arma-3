// Open a door with an animated doorhandle.

// _this select 0		object pointer
// _this select 1		door animation
// _this select 2		doorhandle up->down animation
// _this select 3		doorhandle down->up animation
// _this select 4		desired animation phase

private
[
	"_structure",
	"_door",
	"_doorHandleDown",
	"_doorHandleUp",
	"_target"
];

_structure = param [0, objNull, [objNull]];
_door = param [1, "", [""]];
_doorHandleDown = param [2, "", [""]];
_doorHandleUp = param [3, "", [""]];
_target = param [4, 1, [1]];

if (!((isNull (_structure)) ||
	((count (_door)) < 1) ||
	((count (_doorHandleDown)) < 1) ||
	((count (_doorHandleUp)) < 1)
))
then
{
	_structure animate [_door, _target];
	_structure animate [_doorHandleDown, _target];
	_structure animate [_doorHandleUp, _target];
};