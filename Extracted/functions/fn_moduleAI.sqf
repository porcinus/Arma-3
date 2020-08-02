private ["_logic","_units","_target","_autoTarget","_move","_anim","_FSM"];

_logic = _this param [0,objnull,[objnull]];
_units = _this param [1,[],[[]]];
_activated = _this param [2,true,[true]];

if (_activated) then {

	//--- Extract the user defined module arguments
	_target = (_logic getvariable ["Target",-1]);
	if (_target isequaltype "") then {_target = parsenumber _target;};
	_autoTarget = (_logic getvariable ["AutoTarget",-1]);
	if (_autoTarget isequaltype "") then {_autoTarget = parsenumber _autoTarget;};
	_move = (_logic getvariable ["Move",-1]);
	if (_move isequaltype "") then {_move = parsenumber _move;};
	_anim = (_logic getvariable ["Anim",-1]);
	if (_anim isequaltype "") then {_anim = parsenumber _anim;};
	_FSM = (_logic getvariable ["FSM",-1]);
	if (_FSM isequaltype "") then {_FSM = parsenumber _FSM;};

	{
		switch (_target) do
		{
			case 0: {_x disableAI "TARGET"};
			case 1: {_x enableAI "TARGET"};
		};
		
		switch (_autoTarget) do
		{
			case 0: {_x disableAI "AUTOTARGET"};
			case 1: {_x enableAI "AUTOTARGET"};
		};
		
		switch (_move) do
		{
			case 0: {_x disableAI "MOVE"};
			case 1: {_x enableAI "MOVE"};
		};
		
		switch (_anim) do
		{
			case 0: {_x disableAI "ANIM"};
			case 1: {_x enableAI "ANIM"};
		};
		
		switch (_FSM) do
		{
			case 0: {_x disableAI "FSM"};
			case 1: {_x enableAI "FSM"};
		};
		
	} foreach _units;
};
true

