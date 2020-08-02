// Register that reinforcements are inbound
BIS_reinfMove = true;

// Unhide units
{
	_x setVariable ["BIS_fnc_EXP_m07_handleIFF_active", true, true];
	_x setPosASL (_x getVariable "BIS_alt");
	_x hideObjectGlobal false;
	_x enableSimulationGlobal true;
	_x enableAI "MOVE";
} forEach [BIS_ai_1, BIS_ai_2, BIS_ai_3, BIS_ai_4, BIS_james, BIS_falcon1, BIS_falcon2, BIS_falcon3];

{
	// Allow unit to take damage
	_x allowDamage true;
	
	// But only from AI
	_x addEventHandler [
		"HandleDamage",
		{
			private _damage = _this select 2;
			private _source = _this select 3;
			if (!(isPlayer _source)) then {_damage} else {0};
		}
	];
	
	// Hide IFF if they're killed
	_x addEventHandler [
		"Killed",
		{
			private _unit = _this select 0;
			{_unit setVariable [_x, false, true]} forEach ["BIS_iconAlways", "BIS_iconShow", "BIS_iconName"];
		}
	];
} forEach [BIS_falcon1, BIS_falcon2, BIS_falcon3];

true