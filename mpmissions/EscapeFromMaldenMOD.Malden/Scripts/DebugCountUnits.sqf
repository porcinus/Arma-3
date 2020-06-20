//NNS: count all units on map

_west_count=0; _west_alive_count=0; _west_active_count=0;
_east_count=0; _east_alive_count=0; _east_active_count=0;
_resistance_count=0; _resistance_alive_count=0; _resistance_active_count=0;
_civilian_count=0; _civilian_alive_count=0; _civilian_active_count=0;

{
	if(side _x==west) then {
		_west_count=_west_count+1;
		if(alive _x) then {_west_alive_count=_west_alive_count+1;};
		if(simulationEnabled _x) then {_west_active_count=_west_active_count+1;};
	};
	
	if(side _x==east) then {
		_east_count=_east_count+1;
		if(alive _x) then {_east_alive_count=_east_alive_count+1;};
		if(simulationEnabled _x) then {_east_active_count=_east_active_count+1;};
	};
	
	if(side _x==resistance) then {
		_resistance_count=_resistance_count+1;
		if(alive _x) then {_resistance_alive_count=_resistance_alive_count+1;};
		if(simulationEnabled _x) then {_resistance_active_count=_resistance_active_count+1;};
	};
	
	if(side _x==civilian) then {
		_civilian_count=_civilian_count+1;
		if(alive _x) then {_civilian_alive_count=_civilian_alive_count+1;};
		if(simulationEnabled _x) then {_civilian_active_count=_civilian_active_count+1;};
	};
	
} forEach allUnits;

["Current units count:",false,true,false,true] call BIS_fnc_NNS_debugOutput; //debug
[format["west: %1 ,alive: %2 ,active: %3",_west_count,_west_alive_count,_west_active_count],false,true,false,true] call BIS_fnc_NNS_debugOutput; //debug
[format["east: %1 ,alive: %2 ,active: %3",_east_count,_east_alive_count,_east_active_count],false,true,false,true] call BIS_fnc_NNS_debugOutput; //debug
[format["resistance: %1 ,alive: %2 ,active: %3",_resistance_count,_resistance_alive_count,_resistance_active_count],false,true,false,true] call BIS_fnc_NNS_debugOutput; //debug
[format["civilian: %1 ,alive: %2 ,active: %3",_civilian_count,_civilian_alive_count,_civilian_active_count],false,true,false,true] call BIS_fnc_NNS_debugOutput; //debug
