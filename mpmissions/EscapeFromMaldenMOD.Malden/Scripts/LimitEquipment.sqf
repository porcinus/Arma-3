// Limit ammo
_limitAmmo = [_this] call BIS_fnc_limitAmmunition;

// Limit FAKs
_limitFAKs = _this call BIS_fnc_EfM_limitFAKs;

// Limit weapon items. If the unit belongs to Syndikat, give it always a flashlight. If it's CSAT, give a chance to keep the IR laser pointer.
if (side _this == resistance) then {_this addPrimaryWeaponItem "acc_flashlight"} else {_limitWeaponItems = [_this] call BIS_fnc_limitWeaponItems};
