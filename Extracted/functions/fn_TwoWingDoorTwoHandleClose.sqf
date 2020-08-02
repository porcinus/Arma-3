// Close a set of doors with one doorhandle.

// _this select 0		object pointer
// _this select 1		doorA animation
// _this select 2		doorA handle up->down animation
// _this select 3		doorA handle down->up animation
// _this select 4		doorB animation
// _this select 5		doorB handle up->down animation
// _this select 6		doorB handle down->up animation
// _this select 7		doorA desired animation phase
// _this select 8		doorB desired animation phase

private
[
	"_structure",
	"_doorA",
	"_doorHandleDownA",
	"_doorHandleUpA",
	"_doorB",
	"_doorHandleDownB",
	"_doorHandleUpB",
	"_targetA",
	"_targetB"
];

_structure = param [0, objNull, [objNull]];
_doorA = param [1, "", [""]];
_doorHandleDownA = param [2, "", [""]];
_doorHandleUpA = param [3, "", [""]];
_doorB = param [4, "", [""]];
_doorHandleDownB = param [5, "", [""]];
_doorHandleUpB = param [6, "", [""]];
_targetA = param [7, 0, [0]];
_targetB = param [8, 0, [0]];

if (!((isNull (_structure)) ||
	((count (_doorA)) < 1) ||
	((count (_doorHandleDownA)) < 1) ||
	((count (_doorHandleUpA)) < 1) ||
	((count (_doorB)) < 1) ||
	((count (_doorHandleDownB)) < 1) ||
	((count (_doorHandleUpB)) < 1)
))
then
{
	_structure animate [_doorA, _targetA];
	_structure animate [_doorHandleDownA, _targetA];
	_structure animate [_doorHandleUpA, _targetA];
	_structure animate [_doorB, _targetB];
	_structure animate [_doorHandleDownB, _targetB];
	_structure animate [_doorHandleUpB, _targetB];
};