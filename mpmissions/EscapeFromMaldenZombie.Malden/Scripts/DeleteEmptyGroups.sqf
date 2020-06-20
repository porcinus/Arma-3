// NNS : full rework, look glitchy with crew in vehicle not destroyed, ignore agents

params
[
	["_maxDist",1800]
];

while {true} do {
	_vehicletodelete=[];
	{
		_tmpgroup = _x; //backup
		if ((side _tmpgroup in [west,east,resistance]) && {allPlayers findIf {(_x distance2d leader _tmpgroup) > _maxDist} != -1}) then { //group leader far away from players
		//if ((side _tmpgroup in [west,east,resistance]) && ({(_x distance2d leader _tmpgroup) > 1800} count allPlayers > 0)) then { //group leader far away from players
			sleep random 2; //random is here to limit CPU usage when detection happen
		
			{
				_tmpunit = _x; //backup
				if ((!alive _tmpunit) && {allPlayers findIf {(_x distance2d _tmpunit) > _maxDist} != -1}) then { //unit far away from players and dead
				//if (({(_x distance2d _tmpunit) > 1800} count allPlayers > 0) && !(alive _tmpunit)) then { //unit far away from players and dead
					if !(vehicle _tmpunit == _tmpunit) then {
						if (_tmpunit in crew (vehicle _tmpunit)) then { //unit is crew
							if !((vehicle _tmpunit) in _vehicletodelete) then {_vehicletodelete pushBack (vehicle _tmpunit);}; //mark vehicle for deletion
							[format["Remove dead crew:%1 (%2) from vehicle:%2, side:%3",_tmpunit, typeOf _tmpunit, vehicle _tmpunit,side _tmpunit]] call NNS_fnc_debugOutput; //debug
							(vehicle _tmpunit) deleteVehicleCrew _tmpunit; //delete current crew
						};
					};
					
					if !(isNull _tmpunit) then { //if unit still exist
						[format["Remove dead unit:%1 (%2) from group:%3, side:%4",_tmpunit, typeOf _tmpunit, vehicle _tmpunit,side _tmpunit]] call NNS_fnc_debugOutput; //debug
						deleteVehicle _tmpunit; //delete unit
					};
				};
			} forEach units _x; //loop unit in group
			
			if ((count units _tmpgroup) == 0) then { //empty group
				[format["Remove empty group:%1, side:%2", _tmpgroup, side _tmpgroup]] call NNS_fnc_debugOutput; //debug
				deleteGroup _x; //delete group
			};
		};
	} forEach (allGroups - [BIS_grpMain] - [agents]); //group loop
	
	{
		if ((crew _x) findIf {alive _x} == -1) then { //no crew alive
		//if ({alive _x} count crew _x == 0) then { //no crew alive
			[format["Remove empty vehicle:%1 (%2), side:%3", _x, typeOf _x, side _x]] call NNS_fnc_debugOutput; //debug
			deleteVehicle _x; //delete vehicle
		};
	} forEach _vehicletodelete; //vehicle marked for deletion loop
	
	{
		_tmpunit = _x; //backup
		if (((group _tmpunit) isEqualTo grpNull) && {allPlayers findIf {(_x distance2d _tmpunit) > _maxDist} != -1}) then { //unit far away from players
		//if (({(_x distance2d _tmpunit) > 1800} count allPlayers > 0) && ((group _tmpunit) isEqualTo grpNull)) then { //unit far away from players
			[format["Remove groupless unit:%1 (%2), side:%2", _x, typeOf _x, side _x]] call NNS_fnc_debugOutput; //debug
			deleteVehicle _x; //delete unit
		};
	} forEach allDead; //deal with groupless dead units
	
	sleep 30;
};
