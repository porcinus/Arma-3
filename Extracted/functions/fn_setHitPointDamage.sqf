/*
	Author: 
		Killzone_Kid

	Description:
		Sets damage to HitPoint with dependency or not (Optional)

	Parameter(s):
		0: OBJECT - Entity to which damage applies
		1: STRING - HitPoint to which damage applies
		2: NUMBER - Amount of damage to apply
		3: BOOLEAN (Optional) 
			TRUE (DEFAULT) - distribute damage to dependent hitpoints as well
			FALSE - apply damage to given hitpoint only

	Returns:
		NOTHING
*/

#define ESCAPE_CHARS "( )[]*/+-,"

/// --- validate input
#include "..\paramsCheck.inc"
#define arr [objNull,"",0]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_entity", "_hitPoint", "_damage", ["_useDependency", true, [true]]];

_entity setHitPointDamage [_hitPoint, _damage];

if (_useDependency) then 
{
	private _cfgHitPoints = configFile >> "CfgVehicles" >> typeOf _entity >> "HitPoints";

	{
		private _expr = getText (_x >> "depends");
		
		{
			private _res = _x call
			{
				if (!isNull (_cfgHitPoints >> _this)) exitWith {_entity getHitPointDamage _this};
				if (_this == "Total") exitWith {damage _entity};
				nil
			};
			
			if (!isNil "_res") then
			{
				_expr find _x call
				{
					_expr = [_expr select [0, _this], _res, _expr select [_this + count _x]] joinString "";
				};
			};
		}
		forEach (_expr splitString ESCAPE_CHARS);

		configName _x call
		{
			_entity setHitPointDamage [_this, (_entity getHitPointDamage _this) max call compile _expr];
		};
	}
	forEach configProperties [_cfgHitPoints, "!(getText (_x >> 'depends') isEqualTo """")", true] - [_cfgHitPoints >> _hitPoint];
};