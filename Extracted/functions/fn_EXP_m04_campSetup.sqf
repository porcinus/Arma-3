private _count = count (call BIS_fnc_listplayers);
_count call bis_fnc_log;

// Smoker
private _smokers = [BIS_smokerA, BIS_smokerB];
BIS_smoker = _smokers call BIS_fnc_selectRandom;
{if (_x != BIS_smoker) exitWith {deleteVehicle _x}} forEach _smokers;
BIS_smoker setBehaviour "SAFE";
BIS_smoker enableMimics false;
BIS_smoker disableAI "MOVE";
BIS_smoker playMove "Acts_CivilIdle_1";

BIS_campUnits set [count BIS_campUnits, BIS_smoker];

//---------------------| C.J version |---------------------------------
if (_count == 1) then {

	{deleteVehicle _x} forEach [BIS_entrance, BIS_sleeping];
	BIS_guard setBehaviour "SAFE";
	BIS_campUnits set [count BIS_campUnits, BIS_guard];
	//Set only one patrol
	if (random 1 <= 0.5) then {
		{deleteVehicle _x} forEach [BIS_patrolB1, BIS_patrolB2];
	} else {
		{deleteVehicle _x} forEach [BIS_patrolA1, BIS_patrolA2];
	};
	// Choose one of these two guys
	if (random 1 <= 0.5) then {
		deletevehicle BIS_ammoGuard;
		BIS_company setBehaviour "SAFE";
		BIS_campUnits set [count BIS_campUnits, BIS_company];

	} else {
		deletevehicle BIS_company;
		BIS_ammoGuard setBehaviour "SAFE";
		BIS_campUnits set [count BIS_campUnits, BIS_ammoGuard];
	};
	// Choose one of these two guys
	if (random 1 <= 0.5) then {
		deletevehicle BIS_chilling;
		BIS_fire setBehaviour "SAFE";
		BIS_campUnits set [count BIS_campUnits, BIS_fire];

	} else {
		deletevehicle BIS_fire;
		BIS_chilling setBehaviour "SAFE";
		BIS_campUnits set [count BIS_campUnits, BIS_chilling];
	};
};


if (_count == 2) then {

	BIS_entrance setBehaviour "SAFE";
	BIS_campUnits set [count BIS_campUnits, BIS_entrance];

	if (random 1 <= 0.5) then {
		{deleteVehicle _x} forEach [BIS_patrolB1, BIS_patrolB2];
	} else {
		{deleteVehicle _x} forEach [BIS_patrolA1, BIS_patrolA2];
	};

	if (random 1 <= 0.5) then {
		deletevehicle BIS_sleeping;
		BIS_company setBehaviour "SAFE";
		BIS_campUnits set [count BIS_campUnits, BIS_company];

	} else {
		deletevehicle BIS_company;
		BIS_sleeping setBehaviour "SAFE";
		BIS_campUnits set [count BIS_campUnits, BIS_sleeping];
	};

	if (random 1 <= 0.5) then {
		deletevehicle BIS_guard;
		BIS_fire setBehaviour "SAFE";
		BIS_campUnits set [count BIS_campUnits, BIS_fire];

	} else {
		deletevehicle BIS_fire;
		BIS_guard setBehaviour "SAFE";
		BIS_campUnits set [count BIS_campUnits, BIS_guard];
	};

	if (random 1 <= 0.5) then {
		deletevehicle BIS_chilling;
		BIS_ammoGuard setBehaviour "SAFE";
		BIS_campUnits set [count BIS_campUnits, BIS_ammoGuard];

	} else {
		deletevehicle BIS_ammoGuard;
		BIS_chilling setBehaviour "SAFE";
		BIS_campUnits set [count BIS_campUnits, BIS_chilling];
	};
};


if (_count == 3) then {

	BIS_fire setBehaviour "SAFE";
	BIS_campUnits set [count BIS_campUnits, BIS_fire];

	if (random 1 <= 0.5) then {
		deletevehicle BIS_chilling;
		BIS_company setBehaviour "SAFE";
		BIS_campUnits set [count BIS_campUnits, BIS_company];

	} else {
		deletevehicle BIS_company;
		BIS_chilling setBehaviour "SAFE";
		BIS_campUnits set [count BIS_campUnits, BIS_chilling];
	};

	if (random 1 <= 0.5) then {
		deletevehicle BIS_guard;
		BIS_ammoGuard setBehaviour "SAFE";
		BIS_campUnits set [count BIS_campUnits, BIS_ammoGuard];

	} else {
		deletevehicle BIS_ammoGuard;
		BIS_guard setBehaviour "SAFE";
		BIS_campUnits set [count BIS_campUnits, BIS_guard];
	};

	if (random 1 <= 0.5) then {
		deletevehicle BIS_sleeping;
		BIS_entrance setBehaviour "SAFE";
		BIS_campUnits set [count BIS_campUnits, BIS_entrance];

	} else {
		deletevehicle BIS_entrance;
		BIS_sleeping setBehaviour "SAFE";
		BIS_campUnits set [count BIS_campUnits, BIS_sleeping];
	};
};

if (_count ==4) then {
	{_x setbehaviour "SAFE"} foreach [BIS_sleeping,BIS_entrance,BIS_guard,BIS_ammoGuard,BIS_chilling,BIS_company,BIS_fire,BIS_patrolB1, BIS_patrolB2,BIS_patrolA1, BIS_patrolA2];
};

{_x disableAI "SUPPRESSION"} forEach BIS_campUnits;