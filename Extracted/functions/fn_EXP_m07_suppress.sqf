private _pos1 = markerPos "BIS_suppress1";
private _pos2 = markerPos "BIS_suppress2";

[] spawn {
	scriptName "BIS_fnc_EXP_m07_suppress: suppressing fire";
	
	private _time = time + 8;
	
	while {time <= _time} do {
		BIS_LSV1 fireAtTarget [];
		sleep 0.01;
	};
};

sleep 0.1;

{
	private _unit = _x;
	{_unit disableAI _x} forEach ["AUTOCOMBAT", "AUTOTARGET", "TARGET"];
	_unit setCombatMode "BLUE";
} forEach [BIS_james, BIS_ai_1];

BIS_james setBehaviour "AWARE";
BIS_ai_1 setUnitPos "DOWN";

sleep 0.4;

BIS_LSV1G doWatch _pos2;

sleep 1.5;

BIS_LSV1G doWatch _pos1;

sleep 1.5;

BIS_LSV1G doWatch _pos2;

sleep 1.5;

BIS_LSV1G doWatch _pos1;

sleep 1.5;

{BIS_LSV1G enableAI _x} forEach ["AUTOCOMBAT", "AUTOTARGET", "TARGET"];
BIS_LSV1G doWatch (markerPos "BIS_gunnerWatch");

private _units = allPlayers;
_units = _units + [BIS_james, BIS_ai_1];

{
	private _unit = _x;
	_unit setCaptive false;
	{_unit reveal [_x, 4]} forEach _units;
} forEach [BIS_LSV1, BIS_LSV1D, BIS_LSV1G];

{
	private _unit = _x;
	{_unit enableAI _x} forEach ["AUTOCOMBAT", "AUTOTARGET", "TARGET"];
	_unit setBehaviour "COMBAT";
	_unit setCombatMode "YELLOW";
} forEach [BIS_james, BIS_ai_1];

BIS_james setSkill ["aimingAccuracy", 0.1];

BIS_james setUnitPos "UP";
BIS_ai_1 setUnitPos "MIDDLE";

true