//--- Run in scheduled environment
if !(canSuspend) exitwith {_this spawn (uinamespace getvariable _fnc_scriptName);};

_dispenser = _this select 6;
_pos = position _dispenser;
_dir = direction _dispenser;

_cfgDispenser = configfile >> "CfgAmmo" >> typeof _dispenser >> "MineDispenser";
if !(isclass _cfgDispenser) exitwith {["'MineDispenser' properties not defined for CfgAmmo class %1",typeof _dispenser] call bis_fnc_error;};
_velCoef = getnumber (_cfgDispenser >> "velocityCoef");
_count = getnumber (_cfgDispenser >> "count");
_dirRange = getnumber (_cfgDispenser >> "angle");

//--- ToDo: Move to "Detonated" EH
while {!isnull _dispenser} do {
	_pos = position _dispenser;
	_dir = direction _dispenser;
	sleep 0.1;
};

_dirStart = _dir - _dirRange / 2;
_dirStep = _dirRange / _count;
_disOffset = 0.03 * _count;

for "_i" from 0 to (_count - 1) do {
	_dirProjectile = _dirStart + _dirStep * _i;
	_speedProjectile = _velCoef * 0.25 + random _velCoef * 0.75;
	_posProjectile = [sin _dirProjectile * _disOffset,cos _dirProjectile * _disOffset,0];
	_mineProjectile = createvehicle ["Land_MOPMS_Mine_F",_pos vectorAdd _posProjectile,[],0,"can_collide"];
	_mineProjectile setdir _dir;
	_mineProjectile setvelocity [
		sin _dirProjectile * _speedProjectile,
		cos _dirProjectile * _speedProjectile,
		_velCoef * 0.8 + random _velCoef * 0.4
	];
	_mineProjectile allowdamage false;
	_mineProjectile spawn {
		_timeOut = time + 10;
		waituntil {velocity _this distance [0,0,0] == 0 || time > _timeOut};
		if (time > _timeOut || (getposasl _this select 2) < 0) exitwith {deletevehicle _this;}; //--- Terminate when failed to stop or under water
		_mine = createvehicle ["MOPMS_Mine",position _this,[],0,"can_collide"]; //--- ToDo: Dynamic class
		_mine setposatl getposatl _this;
		deletevehicle _this;
		//west revealmine _mine;
	};
};

//--- Mark the minefield afterwards
//_flag = createvehicle ["FlagSmall_F",_pos,[],0,"can_collide"];
//_flag setObjectTexture [0,"#(argb,8,8,3)color(0.75,0,0,1)"];