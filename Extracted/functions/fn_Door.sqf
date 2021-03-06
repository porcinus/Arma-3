// Open or close a door

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
_door = param [1, 0, [0]];
_target = param [2, 0, [0]];

if (!(isNull (_structure)))
then
{
	if ((_structure getVariable [format ["bis_disabled_Door_%1", _door], 0]) != 1)
	then
	{
		_structure animateSource [format ["Door_%1_sound_source", _door], _target];
		_structure animateSource [format ["Door_%1_noSound_source", _door], _target];
	}
	else
	{
		_structure animateSource [format ["Door_%1_locked_source", _door], (1 - (_structure animationSourcePhase (format ["Door_%1_locked_source", _door])))];
	};
};