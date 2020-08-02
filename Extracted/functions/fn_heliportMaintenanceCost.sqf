private ["_heli","_price","_heliDamages","_heliInspections"];

_heli = _this param [0,objnull,[objnull]];
_price = 0;

_heliDamages = _heli getvariable ["HSim_hitpointDamages",[]];
_heliInspections = _heli getvariable ["HSim_hitpointInspections",[]];
{
	if (_x == 0) then {
		_damage = _heliDamages select _foreachindex;
		_price = _price + (_damage * 1000);
	};
} foreach _heliInspections;

round _price