/*
AUTHOR: Asheara

USE CASE:
0 = [0] spawn BIS_fnc_exportCfgVehiclesAssetDB; -> OPFOR / CSAT
0 = [1] spawn BIS_fnc_exportCfgVehiclesAssetDB; -> BLUFOR / NATO
0 = [2] spawn BIS_fnc_exportCfgVehiclesAssetDB; -> Independent / Guerrilla
0 = [3,0] spawn BIS_fnc_exportCfgVehiclesAssetDB; -> Civilian side, Civilian
0 = [3,1] spawn BIS_fnc_exportCfgVehiclesAssetDB; -> Civilian side, Structures
0 = [3,2] spawn BIS_fnc_exportCfgVehiclesAssetDB; -> Civilian side, Ruins & Wrecks
0 = [3,3] spawn BIS_fnc_exportCfgVehiclesAssetDB; -> Civilian side, Equipment
0 = [3,4] spawn BIS_fnc_exportCfgVehiclesAssetDB; -> Civilian side, Objects
0 = [3,5] spawn BIS_fnc_exportCfgVehiclesAssetDB; -> Civilian side, VR Objects
0 = [3,6] spawn BIS_fnc_exportCfgVehiclesAssetDB; -> Civilian side, Animals
0 = [] spawn BIS_fnc_exportCfgVehiclesAssetDB; -> Other - Unknown, Enemy, Friendly, Modules, Empty, Ambient Life
*/

private _sides_param = param [0,[4,5,6,7,8,9],[0,[]]];						// first parameter, default value is "other" -> sides bigger than three, accepts array and numbers
private _categories_param = param [1,0,[0]];								// second parameter, default value is 0 - representing "Civilians" category as first field of array, accepts numbers

if !(_sides_param isEqualType []) then										// if _side is not array, make it array
{
	_sides_param = [_sides_param];
};

if (count(_sides_param) > 1) then 
{
	_categories_param = 1;
};

startloadingscreen [""];

_cfgVehicles 			= (configfile >> "cfgvehicles") call bis_fnc_returnchildren;	// gets all subclasses of cfgVehicles 
_text 					= "";															// initializing the text variable
_br 					= tostring [13,10];												// new line
_br_long				= "						" + _br + _br;
_product 				= productversion select 0;										// version of the product for purposes of the wiki links
_productShort 			= productversion select 1;										// version of the product for purposes of the wiki images

_scopes 				= ["Private","Protected","Public"];																					// list of strings for scopes
_sides 					= ["OPFOR","BLUFOR","Independent","Civilian","Unknown","Enemy","Friendly","Modules","Empty","Ambient Life"];		// list of strings for sides
_scopecolor 			= ["#e1c2c2","#fff3b2","#c2e1c2"];																					// list of colors for scopes
_sidecolor 				= ["#e1c2c2","#c2d4e7","#c2e1c2","#dac2e1","#fff3b2","e1c2c2","#c2e1c2","#fdd3a6","#dac2e1","#cccccc"];				// list of colors for sides

// listed subcategories for "civilian" side
_civilian				= ["Civilians"];
_structures				= ["Structures","Structures (Altis)","Structures (Tanoa)","Walls","Fences"];
_ruins_wrecks			= ["Ruins","Ruins (Altis)","Ruins (Tanoa)","Wrecks"];
_equipment				= ["Equipment","Weapons","Weapon Attachements","Supplies"];
_objects				= ["Furniture","Signs","Things","Other"];
_vr						= ["VR Objects"];
_animals				= ["Animals"];

_categories				= [_civilian, _structures, _ruins_wrecks, _equipment, _objects, _vr, _animals];

_cfg_DLC				= ["Curator","Expansion","Heli","Kart","Mark","Orange","Argo","Tank"];						// list of values for DLCs from config
_icons_DLC				= [
							"Kart","karts_icon_ca",
							"Heli", "heli_icon_ca",
							"Mark", "mark_icon_ca",
							"Expansion", "apex_icon_ca",
							"Jets", "jets_icon_ca",
							"Orange", "orange_icon_ca",
							"Argo", "malden_icon_ca",
							"Tank", "tank_icon_ca"
						  ];

