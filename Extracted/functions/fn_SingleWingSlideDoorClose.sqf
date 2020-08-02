// Close a single-wing sliding door.

// _this select 0		object pointer
// _this select 1		door animation
// _this select 2		desired animation phase

private
[
	"_structure",
	"_door",
	"_target"
];

_structure = param [0, objNull, [objNull]];
_door = param [1, "", [""]];
_target = param [2, 0, [0]];

if (!((isNull (_structure)) ||
	((count (_door)) < 1)
))
then
{
	_structure animate [_door, _target];
};