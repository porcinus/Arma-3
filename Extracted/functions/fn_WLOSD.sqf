/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Manages temporary info in hints.
*/

while {TRUE} do {
	_hintText = "";
	{
		if (_x != "") then {
			if (_hintText != "") then {
				_hintText = _hintText + "<br/><br/>";
			};
			if (_forEachIndex > 3) then {
				if (_forEachIndex != BIS_WL_hintPrio_baseVulnerable) then {
					_hintText = _hintText + format ["<t size = '%2'>" + toUpper _x + "</t>", "<br/>", (1.175 call BIS_fnc_WLSubroutine_purchaseMenuGetUIScale)];
				} else {
					_hintText = _hintText + format ["<t size = '%2'>" + _x + "</t>", "<br/>", (1.175 call BIS_fnc_WLSubroutine_purchaseMenuGetUIScale)];
				};
			} else {
				_hintText = _hintText + _x;
			};
		};
	} forEach BIS_WL_hintArray;
	if (!BIS_WL_purchaseMenuVisible) then {
		hintSilent parseText _hintText;
	};
	sleep 0.25;
};