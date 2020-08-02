private _unit = param [0, objNull, [objNull]];
private _first = param [1, false, [false]];

// Set up fake target
private _fakeGroup = createGroup WEST;
private _fakeTarget = _fakeGroup createUnit ["Logic", [10,10,10], [], 0, "NONE"];
BIS_sniperTargets = BIS_sniperTargets + [_fakeTarget];

// Crouch
_unit setUnitPos "MIDDLE";

if (_first) then {
	// Select a random player
	private _target = ([] call BIS_fnc_listPlayers) call BIS_fnc_selectRandom;
	
	// Reveal the target to the AI
	_fakeTarget attachTo [_target, [0,0,0]];
	_unit reveal _fakeTarget;
	_unit doTarget _fakeTarget;
	
	sleep 3;
	
	// Fire at target
	_unit fire "Secondary";
	
	// Start other snipers
	private _units = BIS_snipers - [_unit];
	{_x spawn BIS_fnc_EXP_m04_sniper} forEach _units;
};

while {alive _unit} do {
	waitUntil {
		// Unit was killed
		!(alive _unit)
		||
		{
			{
				// Player is alive
				alive _x
				&&
				{
					// Unit knows about player
					private _vehicle = vehicle _x;
					_unit knowsAbout _vehicle >= 1.5
					&&
					// Player is too close
					{ _vehicle distance _unit <= 100 }
				}
			} count ([] call BIS_fnc_listPlayers) == 0
		}
	};
	
	if (alive _unit) then {
		private _delay = (random 15);
		private _players = [] call BIS_fnc_listPlayers;
		private _count = {alive _x && { _unit knowsAbout (vehicle _x) > 0 }} count _players;
		
		// Decrease delay depending on knowledge of targets
		if (_count > 0) then {if ({alive _x && { _unit knowsAbout (vehicle _x) >= 1 }} count _players > 0) then {_delay = random 2} else {_delay = random 7}};
		private _time = time + _delay;
		
		waitUntil {
			// Unit was killed
			!(alive _unit)
			||
			{
				// Delayed
				time >= _time
				||
				{
					{
						// Player is alive
						alive _x
						&&
						{
							// Unit knows about player
							private _vehicle = vehicle _x;
							_unit knowsAbout _vehicle >= 1.5
							&&
							// Player is too close
							{ _vehicle distance _unit <= 100 }
						}
					} count ([] call BIS_fnc_listPlayers) > 0
				}
			}
		};
		
		if (alive _unit) then {
			if (
				{
					// Player is alive
					alive _x
					&&
					{
						// Unit knows about player
						private _vehicle = vehicle _x;
						_unit knowsAbout _vehicle >= 1.5
						&&
						// Player is too close
						{ _vehicle distance _unit <= 100 }
					}
				} count ([] call BIS_fnc_listPlayers) == 0
			) then {
				// Select a random player
				private _target = ([] call BIS_fnc_listPlayers) call BIS_fnc_selectRandom;
				
				// Reveal the target to the AI
				_fakeTarget attachTo [_target, [0,0,0]];
				_unit reveal _fakeTarget;
				_unit doTarget _fakeTarget;
				
				private _time = time + 3;
				
				waitUntil {
					// Unit was killed
					!(alive _unit)
					||
					{
						// Delayed
						time >= _time
						||
						{
							{
								// Player is alive
								alive _x
								&&
								{
									// Unit knows about player
									private _vehicle = vehicle _x;
									_unit knowsAbout _vehicle >= 1.5
									&&
									// Player is too close
									{ _vehicle distance _unit <= 100 }
								}
							} count ([] call BIS_fnc_listPlayers) > 0
						}
					}
				};
				
				if (alive _unit) then {
					if (
						{
							// Player is alive
							alive _x
							&&
							{
								// Unit knows about player
								private _vehicle = vehicle _x;
								_unit knowsAbout _vehicle >= 1.5
								&&
								// Player is too close
								{ _vehicle distance _unit <= 100 }
							}
						} count ([] call BIS_fnc_listPlayers) == 0
					) then {
						// Fire at target
						_unit fire "Secondary";
					};
				};
			};
			
			if (alive _unit) then {
				if (
					{
						// Player is alive
						alive _x
						&&
						{
							// Unit knows about player
							private _vehicle = vehicle _x;
							_unit knowsAbout _vehicle >= 1.5
							&&
							// Player is too close
							{ _vehicle distance _unit <= 100 }
						}
					} count ([] call BIS_fnc_listPlayers) > 0
				) then {
					// Wait to engage priority targets
					_unit doTarget objNull;
					_unit setCombatMode "YELLOW";
					
					waitUntil {
						// Unit was killed
						!(alive _unit)
						||
						{
							// Player is alive
							alive _x
							&&
							{
								// Unit knows about player
								private _vehicle = vehicle _x;
								_unit knowsAbout _vehicle >= 1.5
								&&
								// Player is too close
								{ _vehicle distance _unit <= 100 }
							}
						} count ([] call BIS_fnc_listPlayers) == 0
					};
					
					// Resume fake targets
					if (alive _unit) then {_unit setCombatMode "BLUE"};
				};
			};
		};
	};
};

true