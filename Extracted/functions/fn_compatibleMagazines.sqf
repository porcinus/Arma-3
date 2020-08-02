/*
	bis_fnc_compatibleMagazines

	Get all compatibile magazines for selected weapons. Function looks both for magazines listed in "magazines" array & compatibile magazineWells

	Input:
		0: (String) :
			Weapon class name
		1: (Bool) [Optional] :
			Decide if magazines with scope 1 should be also returned

	Output:
		Array of magazines (strings)

	Example:
		["arifle_mx_f"] call bis_fnc_compatibleMagazines;
compatibleMagazines
	Author: reyhard
*/


params[
	["_weapon","",[""]],
	["_showHidden",false,[false]]
];

private _weaponCfg = configFile >> "CfgWeapons" >> _weapon;


if (isClass _weaponCfg) then
{
	private _compatibleMagazines = [];

	// Go through all available muzzles
	{
		_muzzle = if (_x == "this") then {_weaponCfg} else {_weaponCfg >> _x};

		// Get magazines from "magazines" array
		_magazinesList = getarray (_muzzle >> "magazines");

		// Add magazines from magazine wells
		{
			{
				_magazinesList append (getArray _x);
			}foreach  configproperties [configFile >> "CfgMagazineWells" >> _x,"isArray _x"];
		} foreach getArray (_muzzle >> "magazineWell");

		// Add only unique entries to output
		{
			private _magazine		= tolower _x;
			private _magazineCfg	= configfile >> "cfgmagazines" >> _magazine;

			if ( (getnumber (_magazineCfg >> "scope") isEqualTo 2) || _showHidden ) then {
				_compatibleMagazines pushBackUnique _magazine;
			};
		} foreach _magazinesList;
	} foreach getarray (_weaponCfg >> "muzzles");

	_compatibleMagazines
} else {
	if (_weapon != "") then {["'%1' not found in CfgWeapons",_weapon] call bis_fnc_error;};
	[]
};
