scriptName "BIS_fnc_animalRandomization: functions_F";
/*
	Author: Julien VIDA <@tom_48_97>

	Description:
	Randomize the texture to use for animals

	Parameter(s):
	_this: Object - an animal

	Returns:
	Nothing  - maybe a unmicorn, some day
*/
#define SELF BIS_fnc_animalRandomization

if !(local _this) exitWith {/*Goat bye!*/};

/*---------------------------------------------------------------------------
	class ButterFly_random: Insect
---------------------------------------------------------------------------*/
if (_this isKindOf "ButterFly_random") exitWith
{
	_textureList =
	[
		"\A3\Animals_F\Data\Butterfly_Pasha_co.paa",
		"\A3\Animals_F\Data\Butterfly_Swallow_co.paa",
		"\A3\Animals_F\Data\Butterfly_Tortoise_co.paa",
		"\A3\Animals_F\Data\Butterfly_White_co.paa"
	];
	_this setObjectTextureGlobal [0, (_textureList call BIS_fnc_selectRandom)];
};

/*---------------------------------------------------------------------------
	class Snake_random_F: Animal_Base_F // The doorman!
---------------------------------------------------------------------------*/
if (_this isKindOf "Snake_random_F") exitWith
{
	_textureList =
	[
		"\A3\Animals_F\Snakes\data\Snake_Dice_CO.paa",
		"\A3\Animals_F\Snakes\data\Snake_Leopard_CO.paa"
	];
	_this setObjectTextureGlobal [0, (_textureList call BIS_fnc_selectRandom)];
};

/*---------------------------------------------------------------------------
	class Fin_random_F: Fin_Base_F
---------------------------------------------------------------------------*/
if (_this isKindOf "Fin_random_F") exitWith
{
	_textureList =
	[
		"\A3\animals_f_beta\dog\data\Dog_tricolor_CO.paa",
		"\A3\animals_f_beta\dog\data\Dog_white_ocher_CO.paa",
		"\A3\animals_f_beta\dog\data\dog_black_white_co.paa",
		"\A3\animals_f_beta\dog\data\dog_yellow_co.paa"
	];
	_this setObjectTextureGlobal [0, (_textureList call BIS_fnc_selectRandom)];
};

/*---------------------------------------------------------------------------
	class Alsatian_Random_F: Alsatian_Base_F
---------------------------------------------------------------------------*/
if (_this isKindOf "Alsatian_Random_F") exitWith
{
	_textureList =
	[
		"\A3\animals_f_beta\dog\data\pastor_co.paa",
		"\A3\animals_f_beta\dog\data\pastor_black_co.paa",
		"\A3\animals_f_beta\dog\data\pastor_sand_co.paa"
	];
	_this setObjectTextureGlobal [0, (_textureList call BIS_fnc_selectRandom)];
};

/*---------------------------------------------------------------------------
	class Goat_random_F: Goat_Base_F // Nelson FTW
---------------------------------------------------------------------------*/
if (_this isKindOf "Goat_random_F") exitWith
{
	_textureList =
	[
		"\A3\animals_f_beta\goat\data\black_goat_co.paa",
		"\A3\animals_f_beta\goat\data\white_goat_co.paa",
		"\A3\animals_f_beta\goat\data\dirt_goat_co.paa",
		"\A3\animals_f_beta\goat\data\old_goat_co.paa"
	];
	_materialList =
	[
		"\A3\animals_f_beta\goat\data\goat_black.rvmat",
		"\A3\animals_f_beta\goat\data\goat_white.rvmat",
		"\A3\animals_f_beta\goat\data\goat_dirt.rvmat",
		"\A3\animals_f_beta\goat\data\goat_old.rvmat"
	];
	_rand = floor (random 4);
	_this setObjectTextureGlobal [0,(_textureList select _rand)];
	_this setObjectMaterialGlobal [0,(_materialList select _rand)];
};

/*---------------------------------------------------------------------------
	class Sheep_random_F: Animal_Base_F // Don't follow your neighbor!
---------------------------------------------------------------------------*/
if (_this isKindOf "Sheep_random_F") exitWith
{
	_textureList =
	[
		"\A3\animals_f_beta\Sheep\data\blackwhite_sheep_co.paa",
		"\A3\animals_f_beta\Sheep\data\brown_sheep_co.paa",
		"\A3\animals_f_beta\Sheep\data\white_sheep_co.paa",
		"\A3\animals_f_beta\Sheep\data\tricolor_sheep_co.paa"
	];
	_rand = floor (random 4);
	_this setObjectTextureGlobal [0,(_textureList select _rand)];
	if (_rand == 3) then {_this setObjectMaterialGlobal [0,"\A3\animals_f_beta\Sheep\data\sheepShort.rvmat"];};
};

/*---------------------------------------------------------------------------
	class Cock_random_F: Animal_Base_F
---------------------------------------------------------------------------*/
if (_this isKindOf "Cock_random_F") exitWith
{
	_textureList =
	[
		"\A3\animals_f_beta\Chicken\data\brown_rooster_CO.paa",
		"\A3\animals_f_beta\Chicken\data\white_rooster_CO.paa"
	];
	_materialList =
	[
		"\A3\animals_f_beta\Chicken\data\cock_brown.rvmat",
		"\A3\animals_f_beta\Chicken\data\cock_white.rvmat"
	];
	_rand = floor (random 2);
	_this setObjectTextureGlobal [0,(_textureList select _rand)];
	_this setObjectMaterialGlobal [0,(_materialList select _rand)];
};