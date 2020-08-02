params ["_unit"];

// Try to add flashlight normally
_unit addPrimaryWeaponItem "acc_flashlight";

// Check if it was added
if (((primaryWeaponItems _unit) select 1) == "") then {
	// Doesn't have a flashlight-capable weapon
	// Grab weapon magazines
	private _weapon = primaryWeapon _unit;
	private _mags = [_weapon] call bis_fnc_compatibleMagazines;
	
	// Count how many they have
	private _magCount = {_unit in _mags} count magazines _unit;
	_magCount = _magCount + 1;
	
	// Remove weapon and magazines
	_unit removeWeapon _weapon;
	{_unit removeMagazines _x} forEach _mags;
	
	// Add flashlight weapon
	_unit addMagazines ["30Rnd_762x39_Mag_F", _magCount];
	_unit addWeapon "arifle_AKM_FL_F";
};

// Force flashlight
_unit spawn {
	scriptName format ["BIS_fnc_EXP_m01_forceFlashlights: force flashlight - %1", _this];
	private _count = 0;
	while {_count < 10} do {_this enableGunLights "forceOn"; sleep 3; _count = _count + 1};
};

true