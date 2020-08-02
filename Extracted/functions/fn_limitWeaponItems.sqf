/*
	Author: Vaclav "Watty Watts" Oliva

	Description:
	Keeps or remove unit's weapon attachments based on probability user sets. Apply for primary, secondary or handgun weapon separately.
	- use 0-100 to randomize the chance of keeping the current attachment
	- use 100 to always keep the attachment
	- use 0 to always remove the attachment

	Parameters:
	Select 0 - OBJECT: Target unit
	Select 1 - NUMBER: Mode - 0 for primary weapon, 1 for secondary, 2 for handgun. Defult is 0.
	Select 2 - NUMBER or ARRAY: Chance to keep the current optics, in %. Default is 50.
	Select 3 - NUMBER or ARRAY: Chance to keep the current side attachment, in %. Default is 50.
	Select 4 - NUMBER or ARRAY: Chance to keep the current muzzle attachment, in %. Default is 50.
	Select 5 - NUMBER or ARRAY: Chance to keep the current underbarrel attachment, in %. Default is 50.

	If you use ["itemClassname",number], the function will add that attachment if it passes the check. If not, current will be removed.

	Returns:
	Boolean

	Examples:
	_limit = [player] call BIS_fnc_limitWeaponItems;
	_limit = [player,0,25,50,75,100] call BIS_fnc_limitWeaponItems;
	_limit = [player,0,25,["acc_flashlight",50],75,100] call BIS_fnc_limitWeaponItems;
	_limit = [player,2,["optic_Yorris",50]] call BIS_fnc_limitWeaponItems;
	_limit = [player,0,["optic_lrps",100],["acc_pointer_ir",100],["muzzle_snds_B",100],["bipod_01_F_blk",100]] call BIS_fnc_limitWeaponItems;
*/

// Params
params
[
	["_unit",objNull,[objNull]],
	["_mode",0,[999]],
	["_opticsChance",50,[999,[]]],
	["_sideChance",50,[999,[]]],
	["_muzzleChance",50,[999,[]]],
	["_underChance",50,[999,[]]]
];

// Check for validity
if (isNull _unit) exitWith {["Weapon items removal: unit %1 does not exist.",_unit] call BIS_fnc_logFormat; false};
if (!(_mode in [0,1,2])) exitWith {["Wrong mode %1, use 0, 1 or 2",_mode] call BIS_fnc_logFormat; false};
if ((_muzzleChance isEqualType 999) and {(_muzzleChance < 0) or (_muzzleChance > 100)}) exitWith {["Weapon items removal: muzzle chance %1 not 0-100.",_muzzleChance] call BIS_fnc_logFormat; false};
if ((_muzzleChance isEqualType []) and {count _muzzleChance != 2}) exitWith {["Weapon items removal: wrong format for muzzle attachment: %1.",_muzzleChance] call BIS_fnc_logFormat; false};
if ((_sideChance isEqualType 999) and {(_sideChance < 0) or (_sideChance > 100)}) exitWith {["Weapon items removal: side attachment chance %1 not 0-100.",_sideChance] call BIS_fnc_logFormat; false};
if ((_sideChance isEqualType []) and {count _sideChance != 2}) exitWith {["Weapon items removal: wrong format for side attachment: %1.",_sideChance] call BIS_fnc_logFormat; false};
if ((_opticsChance isEqualType 999) and {(_opticsChance < 0) or (_opticsChance > 100)}) exitWith {["Weapon items removal: optics chance %1 not 0-100.",_opticsChance] call BIS_fnc_logFormat; false};
if ((_opticsChance isEqualType []) and {count _opticsChance != 2}) exitWith {["Weapon items removal: wrong format for optics: %1.",_opticsChance] call BIS_fnc_logFormat; false};
if ((_underChance isEqualType 999) and {(_underChance < 0) or (_underChance > 100)}) exitWith {["Weapon items removal: underbarrel chance %1 not 0-100.",_underChance] call BIS_fnc_logFormat; false};
if ((_underChance isEqualType []) and {count _underChance != 2}) exitWith {["Weapon items removal: wrong format for underbarrel attachment: %1.",_underChance] call BIS_fnc_logFormat; false};