_exclude_list			= [];

// function returning appropriate string for the purpose of wiki links based on the item type passed as an argument
_fnc_getItemPage = {
	switch (_this) do {
		case "Weapon": {"CfgWeapons Weapons"};
		case "VehicleWeapon": {"CfgWeapons Vehicle Weapons"};
		case "Item": {"CfgWeapons Items"};
		case "Equipment": {"CfgWeapons Equipment"};
		default {"CfgWeapons"};
	};
};

_text = format ["{{Template:%1 Assets}}<br />",_product] + _br;

// creating the wiki table header
_text = _text + "{| class=""wikitable sortable"" border=""1"" style=""border-collapse:collapse; font-size:80%;"" cellpadding=""3px""" + _br;
_text = _text + "! Preview<br />" + _br;
_text = _text + "! Class Name<br />" + _br;
_text = _text + "! Display Name<br />" + _br;
_text = _text + "! Side<br />" + _br;
_text = _text + "! Category<br />" + _br;
_text = _text + "! Subcategory<br />" + _br;
_text = _text + "! Scope<br />" + _br;
_text = _text + "! DLC<br />" + _br;
// Props do not need to have these parameters listed
if (_categories_param == 0) then 
{
	_text = _text + "! Weapons<br />" + _br;
	_text = _text + "! Magazines<br />" + _br;
	_text = _text + "! Items<br />" + _br;
};
_text = _text + "! Addons<br />" + _br;
_text = _text + "! Features<br />" + _br;

_parsed = [];				// inititalizing array for filtering the assets

// Applies only for "civilian" side - too many assets, had to be split into several categories
if (3 in _sides_param) then
{
	{	// getting side and editor category text to ve verified for every asset
		_side = getnumber(_x >> "side");
		_editorcategory = gettext(configfile >> "cfgeditorcategories" >> gettext(_x >> "editorCategory") >> "displayname");
		if (_editorcategory == "") then
		{
			_editorcategory = gettext(configfile >> "cfgFactionClasses" >> gettext(_x >> "faction") >> "displayname");
		};
		
		// excluding classes starting as "Supply"
		if ((configname _x select [0,6]) == "Supply") then
		{
			_exclude_list pushBack _x;
		};
		// excluding carrier parts which are hidden from editor
		if (((configname _x select [0,15]) == "Land_Carrier_01") && {getnumber(_x >> "scope") != 2}) then
		{
			_exclude_list pushBack _x;
		};
		
		// Verifying allegiance of an asset into chosen category		
		if (_side == 3 && {_editorcategory in (_categories select _categories_param)} && {!(_x in _exclude_list)}) then
		{
			_parsed pushBack _x;
		};
	} foreach _cfgVehicles;	
	_cfgVehicles = _parsed;
};

