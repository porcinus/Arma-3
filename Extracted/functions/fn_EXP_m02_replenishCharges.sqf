waitUntil {time > 0};

// Store placed charges
BIS_charges = [];

// Set up unit
removeAllWeapons BIS_miner;
BIS_miner allowDamage false;
BIS_miner setCaptive true;
BIS_miner hideObjectGlobal true;

// Detect when the unit places a charge
BIS_miner addEventHandler [
	"Fired",
	{
		private _mag = _this select 5;
		private _charge = _this select 6;
		
		if (_mag == "DemoCharge_Remote_Mag") then {
			// Add charge to array
			_charge allowDamage false;
			BIS_charges = BIS_charges + [_charge];
		};
	}
];

BIS_miner spawn {
	scriptName "BIS_fnc_EXP_m02_handleCharge: replenish charges";
	
	while {!(isNull _this)} do {
		// Plant backup charges
		while {!(isNull _this) && { count BIS_charges < 10 }} do {
			if (!("DemoCharge_Remote_Mag" in magazines _this)) then {_this addMagazine "DemoCharge_Remote_Mag"};
			_this selectWeapon "DemoChargeMuzzle";
			_this fire ["DemoChargeMuzzle", "DemoChargeMuzzle", "DemoCharge_Remote_Mag"];
		};
		
		// Wait for a charge to be taken away
		waitUntil {isNull _this || { count BIS_charges < 10 }};
	};
};

true