// Proceed only if the unit has any  weapon
if (count (getUnitLoadout _unit select _mode) > 0)
then
{
	_unitWeaponInfo = getUnitLoadout _unit select _mode;

	private _unitWeapon = _unitWeaponInfo select 0;
	private _unitWeaponMuzzle = _unitWeaponInfo select 1;
	private _unitWeaponSide = _unitWeaponInfo select 2;
	private _unitWeaponOptics = _unitWeaponInfo select 3;
	private _unitWeaponPMag = _unitWeaponInfo select 4;
	private _unitWeaponSMag = _unitWeaponInfo select 5;
	private _unitWeaponUnder = _unitWeaponInfo select 6;

	// Muzzle attachment
	if ((_muzzleChance isEqualType 999) and {(_unitWeaponMuzzle != "")}) then
		{
		_random = random 100;
		if (_random > _muzzleChance)
		then
		{
			_unitWeaponMuzzle = "";
		};
	};

	// Muzzle attachment - custom
	if (_muzzleChance isEqualType []) then
	{
		_random = random 100;
		if (_random > _muzzleChance select 1)
		then
		{
			_unitWeaponMuzzle = "";
		}
		else
		{
			_unitWeaponMuzzle = _muzzleChance select 0;
		};
	};

	// Side attachment
	if ((_sideChance isEqualType 999) and {(_unitWeaponSide != "")}) then
		{
		_random = random 100;
		if (_random > _sideChance)
		then
		{
			_unitWeaponSide = "";
		};
	};

	// Side attachment - custom
	if (_sideChance isEqualType []) then
	{
		_random = random 100;
		if (_random > _sideChance select 1)
		then
		{
			_unitWeaponSide = "";
		}
		else
		{
			_unitWeaponSide = _sideChance select 0;
		};
	};

	// Optics
	if ((_opticsChance isEqualType 999) and {(_unitWeaponOptics != "")}) then
		{
		_random = random 100;
		if (_random > _opticsChance)
		then
		{
			_unitWeaponOptics = "";
		};
	};

	// Optics - custom
	if (_opticsChance isEqualType []) then
	{
		_random = random 100;
		if (_random > _opticsChance select 1)
		then
		{
			_unitWeaponOptics = "";
		}
		else
		{
			_unitWeaponOptics = _opticsChance select 0;
		};
	};

	// Underbarrel attachment
	if ((_underChance isEqualType 999) and {(_unitWeaponUnder != "")}) then
		{
		_random = random 100;
		if (_random > _underChance)
		then
		{
			_unitWeaponUnder = "";
		};
	};

	// Underbarrel attachment - custom
	if (_underChance isEqualType []) then
	{
		_random = random 100;
		if (_random > _underChance select 1)
		then
		{
			_unitWeaponUnder = "";
		}
		else
		{
			_unitWeaponUnder = _underChance select 0;
		};
	};

	// Compose  weapon info
	_unitWeaponFinal = [_unitWeapon, _unitWeaponMuzzle, _unitWeaponSide, _unitWeaponOptics, _unitWeaponPMag, _unitWeaponSMag, _unitWeaponUnder];

	// Set final loadout
	if (_mode == 0) then {_unit setUnitLoadout [_unitWeaponFinal,nil,nil,nil,nil,nil,nil,nil,nil,nil]};
	if (_mode == 1) then {_unit setUnitLoadout [nil,_unitWeaponFinal,nil,nil,nil,nil,nil,nil,nil,nil]};
	if (_mode == 2) then {_unit setUnitLoadout [nil,nil,_unitWeaponFinal,nil,nil,nil,nil,nil,nil,nil]};
}
else
{
	["Unit %1 doesn't have needed weapon",_unit] call BIS_fnc_logFormat;
	false
};

true