_cfgVehiclesCount = count _cfgVehicles;										// count of the subclasses for purpose of the loading screen progress
{
	_scope = getnumber(_x >> "scope");										// getting the scope parameter of the asset
	_side = getnumber(_x >> "side");										// getting the side parameter of the asset
	
	if (_scope > 0 && _side in _sides_param) then							// chooses only the classes with public or private scope (1 or 2)
	{
		_weapons = [];														// initializing the array for the weapons
		_magazines = [];													// initializing the array for the magazines
		
		_textSide = _sides select _side;									// getting the display name of side - number from config is used as array index
		_textScope = _scopes select _scope;									// getting the display name of scope - number from config is used as array index
		_textDLC = "";														// initializing the variable for DLC
		_iconDLC = "";														// initializing the variable for the icon file
		_textWeapons = "";													// initializing the text variable for weapons
		_textMagazines = "";												// initializing the text variable for magazines
		_textItems = "";													// initializing the text variable for items
		_textAddons = "";													// initializing the text variable for addons
		_textFeatures = "";													// initializing the text variable for features
		
		/* features attribute variables */
		_tmp_features_int = 0;
		_tmp_features_array = [];
		_count_textures = 0;
		_count_animations = 0;
		_count_hiddensel = 0;	
		_count_vehcapacity = 0;
		_count_turrets = 0;
		_array_turrets = [];
		_count_slingload = 0;
		_count_sling_ropes = 0;
		_can_float = 0;
		
		/* vehicle capacity details*/
		_driver = 0;
		_copilot = 0;
		_commanders = 0;
		_ffv_positions = 0;
		_gunners = 0;
		_cargo = 0;
		
		/* vehicle roles details */
		_veh_medic = 0;
		_veh_repair = 0;
		_veh_ammo = 0;
		_veh_fuel = 0;
		
		/* vehicle in vehicle tranport */
		_veh_carrier = 0;
		_veh_cargo = 0;
		
		/* men roles details */
		_men_medic = 0;
		_men_repair = 0;
		_men_mines = 0;
		_men_uav = 0;
	
		_classname = configname _x;																										// getting the class name of the object
		_displayname = gettext(_x >> "displayname");																					// getting the display name of the object
		_editorcategory = gettext(configfile >> "cfgeditorcategories" >> gettext(_x >> "editorCategory") >> "displayname");				// getting editorcategory display name
		_editorsubcategory = gettext(configfile >> "cfgeditorsubcategories" >> gettext(_x >> "editorSubcategory") >> "displayname");	// getting editor subcategory display name
		_items = ([gettext (_x >> "uniformClass")] + getarray (_x >> "linkedItems") + getarray (_x >> "items")) - [""];					// getting the list of the items
		_addons = unitaddons _classname;																								// getting a list of addons required for the object
		
		// if editorCategory is empty, variable is filled with faction instead
		if (_editorcategory == "") then
		{
			_editorcategory = gettext(configfile >> "cfgFactionClasses" >> gettext(_x >> "faction") >> "displayname");
		};
		
		// if editorsubcategory is empty, variable is filled with vehicleclass instead
		if (_editorsubcategory == "") then
		{
			_editorsubcategory = gettext(configfile >> "cfgVehicleClasses" >> gettext(_x >> "vehicleClass") >> "displayname");
		};
		
		// if the asset was released as part of DLC, there will be selected text for name of the expansion
		_textDLC = gettext(_x >> "DLC");
		if ((_icons_DLC find _textDLC) != -1) then
		{
			_iconDLC = _icons_DLC select ((_icons_DLC find _textDLC)+1);
		};
		
		// Props do not need to have these parameters listed
		if (_categories_param == 0) then 
		{
			// loop for adding the turret weapons and magazines to the variables for current object
			{
				_weapons = _weapons + getarray (_x >> "weapons");
				_magazines = _magazines + getarray (_x >> "magazines");
			} foreach (_classname call bis_fnc_getTurrets);
			
			// formatting of the _weapons array to fit to the wiki table, adding links
			{
				_type = _x call bis_fnc_itemType;								// getting the type of the weapon
				_page = (_type select 0) call _fnc_getItemPage;					// getting and appropriate
				_textWeapons = _textWeapons + _br + format [":[[%1 %3#%2|%2]]",_product,_x,_page];
			} foreach _weapons;
			
			// formatting of the magazines - aggregating the duplicite magazines, adding links
			while {count _magazines > 0} do {
				_mag = _magazines select 0;
				_textMagazines = _textMagazines + _br + format [":%1x&nbsp;[[%3 CfgMagazines#%2|%2]]",{_x == _mag} count _magazines,_mag,_product];
				_magazines = _magazines - [_mag];
			};
			
			// formatting of the items
			while {count _items > 0} do {
				_item = _items select 0;
				_type = _item call bis_fnc_itemType;
				_page = (_type select 0) call _fnc_getItemPage;
				_textItems = _textItems + _br + format [":[[%4 %3#%2|%2]]",{_x == _item} count _items,_item,_page,_product];
				_items = _items - [_item];
			};
		};
		
		// formatting the addons list, adding links
		{	// Addons starting with CuratorOnly shouldn't appear in the list
			if ((_x find "CuratorOnly") == -1) then 
			{
				_textAddons = _textAddons + _br + format [":[[%1 CfgPatches CfgVehicles#%2|%2]]",_product,_x];
			};
		} foreach _addons;
		
		/* FEATURES */
		/* RANDOMIZATION */
		// Randomization has two parts - textures and components
		_textFeatures = _textFeatures + "'''Randomization:''' ";
		
		// parsing amount of skins, which have non-zero value
		_tmp_features_array = getarray(_x >> "TextureList");
		for [{_i = 0},{_i < count _tmp_features_array},{_i = _i + 2}] do 
		{
			if (_tmp_features_array select (_i + 1) > 0) then
			{
				_count_textures = _count_textures + 1;
			};
		};
		
		// parsing amount of components, which have probability to be random - values between 0 and 1
		_tmp_features_array = getarray(_x >> "animationList");
		for [{_i = 0},{_i < count _tmp_features_array},{_i = _i + 2}] do 
		{
			if (_tmp_features_array select (_i + 1) > 0 && _tmp_features_array select (_i + 1) < 1) then
			{
				_count_animations = _count_animations + 1;
			};
		};
		
		// creating the final text for randomization, based on the values obtained from before
		if (_count_textures > 1 || {_count_animations > 0}) then
		{
			_textFeatures = _textFeatures + "Yes";
			// writing the amount of skins
			if (_count_textures > 1) then
			{
				_textFeatures = _textFeatures + ", " + str _count_textures + " skins";
			};
			
			// writing the amount of components
			if (_count_animations > 0) then
			{
				_textFeatures = _textFeatures + ", " + str _count_animations + " component";
				
				if (_count_animations > 1) then
				{
					_textFeatures = _textFeatures + "s";
				};
			};
			
			_textFeatures = _textFeatures + _br_long;
		}
		else 
		{
			_textFeatures = _textFeatures + "No" + _br_long;
		};
		
		/* CAMO SELECTIONS */
		// getting the amount of hidden selections used for camouflage
		_count_hiddensel = count getarray(_x >> "hiddenSelections");
		_textFeatures = _textFeatures + "'''Camo&nbsp;selections:'''&nbsp;" + str _count_hiddensel + _br_long;
		
		/* VEHICLE SPECIFIC FEATURES */
		if ((configname _x isKindOf "Air") || {configname _x isKindOf "Car"} || {configname _x isKindOf "Tank"} || {configname _x isKindOf "Ship"}) then
		{ 
			/* VEHICLE CAPACITY */
			// function to iterate through turrets, to get their count and list
			_get_count_turrets = 
			{
				private _config = _this select 0;
				_count_turrets = _count_turrets + count("true" configClasses(_config >> "Turrets"));
				{
					_array_turrets pushBack _x;			// creates array of configs for the turrets, so they can be sorted out
					[_x] call _get_count_turrets;		// checks if the turret has any other turrets as children
				} forEach ("true" configClasses(_config >> "Turrets"));
			};
			
			[_x] call _get_count_turrets;			// call the function to count and list the turrets
			
			_driver = getnumber(_x >> "hasDriver");			// getting value to determine whether there is a driver (but always should be)
			_cargo = getnumber(_x >> "transportSoldier");	// getting value to determine amount of cargo positions
			
			// iterating through the array of configs for turrets to determine their types
			{	// whether the turret is a commander
				if (gettext(_x >> "ProxyType") == "CPCommander") then
				{
					_commanders = _commanders + 1;
				} else 
				{	// whether the turret is a copilot
					if ((getnumber(_x >> "isCopilot") == 1) && {count(getarray(_x >> "weapons")) == 0 || count(getarray(_x >> "magazines")) == 0}) then
					{
						_copilot = _copilot + 1;
					}
					else
					{	// whether the turret is a firing from the vehicle
						if (getnumber(_x >> "isPersonTurret") == 1 && {count(getarray(_x >> "weapons")) == 0 || {count(getarray(_x >> "magazines")) == 0} || {gettext(_x >> "ProxyType") == "CPCargo"}}) then
						{
							_ffv_positions = _ffv_positions + 1;
						} else
						{	// anything else is a gunner
							_gunners = _gunners + 1;
						};
					};
				};
			} forEach _array_turrets;
			
			_count_vehcapacity = _driver + _cargo + _count_turrets; 	// capacity of vehicle is driver, amount of cargo positions and amount of turrets
			
			_textFeatures = _textFeatures + "'''Vehicle&nbsp;capacity:'''&nbsp;";
			// vehicles with parameter isUav have are remotely controlled
			if (getnumber(_x >> "isUav") == 1) then
			{
				_textFeatures = _textFeatures + "Remotely&nbsp;controlled, ";
			};
			_textFeatures = _textFeatures + str _count_vehcapacity;
			
			// if capacity is more than a zero, we'll write more elaborate description
			if (_count_vehcapacity > 0) then
			{
				_textFeatures = _textFeatures + " --> ";
				
				// "amount" of drivers (always just one)
				if (_driver > 0) then
				{
					_textFeatures = _textFeatures + str _driver + "&nbsp;driver";
				};
				
				// "amount" of copilots
				if (_copilot > 0) then
				{
					if (_driver > 0) then
					{
						_textFeatures = _textFeatures + "," + _br_long;
					};
					_textFeatures = _textFeatures + str _copilot + "&nbsp;copilot";
					
					if (_copilot > 1) then
					{
						_textFeatures = _textFeatures + "s";
					};
				};
				
				// amount of commanders
				if (_commanders > 0) then
				{
					if ((_driver > 0) || {_copilot > 0}) then
					{
						_textFeatures = _textFeatures + "," + _br_long;
					};
					_textFeatures = _textFeatures + str _commanders + "&nbsp;commander";
					
					if (_commanders > 1) then
					{
						_textFeatures = _textFeatures + "s";
					};
				};
				
				// amount of gunners
				if (_gunners > 0) then
				{
					if ((_driver > 0) || {_copilot > 0} || {_commanders > 0}) then
					{
						_textFeatures = _textFeatures + ","  + _br_long;
					};
					_textFeatures = _textFeatures + str _gunners + "&nbsp;gunner";
					
					if (_gunners > 1) then
					{
						_textFeatures = _textFeatures + "s";
					};
				};
				
				// amount of positions for firing from vehicle
				if (_ffv_positions > 0) then
				{
					if ((_driver > 0) || {_copilot > 0} || {_commanders > 0} || {_gunners > 0}) then
					{
						_textFeatures = _textFeatures + "," + _br_long;
					};
					_textFeatures = _textFeatures + str _ffv_positions + "&nbsp;firing&nbsp;position";
					
					if (_ffv_positions > 1) then
					{
						_textFeatures = _textFeatures + "s";
					};
				};
				
				// amount of cargo positions
				if (_cargo > 0) then
				{
					if ((_driver > 0) || {_copilot > 0} || {_commanders > 0} || {_gunners > 0} || {_ffv_positions > 0}) then
					{
						_textFeatures = _textFeatures + "," + _br_long;
					};
					_textFeatures = _textFeatures + str _cargo + "&nbsp;cargo&nbsp;position";
					
					if (_cargo > 1) then
					{
						_textFeatures = _textFeatures + "s";
					};
				};
				
				_textFeatures = _textFeatures + _br_long;
			};
			
			/* ROLES */
			_veh_medic = getnumber(_x >> "attendant");
			_veh_ammo = getnumber(_x >> "transportAmmo");
			_veh_fuel = getnumber(_x >> "transportFuel");
			_veh_repair = getnumber(_x >> "transportRepair");
			
			_textFeatures = _textFeatures + "'''Roles:''' ";
			// vehicle can heal, medic role
			if (_veh_medic > 0) then 
			{
				_textFeatures = _textFeatures + "can&nbsp;heal";
			};
			// vehicle can repair
			if (_veh_repair > 0) then 
			{
				if (_veh_medic > 0) then 
				{
					_textFeatures = _textFeatures + "," + _br;
				};
				_textFeatures = _textFeatures + "can&nbsp;repair";
			};
			// vehicle transports ammo, can replenish
			if (_veh_ammo > 0) then 
			{
				if (_veh_medic > 0 || {_veh_repair > 0}) then 
				{
					_textFeatures = _textFeatures + ",";
				};
				_textFeatures = _textFeatures + "can&nbsp;replenish&nbsp;ammo";
			};
			// vehicle transports fuel, can replenish
			if (_veh_fuel > 0) then 
			{
				if (_veh_medic > 0 || {_veh_repair > 0} || {_veh_ammo > 0}) then 
				{
					_textFeatures = _textFeatures + "," + _br;
				};
				_textFeatures = _textFeatures + "can&nbsp;replenish&nbsp;fuel";
			};
			
			// no roles
			if (!(_veh_fuel > 0) && {!(_veh_medic > 0)} && {!(_veh_repair > 0)} && {!(_veh_ammo > 0)}) then 
			{
				_textFeatures = _textFeatures + "None";
			};
			_textFeatures = _textFeatures + _br_long;
			
			/* FLOATING */
			_can_float = getnumber(_x >> "canFloat");
			_textFeatures = _textFeatures + "'''Can&nbsp;float:'''&nbsp;";
			
			if (_can_float == 1) then
			{
				_textFeatures = _textFeatures + "Yes" + _br_long;
			}
			else
			{
				_textFeatures = _textFeatures + "No" + _br_long;
			};
			
			/* VEHICLE IN VEHICLE TRANSPORT */
			_textFeatures = _textFeatures + "'''Vehicle&nbsp;in&nbsp;vehicle&nbsp;transport:''' ";
			if (isclass (_x >> "VehicleTransport")) then
			{
				_veh_carrier = getnumber(_x >> "VehicleTransport" >> "Carrier" >> "maxLoadMass");
				_veh_cargo = getnumber(_x >> "VehicleTransport" >> "Cargo" >> "canBeTransported");
			}
			else 
			{   // specific vehicles can be blacklisted and therefore can't be loaded, done with config parameter 
				// therefore if config parameter is missing, vehicle can be loaded
				// from https://confluence.bistudio.com/display/ARMA3/Vehicle+in+Vehicle+Transport 
				_veh_cargo = 1;
			};
			
			if (_veh_carrier > 0) then
			{
				_textFeatures = _textFeatures + "Can&nbsp;transport,&nbsp;up&nbsp;to&nbsp;" + str _veh_carrier + "&nbsp;kg. ";
			}
			else
			{
				_textFeatures = _textFeatures + "Cannot&nbsp;transport. ";
			};
			
			if (_veh_cargo > 0) then
			{
				_textFeatures = _textFeatures + "Can be transported." + _br_long;
			}
			else
			{
				_textFeatures = _textFeatures + "Cannot be transported." + _br_long;
			};
			
			/* SLINGLOAD */
			_count_slingload = getnumber(_x >> "slingLoadMaxCargoMass");
			_textFeatures = _textFeatures + "'''Slingload:''' ";
			
			if (_count_slingload > 0) then 
			{
				_textFeatures = _textFeatures + "Yes,&nbsp;up&nbsp;to&nbsp;" + str _count_slingload + "&nbsp;kg" + _br_long;
			}
			else
			{
				_textFeatures = _textFeatures + "No" + _br_long;
			};
		};
		
		/* MEN SPECIFIC FEATURES */
		if ((configname _x isKindOf "Man") && {!(configname _x isKindOf "Animal")}) then
		{ 
			/* ROLES */
			_textFeatures = _textFeatures + "'''Roles:''' ";
			
			_men_medic = getnumber(_x >> "attendant");
			_men_repair = getnumber(_x >> "engineer");
			_men_mines = getnumber(_x >> "canDeactivateMines");
			_men_uav = getnumber(_x >> "uavHacker");
			
			// man can heal, medic role
			if (_men_medic > 0) then 
			{
				_textFeatures = _textFeatures + "can&nbsp;heal";
			};
			// man can repair, engineer role
			if (_men_repair > 0) then 
			{
				if (_men_medic > 0) then 
				{
					_textFeatures = _textFeatures + ", ";
				};
				_textFeatures = _textFeatures + "can&nbsp;repair";
			};
			// man can deactivate mines
			if (_men_mines > 0) then 
			{
				if (_men_medic > 0 || {_men_repair > 0}) then 
				{
					_textFeatures = _textFeatures + ", ";
				};
				_textFeatures = _textFeatures + "can&nbsp;deactivate&nbsp;mines";
			};
			// vehicle transports fuel, can replenish
			if (_men_uav > 0) then 
			{
				if (_men_medic > 0 || {_men_repair > 0} || {_men_mines > 0}) then 
				{
					_textFeatures = _textFeatures + ", ";
				};
				_textFeatures = _textFeatures + "can&nbsp;replenish&nbsp;fuel";
			};
			
			// no roles
			if (!(_men_medic > 0) && {!(_men_repair > 0)} && {!(_men_mines > 0)} && {!(_men_uav > 0)}) then 
			{
				_textFeatures = _textFeatures + "None";
			};
		};
		
		/* FEATURES EXCLUDING MEN */
		if !(configname _x isKindOf "Man") then
		{ 
			/* SLINLOADABLE */
			_textFeatures = _textFeatures + "'''Slingloadable:''' ";
			_count_sling_ropes = count getarray(_x >> "slingLoadCargoMemoryPoints");
			if (_count_sling_ropes > 0) then
			{
				_textFeatures = _textFeatures + "Yes";
			}
			else
			{
				_textFeatures = _textFeatures + "No";
			};
		};

		_text = _text + "|-" + _br;
		_text = _text + "| " + format ["[[File:%1.jpg|150px|&nbsp;]]",_classname] + _br;												// preview
		_text = _text + "| " + format ["<span id=""%1"" >'''%1'''</span>",_classname] + _br;											// class name
		_text = _text + "| " + "''" + _displayname + "''" + _br;																		// display name
		_text = _text + "| " + format ["style='background-color:%2;' | %1",_textSide,_sideColor select _side] + _br;					// side
		_text = _text + "| " + _editorcategory + _br;																					// category
		_text = _text + "| " + _editorsubcategory + _br;																				// subcategory
		_text = _text + "| " + format ["style='background-color:%2;' | %1",_textScope,_scopeColor select _scope] + _br;					// scope
		if (_iconDLC != "") then 																										// DLC
		{
			_text = _text + "| " + format ["[[File:%1.png|50px]]",_iconDLC] + _br;												
		}
		else
		{
			_text = _text + "| " + _textDLC + _br;
		};
		// Props do not need to have these parameters listed
		if (_categories_param == 0) then 
		{
			_text = _text + "| " + _textWeapons + _br;																					// weapons
			_text = _text + "| " + _textMagazines + _br;																				// magazines
			_text = _text + "| " + _textItems + _br + _br;																				// items
		};
		_text = _text + "| " + _textAddons + _br + _br;																					// addons
		_text = _text + "| " + _textFeatures + _br;																						// features
		
	};
	progressloadingscreen (_foreachindex / _cfgVehiclesCount);
} foreach _cfgVehicles;

_text = _text + "|}" + _br;													// wiki table ending
_text = _text + format [
		"<small style=""color:grey;"">Generated by [[%1]] in [[%2]] version %3.%4 by ~~~~</small>",
		_fnc_scriptName,
		productversion select 0,
		(productversion select 2) * 0.01,
		productversion select 3
	] + _br;
_text = _text + format ["<br />{{Template:%1 Assets}}",_product];
copytoclipboard _text;														// copying the contents to the clipboard

endloadingscreen;