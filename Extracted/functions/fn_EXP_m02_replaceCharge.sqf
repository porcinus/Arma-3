while {!(BIS_detonate)} do {
	// Wait for player to disarm the charge
	waitUntil {BIS_detonate || { !(mineActive BIS_charge) }};
	
	if (!(BIS_detonate)) then {
		// Delete disarmed charge
		private _holders = nearestObjects [BIS_chargePos, ["GroundWeaponHolder"], 1];
		{deleteVehicle _x} forEach _holders;
		
		// Select a new charge from backup charges
		BIS_charge = BIS_charges select 0;
		BIS_charges = BIS_charges - [BIS_charge];
		BIS_charge setPosATL BIS_chargePos;
		BIS_charge setDir BIS_chargeDir;
	};
};

true