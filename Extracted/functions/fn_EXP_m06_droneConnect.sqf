private _drone = _this param [0, objNull, [objNull]];

// Handle fixed-wing UAV
private _terminal = objNull;
private _dist = 5;
if (_drone == BIS_terminal1) then {_drone = BIS_UAV1; _terminal = BIS_terminal1; _dist = 2};

if (isServer && { _drone != BIS_keyUGV }) then
{
	// Server control
	_drone spawn
	{
		scriptName format ["BIS_fnc_EXP_m06_droneConnected: server control - %1", _this];

		private _drone = _this;

		waitUntil
		{
			// Drone was destroyed
			!(alive _drone)
			||
			// Drone was activated
			{ _drone getVariable ["BIS_droneActive", false] }
		};

		if (alive _drone) then
		{
			// Allow connection drone
			private _group = createGroup WEST;
			_group setBehaviour "CARELESS";

			// Determine AI
			private _units = [gunner _drone];
			private _driver = driver _drone;
			if (!(isNull _driver)) then {_units = _units + [_driver]};

			// Determine leader
			private _leader = objNull;
			{if (leader _x == _x) exitWith {_leader = _x}} forEach _units;

			// Join to group, select leader
			_units joinSilent _group;
			_group selectLeader _leader;

			// Mark drone as hostile, allow it to attack on its own
			{_x setCaptive false} forEach ([_drone] + _units);
			{_x setBehaviour "CARELESS"; _x doTarget objNull} forEach _units;
			_drone setAutonomous true;
			{_drone reveal _x} forEach allUnits;
			
			// Enable connectivity on all clients
			[_drone, "BIS_fnc_EXP_m06_enableConnect"] call BIS_fnc_MP;
		};
	};
};

if (hasInterface && {alive _drone}) then
{
	// Disable connection
	if (_drone != BIS_UAV1) then {player disableUAVConnectability [_drone, true]};

	// Store arguments for action
	_drone setVariable ["BIS_actionShowArguments", [_drone, _terminal, _dist]];
	if (!isNull _terminal) then {_terminal setVariable ["BIS_actionShowArguments", [_drone, _terminal, _dist]]};

	// Function to check whether player can connect to drone
	BIS_fnc_canConnectToDrone =
	{
		private _drone = _this param [0, objNull, [objNull]];
		private _terminal = _this param [1, objNull, [objNull]];
		private _dist = _this param [2, 9999, [0]];
		private _active = if (_drone != BIS_keyUGV) then {_drone getVariable ["BIS_droneActive", false];} else {missionNamespace getVariable ["BIS_dronesRevealed", false];};

		alive _drone
		&&
		{!_active}
		&&
		{vehicle player == player}
		&&
		{"B_UavTerminal" in (assignedItems player)}
		&&
		{player distance _target <= _dist}
	};

	// Function executed when player connects to drone
	private _fn_onConnected =
	{
		private _params = _target getVariable ['BIS_actionShowArguments', [objNull, objNull, 5.0]];
		private _drone = _params param [0, objNull, [objNull]];
		private _terminal = _params param [1, objNull, [objNull]];
		private _dist = _params param [2, 5.0, [0]];

		private _active = if (_drone != BIS_keyUGV) then {_drone getVariable ["BIS_droneActive", false];} else {missionNamespace getVariable ["BIS_dronesRevealed", false];};

		if (alive _drone && {!_active}) then
		{
			// Player activated the drone
			if (_drone != BIS_keyUGV) then
			{
				// Activate and connect to drone
				_drone setVariable ["BIS_droneActive", true, true];
			};
			
			// Enable connection
			if (_drone != BIS_UAV1) then {player enableUAVConnectability [_drone, false]};
			
			if (_drone == BIS_keyUGV) then {
				// Just play the sounds
				playSound ["ReadoutHideClick2", true];
				[] spawn {scriptName "BIS_fnc_EXP_m06_droneConnect: sound control"; sleep 0.05; playSound ["ReadoutHideClick2", true]};
			} else {
				_drone spawn {
					scriptName format ["BIS_fnc_EXP_m06_droneConnect: auto connect - %1", _this];
					
					// Wait for it to switch sides
					waitUntil {(_this call BIS_fnc_objectSide) == WEST};
					
					if !(isUAVConnected _this) then {
						// Instantly connect terminal
						player connectTerminalToUAV _this;
						
						// Play sounds
						playSound ["ReadoutHideClick2", true];
						[] spawn {scriptName "BIS_fnc_EXP_m06_droneConnect: sound control"; sleep 0.05; playSound ["ReadoutHideClick2", true]};
					};
				};
			};

			if !(missionNamespace getVariable ["BIS_dronesRevealed", false]) then
			{
				// All drones were revealed
				BIS_dronesRevealed = true;
				publicVariable "BIS_dronesRevealed";
			};
		};
	};

	private _iconIdle = "A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_connect_ca.paa";
	private _iconProgress = _iconIdle;
	private _condShow = "(_target getVariable ['BIS_actionShowArguments', [objNull, objNull, 5.0]]) call BIS_fnc_canConnectToDrone";
	private _actionTitle = localize "STR_A3_ApexProtocol_action_UAVControl";
	private _object = if (!isNull _terminal) then {_terminal} else {_drone};

	private _actionID = [_object, _actionTitle, _iconIdle, _iconProgress, _condShow, _condShow, {}, {}, _fn_onConnected, {}, [_drone, _terminal, _dist], 4.0, 1000, false, true] call bis_fnc_holdActionAdd;
};

true