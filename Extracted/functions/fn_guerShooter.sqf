params ["_shooter","_target"];

_shooter dowatch _target;
_shooter dotarget _target;
_shooter setbehaviour "combat";
_shooter disableai "move";
_shooter disableai "target";
_shooter disableai "autotarget";
_countDefault = count magazines _shooter;
_magDefault = currentmagazine _shooter;
_magDefault call bis_fnc_log;

waituntil {bis_orange_cameraDone};
_time = time + 30;
waituntil {time > _time};

while {alive _shooter} do {

	_time = time + random 10;
	waituntil {
		sleep 0.1;
		if (triggeractivated bis_c8_noFireZone) then {
			_shooter setbehaviour "safe";
			_time = time + random 20;
		} else {
			_shooter setbehaviour "combat";
		};
		time > _time
	};
	_shooter dowatch _target;
	_shooter dotarget _target;
	_shooter fire currentweapon _shooter;

	if (count magazines _shooter < _countDefault) then {_shooter addmagazine _magDefault;};
};

