/*

	Author: 
		Julien VIDA <@tom_48_97>, modified by Killzone_Kid

	Description: 
		Customises given kart and its driver

	Parameter(s):
		0: OBJECT - kart
		1: ARRAY - kart racing number in format [firstdigit, seconddigit], [-1,-1] to select random  (default)
		3: NUMBER - kart logo 
			 0 - burst koke
			 1 - blue king
			 2 - fuel
			 3 - vrana
			 4 - no logo
			 5 - no logo
			 6 - no logo
			 7 - no logo
			 8 - no logo
			 9 - no logo
			-1 - random  (default)
		4: NUMBER - kart driver uniform
			 0 - black
			 1 - blue
			 2 - green
			 3 - orange
			 4 - red
			 5 - white
			 6 - yellow
			 7 - fuel
			 8 - bluking
			 9 - redstone
			 10 - vrana
			-1 - match kart colour (default)
	Example:
		[mySuperKart, [9,7]] call bis_fnc_initVehicleKart;

*/

private _logoTextures = 
[
	"\A3\Soft_F_Kart\Kart_01\Data\Kart_01_logos_black_CA.paa", // burst koke
	"\A3\Soft_F_Kart\Kart_01\Data\Kart_01_logos_blu_CA.paa", // blue kin
	"\A3\Soft_F_Kart\Kart_01\Data\Kart_01_logos_CA.paa", // fuel
	"\A3\Soft_F_Kart\Kart_01\Data\Kart_01_logos_vrana_CA.paa", //vrana
	"",
	"",
	"",
	"",
	"",
	""
];

private _driverGears = 
[
	["U_C_Driver_1_black", "H_RacingHelmet_1_black_F"], // \a3\Soft_F_Kart\Kart_01\Data\Kart_01_base_black_CO.paa
	["U_C_Driver_1_blue", "H_RacingHelmet_1_blue_F"], // \a3\Soft_F_Kart\Kart_01\Data\Kart_01_base_blue_CO.paa
	["U_C_Driver_1_green", "H_RacingHelmet_1_green_F"], // \a3\Soft_F_Kart\Kart_01\Data\Kart_01_base_green_CO.paa
	["U_C_Driver_1_orange", "H_RacingHelmet_1_orange_F"], // \a3\Soft_F_Kart\Kart_01\Data\Kart_01_base_orange_CO.paa
	["U_C_Driver_1_red", "H_RacingHelmet_1_red_F"], // \a3\Soft_F_Kart\Kart_01\Data\Kart_01_base_red_CO.paa	
	["U_C_Driver_1_white", "H_RacingHelmet_1_white_F"], // \a3\Soft_F_Kart\Kart_01\Data\Kart_01_base_white_CO.paa
	["U_C_Driver_1_yellow", "H_RacingHelmet_1_yellow_F"], // \a3\Soft_F_Kart\Kart_01\Data\Kart_01_base_yellow_CO.paa
	["U_C_Driver_1", "H_RacingHelmet_1_F"], //\a3\Soft_F_Kart\Kart_01\Data\Kart_01_CO.paa - fuel
	["U_C_Driver_2", "H_RacingHelmet_2_F"], // \a3\Soft_F_Kart\Kart_01\Data\Kart_01_blu_CO.paa - bluking
	["U_C_Driver_3", "H_RacingHelmet_3_F"], // \a3\Soft_F_Kart\Kart_01\Data\Kart_01_black_CO.paa - redstone
	["U_C_Driver_4", "H_RacingHelmet_4_F"] // \a3\Soft_F_Kart\Kart_01\Data\Kart_01_vrana_CO.paa - vrana
];

private _kartColors = 
[
	"kart_01_base_black_co",
	"kart_01_base_blue_co",
	"kart_01_base_green_co",
	"kart_01_base_orange_co",
	"kart_01_base_red_co",
	"kart_01_base_white_co",
	"kart_01_base_yellow_co",
	"kart_01_co", // fuel
	"kart_01_blu_co", // blueking
	"kart_01_black_co", // redstone
	"kart_01_vrana_co" // vrana
];

params 
[
	["_vehicle", objNull, [objNull]],
	["_numbers", [-1,-1], [[]], [2]],
	["_logo", -1, [-1]],
	["_gearIndex", -1, [-1]]
];

if !(local _vehicle && _vehicle isKindOf "Kart_01_Base_F") exitWith { false }; // abort if not local kart
private _skipRandomization = getArray (missionConfigfile >> "disableRandomization") findIf { typeOf _vehicle isKindOf _x || vehicleVarname _vehicle == _x } > -1;

/*---------------------------------------------------------------------------
	Number
---------------------------------------------------------------------------*/

if !(_numbers isEqualTypeParams [-1,-1]) then { _numbers = [-1,-1] };

{
	if (_x < 0 || _x > 9) then 
	{ 
		if !(_skipRandomization) then { _vehicle setObjectTextureGlobal [2 + _forEachIndex, format ["\a3\Soft_F_Kart\Kart_01\Data\Kart_num_%1_CA.paa", floor random 10]] };
	} 
	else
	{
		_vehicle setObjectTextureGlobal [2 + _forEachIndex, format ["\a3\Soft_F_Kart\Kart_01\Data\Kart_num_%1_CA.paa", _x]];
	};
}
forEach _numbers;

/*---------------------------------------------------------------------------
	Logo
---------------------------------------------------------------------------*/

if (typeOf _vehicle == "C_Kart_01_F") then
{
	// random
	if (_logo == -1) exitWith { if (!_skipRandomization) exitWith { _vehicle setObjectTextureGlobal [1, selectRandom _logoTextures] } };
	
	_vehicle setObjectTextureGlobal [1, _logoTextures param [_logo, ""]];
};

/*---------------------------------------------------------------------------
	Driver's uniform, here goes some more serious stuff to play with :)
---------------------------------------------------------------------------*/

if (typeOf _vehicle == "C_Kart_01_F") then
{
	private _selectedGear = [];
	
	if (_gearIndex < count _driverGears) then 
	{
		if (_gearIndex >= 0) exitWith { _selectedGear = _driverGears select _gearIndex };
		
		private _kartColor = toLower (getObjectTextures _vehicle select 0);
		_gearIndex = _kartColors findIf { _kartColor find _x > -1 };
		
		if (_gearIndex >= 0) exitWith { _selectedGear = _driverGears select _gearIndex };
		
		if !(_skipRandomization) then { _selectedGear = selectRandom _driverGears };
	}
	else
	{
		if  !(_skipRandomization) then { _selectedGear = selectRandom _driverGears };
	};
	
	if (_selectedGear isEqualTo []) exitWith {};
	
	[_vehicle, _selectedGear] spawn 
	{
		params ["_vehicle", "_selectedGear"];
		
		private _time = time + 1;
		waitUntil { !isNull driver _vehicle || time > _time };
		
		isNil 
		{
			if !(driver _vehicle isKindOf "C_Driver_1_F") exitWith {};
			
			driver _vehicle addUniform (_selectedGear select 0);
			driver _vehicle addHeadgear (_selectedGear select 1);
		};
	};
};

true 