// Register that the VTOLs are inbound
BIS_VTOLsMove = true;

{
	// Unhide VTOL
	_x setPosASL (_x getVariable "BIS_alt");
	_x hideObjectGlobal false;
	_x enableSimulationGlobal true;
	
	// Make sure it hovers
	_x setVelocity [0,0,0];
	_x forceSpeed 10;
} forEach [BIS_VTOL1, BIS_VTOL2];

private _restricted = units group driver BIS_VTOL2;
private _units = units group driver BIS_VTOL1;
_units = _units + _restricted;
_units = _units + BIS_viper3;
_units = _units + [BIS_VTOL1, BIS_VTOL2];

{
	// Prevent everyone from being engaged by AI
	_x setCaptive true;
	
	// Prevent important units from taking damage
	if (_x in BIS_VTOL1 || _x in _restricted) then {_x allowDamage false};
} forEach _units;

// Let flyover VTOL take damage
private _VTOL = vehicle driver BIS_VTOL2;
_VTOL allowDamage true;
_VTOL allowCrewInImmobile true;
_VTOL setUnloadInCombat [false, false];

_VTOL spawn {
	scriptName "BIS_fnc_EXP_m07_sendVTOLs: handle VTOL";
	
	waitUntil {
		// Wait for VTOL to take enough damage to flee
		damage _this >= 0.25
		||
		// Or for it to be deleted
		isNull _this
	};
	
	if (!(isNull _this)) then {
		// Make it flee
		BIS_VTOL2 forceSpeed -1;
		BIS_fleeVTOL = true;
		
		waitUntil {
			// Wait for VTOL to be disabled
			!(canMove _this)
			||
			// Or for it to be deleted
			isNull _this
		};
		
		// Kill the crew
		if (!(isNull _this)) then {{_x setDamage 1} forEach (units group driver _this)};
	};
};

// Wait for VTOL to be close enough
waitUntil {
	private _alt = (getPos BIS_VTOL1) select 2;
	BIS_VTOL1 distance BIS_VTOL_LZ <= (100 + _alt)
};

// Remove speed limit
BIS_VTOL1 forceSpeed -1;

// Wait for units to start disembarking
waitUntil {{!(_x in BIS_VTOL1)} count BIS_viperFake > 0};

// Allow units to be killed
{_x allowDamage true} forEach BIS_viperFake;

sleep 1;

// Force units out
{
	if (_x in BIS_VTOL1) then {
		unassignVehicle _x;
		_x action ["GetOut", BIS_VTOL1];
		sleep 1;
	};
} forEach BIS_viperFake;

true