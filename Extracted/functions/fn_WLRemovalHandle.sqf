/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Units & vehicles garbage collector.
*/

private ["_item", "_sector"];

_item = _this # 0;
_sector = _this # 1;

_item setVariable ["BIS_WL_parentSector", _sector];

if (_item isKindOf "Man") then {
	[_item, _sector] spawn {
		params ["_item", "_sector"];
		_originalOwner = _sector getVariable ["BIS_WL_sectorSide", sideUnknown];
		waitUntil {sleep 60; !alive _item || (_sector getVariable ["BIS_WL_sectorSide", sideUnknown]) != _originalOwner};
		if (alive _item) then {
			sleep 300;
			waitUntil {sleep 60; _pool = BIS_WL_allWarlords select {isPlayer _x}; !alive _item || (vehicle _item == _item && (_pool findIf {_x distance2D _item < 500}) == -1)};
			if (alive _item) then {
				["Deleting stranded survivor %1", _item] call BIS_fnc_WLdebug;
				_grp = group _item;
				deleteVehicle _item;
				if (count units _grp == 0) then {
					deleteGroup _grp;
				};
			};
		};
	};
	_item addEventHandler ["Killed", {
		(_this # 0) spawn {
			scriptName "WLRemovalHandle (man)";
			_side = side group _this;
			_grp = group _this;
			waitUntil {(((_this getVariable ["BIS_WL_parentSector", objNull]) getVariable ["BIS_WL_sectorSide", sideUnknown]) != _side)};
			sleep BIS_WL_spawnedRemovalTime;
			if !(isNull _this) then {
				["Deleting %3 (%1) in %2", typeOf _this, (_this getVariable "BIS_WL_parentSector") getVariable "Name", _this] call BIS_fnc_WLdebug;
				if (vehicle _this == _this) then {
					deleteVehicle _this;
				} else {
					(vehicle _this) deleteVehicleCrew _this;
				};
			};
			if (count units _grp == 0 && !isNull _grp) then {["Deleting group %1", _grp] call BIS_fnc_WLdebug; deleteGroup _grp};
		};
	}];
} else {
	{[_x, _sector] call BIS_fnc_WLremovalHandle} forEach crew _item;
	[_item, -1, TRUE] spawn BIS_fnc_WLvehicleHandle;
};