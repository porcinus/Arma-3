/*
NNS : Automate equipmnent limitation for players (Escape from Tanoa)

level 0 : Over-equipped (100% ammo, full equipment plus ENVG-II, Nightstalker, GPS for everyone)
level 1 : Standard (100% ammo, full equipment)
level 2 : Limited (50% ammo, limited equipment)
level 3 : Survivor (25% ammo, no optics)
*/

RemovePrimaryItem = {
	_search = _this select 0; //generic simple name
	_primaryItem = primaryWeaponItems player;
	{
		if ([_search, toLower (_x), true] call BIS_fnc_inString) then {
			player removePrimaryWeaponItem _x;
			player unassignItem _x;
			player removeItem _x;
		};
	} forEach (primaryWeaponItems player);
};

if (BIS_loadoutLevel == 2) then {[player,[1,1],[0.5,0.6]] call BIS_fnc_limitAmmunition;}; //NNS : limit magazine (50-60%)
if (BIS_loadoutLevel == 3) then {[player,[1,1],[0.2,0.3]] call BIS_fnc_limitAmmunition;}; //NNS : limit magazine (20-30%)

if (BIS_loadoutLevel > 0) then { //over level 0
	player removeWeapon "NVGogglesB_blk_F"; player addWeapon "NVGoggles_tna_F"; //remplace ENVG-II by NV Goggles
	if !(typeOf player == "B_T_Soldier_SL_F" || typeOf player == "B_T_soldier_M_F") then {player unassignItem "ItemGPS"; player removeItem "ItemGPS"; player removeWeapon "Rangefinder";}; //if not leader or sniper, remove GPS and Range finder
	player unassignItem "optic_Nightstalker"; player removeItem "optic_Nightstalker"; //remove Nightstalker
	["nightstalker"] call RemovePrimaryItem; //remove Nightstalker
};

if (BIS_loadoutLevel > 1) then { //remove common equipment between level 2 and 3
	if !(typeOf player == "B_T_Soldier_SL_F") then {["erco"] call RemovePrimaryItem;/*player removePrimaryWeaponItem "optic_Arco_blk_F"*/}; //if not leader, remove ARCO
	if (count (backpackItems player) == 0) then {removeBackpack player;}; //remove backpack if empty
	["pointer"] call RemovePrimaryItem; //remove IR pointer
	player removeWeapon "Rangefinder"; //remove Range finder
};

if (BIS_loadoutLevel == 2) then { //if level 2
	if (typeOf player == "B_T_Soldier_SL_F" || {typeOf player == "B_T_soldier_M_F"}) then {player addWeapon "Binocular"; //add binocular to leader and sniper
	} else {player addPrimaryWeaponItem "optic_Aco";}; //add ACO to the rest of the squad
};

if (BIS_loadoutLevel == 3) then { //remove remaining optics if level 3
	player removeWeapon "NVGoggles_tna_F";
	["optic"] call RemovePrimaryItem;
};
