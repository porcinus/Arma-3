// Close a set of doors without any doorhandle.

// _this select 0		object pointer
// _this select 1		doorA animation
// _this select 2		doorB animation
// _this select 3		doorA desired animation phase
// _this select 4		doorB desired animation phase

private
[
	"_structure",
	"_doorA",
	"_doorB",
	"_targetA",
	"_targetB"
];

_structure = param [0, objNull, [objNull]];
_doorA = param [1, "", [""]];
_doorB = param [2, "", [""]];
_targetA = param [3, 0, [0]];
_targetB = param [4, 0, [0]];

if (!((isNull (_structure)) ||
	((count (_doorA)) < 1) ||
	((count (_doorB)) < 1)
))
then
{
	_structure animate [_doorA, _targetA];
	_structure animate [_doorB, _targetB];
};