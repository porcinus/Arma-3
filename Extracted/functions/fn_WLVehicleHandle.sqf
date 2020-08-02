/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Keeps track of spawned vehicles.
*/

_veh = _this # 0;
_id = _this # 1;
_byAI = _this # 2;

_mrkrName = format ["BIS_WL_vehMarker_%1", _id];
_veh setVariable ["BIS_WL_trackMarker", _mrkrName];
_vehName = "";
if !(isNil {_veh getVariable "BIS_WL_customName"}) then {
	_vehName = _veh getVariable "BIS_WL_customName";
} else {
	_vehName = getText (BIS_WL_cfgVehs >> typeOf _veh >> "displayName");
};
_vehClass = toLower getText (BIS_WL_cfgVehs >> typeOf _veh >> "vehicleClass");

if !(_byAI || _vehClass in ["static", "autonomous"]) then {
	_mrkr = createMarkerLocal [_mrkrName, position _veh];
	_mrkrName setMarkerSizeLocal [0.5, 0.5];
	_mrkrName setMarkerColorLocal (["colorOPFOR", "colorBLUFOR", "colorIndependent"] # (BIS_WL_sidesPool find side group player));
	_mrkrName setMarkerTypeLocal "mil_box";
	_mrkrName setMarkerTextLocal _vehName;
	_mrkrName setMarkerAlphaLocal 0.35;
};

if !(_vehClass in ["ammo", "static", "autonomous"]) then {
	_veh setVariable ["BIS_WL_deleteTimeout", time + BIS_WL_vehicleSpan];
	_veh addEventHandler ["GetIn", {
		if (group (_this # 2) == group player) then {
			deleteMarkerLocal ((_this # 0) getVariable "BIS_WL_trackMarker");
			(_this # 0) setVariable ["BIS_WL_trackMarker", ""];
			(_this # 0) removeAllEventHandlers "GetIn";
		};
	}];
} else {
	_veh setVariable ["BIS_WL_deleteTimeout", time + (BIS_WL_vehicleSpan * 3)];
	if (_vehClass == "ammo") then {
		_veh spawn {
			sleep 300;
			deleteMarkerLocal (_this getVariable "BIS_WL_trackMarker");
			_this setVariable ["BIS_WL_trackMarker", ""];
		};
	};
};

_veh addEventHandler ["Killed", {(_this # 0) setVariable ["BIS_WL_deleteTimeout", time + 60]}];

_tmoutUpdated = TRUE;

while {!isNull _veh} do {
	if !(_byAI || (_veh getVariable "BIS_WL_trackMarker") == "") then {
		_mrkrName setMarkerPosLocal position _veh;
	};
	if ((crew _veh) findIf {alive _x} == -1) then {
		if (!_tmoutUpdated && alive _veh) then {
			_veh setVariable ["BIS_WL_deleteTimeout", time + BIS_WL_vehicleSpan];
			_tmoutUpdated = TRUE;
		};
		if (time > (_veh getVariable "BIS_WL_deleteTimeout")) exitWith {deleteMarkerLocal _mrkrName; ["Deleting abandoned vehicle %1", _veh] call BIS_fnc_WLdebug; {if !(isPlayer _x) then {_grp = group _x; _veh deleteVehicleCrew _x; if (count units _grp == 0) then {deleteGroup _grp}} else {_x setPos position _veh}} forEach crew _veh; deleteVehicle _veh};
	} else {
		_tmoutUpdated = FALSE;
	};
	sleep 5;
};

deleteMarkerLocal _mrkrName;