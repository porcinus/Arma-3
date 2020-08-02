
/*
	File: returnGroupComposition.sqf
	Author: Joris-Jan van 't Land

	Description:
	Function which returns a logical group composition based on a number of parameters.

	Parameter(s):
	_this select 0: side (Side).
	_this select 1: number of characters (Number).
	_this select 2: (optional) type (String):
		- "riflesquad": (default) standard rifle squad.
		- "sniper": sniper team.

	Returns:
	Array of Strings - object types.
	
	TODO: use CfgGroups instead?
*/

//Validate parameter count
if ((count _this) < 2) exitWith {debugLog "Log: [returnGroupComp] Function requires at least 2 parameters!"; []};

private ["_side", "_amount", "_type"];
_side = _this select 0;
_amount = _this select 1;
_type = "riflesquad";
if ((count _this) == 3) then
{
	_type = _this select 2;
};

//Validate parameters
if ((typeName _side) != (typeName sideEnemy)) exitWith {debugLog "Log: [returnGroupComp] Side (0) must be a Side!"; []};
if ((typeName _amount) != (typeName 0)) exitWith {debugLog "Log: [returnGroupComp] Amount (1) must be a Number!"; []};
if ((typeName _type) != (typeName "")) exitWith {debugLog "Log: [returnGroupComp] Type (2) must be a String!"; []};

private ["_types"];
_types = [];

switch (_side) do
{
	case west:
	{
		switch (_type) do
		{
			case "riflesquad":
			{
				if (_amount == 4) then
				{
					private ["_pool"];
					_pool =
					[
						[
							"B_soldier_TL_F",
							"B_soldier_AR_F",
							"B_soldier_F",
							"B_soldier_LAT_F"
						],

						[
							"B_soldier_TL_F",
							"B_support_MG_F",
							"B_soldier_AR_F",
							"B_soldier_F"
						],

						[
							"B_soldier_TL_F",
							"B_soldier_AR_F",
							"B_soldier_LAT_F",
							"B_soldier_AT_F"
						],

						[
							"B_soldier_TL_F",
							"B_soldier_AR_F",
							"B_soldier_F",
							"B_medic_F"
						]
					];

					_types = _pool call BIS_fnc_selectRandom;
				};

				if (_amount == 9) then
				{
					private ["_pool"];
					_pool =
					[
						[
							"B_soldier_SL_F",
							"B_soldier_TL_F",
							"B_soldier_AR_F",
							"B_soldier_F",
							"B_soldier_LAT_F",
							"B_soldier_TL_F",
							"B_soldier_AR_F",
							"B_soldier_F",
							"B_soldier_F"
						],

						//Weapons squad.
						[
							"B_soldier_SL_F",
							"B_soldier_TL_F",
							"B_support_MG_F",
							"B_soldier_AR_F",
							"B_soldier_F",
							"B_soldier_TL_F",
							"B_support_AMG_F",
							"B_soldier_AR_F",
							"B_soldier_F"
						]
					];

					_types = _pool call BIS_fnc_selectRandom;
				};
			};

			default {};
		};

		//Randomize.
		if ((count _types) == 0) then
		{
			//Squad leader?
			if (_amount > 4) then
			{
				_types = _types + ["B_soldier_SL_F"];
			};

			//Corpsman?
			if ((_amount > 4) && ((random 1) > 0.5)) then
			{
				_types = _types + ["B_medic_F"];
			};

			//Fill the rest.
			private ["_pool"];
			_pool =
			[
				"B_soldier_F",
				"B_soldier_F",
				"B_soldier_AR_F"
			];

			for "_i" from 0 to ((_amount - (count _types)) - 1) do
			{
				_types = _types + [_pool call BIS_fnc_selectRandom];
			};
		};
	};

	case east:
	{
		switch (_type) do
		{
			case "riflesquad":
			{
				//Weapons squad.
				if (_amount == 7) then
				{
					_types =
					[
						"O_soldier_SL_F",
						"O_support_GMG_F",
						"O_soldier_F",
						"O_support_AMG_F",
						"O_soldier_F",
						"O_soldier_LAT_F",
						"O_soldier_F"
					];
				};

				if (_amount == 9) then
				{
					_types =
					[
						"O_soldier_SL_F",
						"O_soldier_F",
						"O_soldier_GL_F",
						"O_soldier_AR_F",
						"O_soldier_LAT_F",
						"O_soldier_F",
						"O_soldier_GL_F",
						"O_soldier_AR_F",
						"O_soldier_M_F"
					];
				};
			};

			default {};
		};

		//Randomize.
		if ((count _types) == 0) then
		{
			//Squad leader?
			if (_amount > 4) then
			{
				_types = _types + ["O_soldier_SL_F"];
			};

			//Medic?
			if ((_amount > 4) && ((random 1) > 0.5)) then
			{
				_types = _types + ["O_medic_F"];
			};

			//Marksman?
			if ((_amount > 4) && ((random 1) > 0.7)) then
			{
				_types = _types + ["O_soldier_M_F"];
			};

			//AA soldier?
			if ((_amount > 5) && ((random 1) > 0.6)) then
			{
				_types = _types + ["O_soldier_AA_F"];
			};

			//Fill the rest.
			private ["_pool"];
			_pool =
			[
				"O_soldier_F",
				"O_soldier_GL_F",
				"O_soldier_AR_F"
			];

			for "_i" from 0 to ((_amount - (count _types)) - 1) do
			{
				_types = _types + [_pool call BIS_fnc_selectRandom];
			};
		};
	};
	
	case resistance:
	{
		switch (_type) do
		{
			case "riflesquad":
			{
				//Weapons squad.
				if (_amount == 7) then
				{
					_types =
					[
						"I_soldier_SL_F",
						"I_support_MG_F",
						"I_soldier_F",
						"I_support_AMG_F",
						"I_soldier_F",
						"I_soldier_LAT_F",
						"I_soldier_F"
					];
				};

				if (_amount == 9) then
				{
					_types =
					[
						"I_soldier_SL_F",
						"I_soldier_F",
						"I_soldier_GL_F",
						"I_soldier_AR_F",
						"I_soldier_LAT_F",
						"I_soldier_F",
						"I_soldier_GL_F",
						"I_soldier_AR_F",
						"I_soldier_F"
					];
				};
			};

			default {};
		};

		//Randomize.
		if ((count _types) == 0) then
		{
			//Squad leader?
			if (_amount > 4) then
			{
				_types = _types + ["I_soldier_SL_F"];
			};

			//Medic?
			if ((_amount > 4) && ((random 1) > 0.5)) then
			{
				_types = _types + ["I_medic_F"];
			};

			//AA soldier?
			if ((_amount > 5) && ((random 1) > 0.6)) then
			{
				_types = _types + ["I_Soldier_AA_F"];
			};

			//Fill the rest.
			private ["_pool"];
			_pool =
			[
				"I_soldier_F", 
				"I_soldier_F", 
				"I_soldier_GL_F",
				"I_soldier_AR_F"
			];

			for "_i" from 0 to ((_amount - (count _types)) - 1) do
			{
				_types = _types + [_pool call BIS_fnc_selectRandom];
			};
		};
	};

	default {};
};

_types