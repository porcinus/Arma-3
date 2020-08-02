/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Manage connecting and disconnecting players.
*/

while {TRUE} do {
	BIS_WL_trackerTick = FALSE;
	{
		if !(isNil {_x getVariable "BIS_WL_playerTracked"}) then {
			_player = _x getVariable "BIS_WL_playerTracked";
			if !(isPlayer _player) then {
				if !(isNull _player) then {
					_player setVariable ["BIS_WL_pointer", nil, TRUE];
					_player setVariable ["BIS_WL_playerTrackerHandled", nil, TRUE];
				};
				_tracker = _x;
				_purchased = +(_tracker getVariable "BIS_WL_purchased");
				_grp = group _tracker;
				deleteVehicle _tracker;
				deleteGroup _grp;
				_grp = grpNull;
				{
					if !(isNull _x) then {
						if (_x isKindOf "Man") then {
							if (alive _x) then {_grp = group _x};
							if (vehicle _x == _x) then {deleteVehicle _x} else {(vehicle _x) deleteVehicleCrew _x};
							if (count units _grp == 0 && !isNull _grp) then {deleteGroup _grp};
						} else {
							_veh = _x;
							_attachedTo = attachedTo _veh;
							if (!isNull _attachedTo) then {
								detach _veh;
								deleteVehicle _attachedTo;
							};
							{
								_grp = group _x;
								if (!isPlayer leader _x) then {
									(vehicle _x) deleteVehicleCrew _x;
								} else {
									_x setPos [(position _veh) # 0, (position _veh) # 1, 0.25];
									_x setVelocity [0,0,0];
								};
							} forEach crew _veh;
							if (!isPlayer leader _grp && count units _grp == 0 && !isNull _grp) then {deleteGroup _grp};
							deleteVehicle _veh;
						};
					};
				} forEach _purchased;
			};
		};
	} forEach entities "Logic";
	waitUntil {BIS_WL_trackerTick};
	sleep 1;
};