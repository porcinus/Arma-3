// Add demo charge
BIS_support1 addMagazine "DemoCharge_Remote_Mag";

// Force to crouch
BIS_support1 setUnitPos "MIDDLE";
BIS_support1 playActionNow "Crouch";
waitUntil {stance BIS_support1 == "CROUCH"};

// Detect when charge is planted
private _firedEH = BIS_support1 addEventHandler [
	"Fired",
	{
		private _unit = _this select 0;
		private _mag = _this select 5;
		private _charge = _this select 6;
		
		if (_mag == "DemoCharge_Remote_Mag") then {
			// Remove event handler
			private _firedEH = _unit getVariable "BIS_firedEH";
			
			if (!(isNil "_firedEH")) then {
				_unit removeEventHandler ["Fired", _firedEH];
				_unit setVariable ["BIS_firedEH", nil];
			};
			
			// Store the charge
			BIS_charge = _charge;
			BIS_chargeOriginal = _charge;
			
			BIS_charge allowDamage false;
			BIS_chargePos = getPosATL BIS_charge;
			BIS_chargeDir = direction BIS_charge;
			
			// Handle players trying to disarm the charge
			[] spawn BIS_fnc_EXP_m02_replaceCharge;
			
			// Register that the charge was planted
			BIS_chargePlanted = true;
			
			// Let him move again
			_unit setUnitPos "AUTO";
			{_unit enableAI _x} forEach ["AUTOCOMBAT", "AUTOTARGET", "MOVE", "TARGET"];
			_unit forceSpeed -1;
		};
	}
];

// Store event handler
BIS_support1 setVariable ["BIS_firedEH", _firedEH];

// Place charge
BIS_support1 playAction "PutDown";
BIS_support1 selectWeapon "DemoChargeMuzzle";
BIS_support1 fire ["DemoChargeMuzzle", "DemoChargeMuzzle", "DemoCharge_Remote_Mag"];

true