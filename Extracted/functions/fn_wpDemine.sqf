#define DEBUG
#define VAR_MINE	"BIS_fnc_wpDemine_mine"
#define VAR_COUNTER	"BIS_fnc_wpDemine_counter"
#define TIMEOUT_COUNTER	10
#define DELAY		1

#ifdef DEBUG
	"Start of demining" call bis_fnc_log;
#endif

_group = _this param [0,grpnull,[grpnull]];
_pos = _this param [1,[],[[]],3];
_target = _this param [2,objnull,[objnull]];
_clearUnknown = _this param [3,true,[true]];

_wp = [_group,currentwaypoint _group];
_wp setwaypointdescription localize "STR_A3_Functions_F_Orange_Demine";
_wpRadius = waypointCompletionRadius _wp;
if (_wpRadius == 0) then {_wpRadius = 50;};
_side = side _group;

//--- Cleanup
{
	_x setvariable [VAR_MINE,nil];
	_x setvariable [VAR_COUNTER,nil];
} foreach units _group;

//--- ToDo: Timeout when cannot reach specific mine (mark it as unreachable?)

_noMines = false;
waituntil {

	//--- Detect units with capability to disarm mines
	_units = units _group;
	_specialists = _units select {
		((_x getunittrait "explosiveSpecialist") || (_x getunittrait "engineer"))
		&&
		{"ToolKit" in items _x}
	};
	if (count _specialists == 0) exitwith {"No specialists found" call bis_fnc_log;}; //--- Nobody capable - terminate
 
	//--- Detect nearby mines, filter out those which were assigned already
	_mines = if (_clearUnknown) then {allmines} else {detectedmines _side};
	_mines = _mines select {_x distance _pos < _wpRadius};
	_minesAssigned = _units apply {_x getvariable [VAR_MINE,objnull]};
	_minesAvailable = _mines - _minesAssigned;

	//--- Assign orders to all specialists
	{
		_unit = _x;
		if !(isplayer _unit) then {
			_mine = _unit getvariable [VAR_MINE,objnull];
			_counter = _unit getvariable [VAR_COUNTER,0];

			//--- Crawl when mines are nearby
			if ({_unit distance _x < 8} count _mines > 0) then {
				_unit setunitpos "down";
			} else {
				_unit setunitpos "auto";
			};

			if !(isnull _mine) then {

				//--- Continue only if unit completed the previous order
				if (unitready _unit || speed _unit == 0) then {
					if (_unit distance _mine < 2 || _counter > TIMEOUT_COUNTER) then {

						//--- 4: Deactivate
						_unit action ["Deactivate",_unit,_mine];
						_unit setvariable [VAR_MINE,nil];
						#ifdef DEBUG
							["4: %1 deactivating mine %2",_unit,_mine] call bis_fnc_logFormat;
						#endif
					} else {

						//--- 3: Move towards the mine
						_unit domove position _mine;
						_unit setvariable [VAR_COUNTER,if (speed _unit == 0) then {_counter + 1} else {0}]; //--- Increase the counter for timeout detection
						#ifdef DEBUG
							["3: %1 moving to mine %2",_unit,_mine] call bis_fnc_logFormat;
						#endif
					};
				};
			} else {
				if (_unit distance _pos <= _wpRadius) then {
					if (count _minesAvailable > 0) then {
						//--- 2: Assign the nearest mine
						_minesNear = _minesAvailable apply {[_unit distance _x,_x]};
						_minesNear sort true;
						_mine = _minesNear select 0 select 1;
						_minesAvailable = _minesAvailable - [_mine];
						_unit dowatch _mine;
						_unit setvariable [VAR_MINE,_mine];
						_unit setvariable [VAR_COUNTER,0];
						_unit domove position _unit; //--- Cancel going to WP pos
						unassignvehicle _unit;
						[_unit] allowgetin false;
						#ifdef DEBUG
							["2: %1 has been assigned mine %2",_unit,_mine] call bis_fnc_logFormat;
						#endif
					};
				} else {

					//--- 1: Move towards WP when far and not moving already
					if ((expecteddestination _unit select 0) distance _pos > _wpRadius) then {
						_unit domove _pos;
						#ifdef DEBUG
							["1: %1 moving to waypoint",_unit] call bis_fnc_logFormat;
						#endif
					};
				};
			};
		};
	} foreach _specialists;

	//--- Assign orders to all non-specialists
	{
		_unit = _x;
		if (_unit distance _pos <= _wpRadius) then {

			//--- 2: Stop on the edge
			if ((expecteddestination _unit select 0) distance _unit > 1) then {
				_unit domove position _unit;
				#ifdef DEBUG
					["2: %1 stopped, because it's not a specialist",_unit] call bis_fnc_logFormat;
				#endif
			};
		} else {

			//--- 1: Move towards WP when far and not moving already
			if ((expecteddestination _unit select 0) distance _pos > _wpRadius) then {
				_unit domove _pos;
				#ifdef DEBUG
					["1: %1 moving to waypoint",_unit] call bis_fnc_logFormat;
				#endif
			};
		};
	} foreach (_units - _specialists);

	sleep DELAY;

	count _mines == 0 || count _units == 0
};

//--- Cleanup
{
	_x domove _pos;
	_x dowatch objnull;
	_x setvariable [VAR_MINE,nil];
	_x setvariable [VAR_COUNTER,nil];
	[_x] allowgetin true;
} foreach units _group;

#ifdef DEBUG
	"End of demining" call bis_fnc_log;
#endif