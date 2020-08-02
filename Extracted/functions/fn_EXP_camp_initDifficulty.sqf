#include "\a3\missions_f_exp\campaign\commondefines.inc"

// Ensure settings have synchronized
waitUntil {
	BIS_fnc_EXP_camp_initDifficulty_tickets = missionNamespace getVariable ["#xdres", -1];
	BIS_fnc_EXP_camp_initDifficulty_revive = missionNamespace getVariable ["#xdrev", -1];

	{_x < 0} count [BIS_fnc_EXP_camp_initDifficulty_tickets, BIS_fnc_EXP_camp_initDifficulty_revive] == 0
};

// Obsolete variables
BIS_fnc_EXP_camp_initDifficulty_mode = 1;
BIS_fnc_EXP_camp_initDifficulty_difficulty = 0;

// Set up Spectator
if (hasInterface) then
{
	{player setVariable [_x, false]} forEach ["AllowAI", "AllowFreeCamera"];
	player setVariable ["Allow3PPCamera", true];
};

if (isServer) then {
	// Store whether players were warned about exhausted Tickets
	BIS_fnc_EXP_camp_initDifficulty_warned = false;

	[] spawn {
		scriptName "BIS_fnc_EXP_camp_initDifficulty: server control";

		// Ensure mission has started
		waitUntil {missionNamespace getVariable [VAR_SS_STATE, ""] == STATE_STARTED};
		sleep 5;

		// Limited Tickets
		if (
			// Regular difficulty selected
			(BIS_fnc_EXP_camp_initDifficulty_mode == 0 && { BIS_fnc_EXP_camp_initDifficulty_difficulty == 1 })
			||
			// Limited Tickets selected
			(BIS_fnc_EXP_camp_initDifficulty_mode == 1 && { BIS_fnc_EXP_camp_initDifficulty_tickets == 1 })
		) then {
			// Limited Tickets
			// Add maximum Tickets (init value is now available in description.ext)
			BIS_fnc_EXP_camp_initDifficulty_maxTickets = ([getMissionConfigValue "maxRespawnTickets"] param [0, 3, [0]]) max 1;
			[WEST, BIS_fnc_EXP_camp_initDifficulty_maxTickets] call BIS_fnc_respawnTickets;

			private _failed = false;
			while {!(_failed)} do {
				// Wait for Tickets to be exhausted
				waitUntil {(WEST call BIS_fnc_respawnTickets) == 0};

				if ({alive _x && { lifeState _x != "UNCONSCIOUS" }} count allPlayers > 0) then {
					// Warn surviving players that Tickets were exhausted
					BIS_fnc_EXP_camp_initDifficulty_warned = true;
					["APTicketsGone", "BIS_fnc_showNotification"] call BIS_fnc_MP;

					waitUntil {
						// Tickets were added
						(WEST call BIS_fnc_respawnTickets) > 0
						||
						// Or all players are dead
						{alive _x && { lifeState _x != "UNCONSCIOUS" }} count allPlayers == 0
					};

					// Fail the mission if everyone's dead
					if ((WEST call BIS_fnc_respawnTickets) == 0) then {_failed = true};
				} else {
					// Fail the mission
					_failed = true;
				};
			};

			// Determine which ending to use
			private _ending = "APPlayersDead";
			if (count allPlayers == 1) then {_ending = "APPlayersDeadAlone"};

			// Fail the mission
			0 fadeMusic 1;
			[[_ending, false], "BIS_fnc_endMission", true, true] call BIS_fnc_MP;
		};

		if (
			// Veteran difficulty selected
			(BIS_fnc_EXP_camp_initDifficulty_mode == 0 && { BIS_fnc_EXP_camp_initDifficulty_difficulty == 2 })
			||
			// Disabled Tickets selected
			(BIS_fnc_EXP_camp_initDifficulty_mode == 1 && { BIS_fnc_EXP_camp_initDifficulty_tickets == 2 })
		) then {
			// Disabled Tickets
			// Remove all Tickets
			[WEST, -1] call BIS_fnc_respawnTickets;

			// Wait for all players to die
			waitUntil {{alive _x && { lifeState _x != "UNCONSCIOUS" }} count allPlayers == 0};

			// Determine which ending to use
			private _ending = "APPlayersDead";
			if (count allPlayers == 1) then {_ending = "APPlayersDeadAlone"};

			// Fail the mission
			0 fadeMusic 1;
			[[_ending, false], "BIS_fnc_endMission", true, true] call BIS_fnc_MP;
		};
	};
};

if (hasInterface) then {
	if (
		// Regular difficulty selected
		(BIS_fnc_EXP_camp_initDifficulty_mode == 0 && { BIS_fnc_EXP_camp_initDifficulty_difficulty == 1 })
		||
		// Limited Tickets selected
		(BIS_fnc_EXP_camp_initDifficulty_mode == 1 && { BIS_fnc_EXP_camp_initDifficulty_tickets == 1 })
	) then {
		// Display Tickets on the right side of the screen
		[] spawn {
			disableSerialization;
			scriptName "BIS_fnc_EXP_camp_initDifficulty: Tickets display";
			("RscMissionStatus" call BIS_fnc_rscLayer) cutRsc ["RscMPProgress", "PLAIN"];
		};
	};

	// Wait for default Revive state to be applied
	waitUntil {{isNil _x} count ["bis_revive_unconsciousStateMode", "bis_revive_requiredItems"] == 0};

	if (BIS_fnc_EXP_camp_initDifficulty_mode == 0) then {
		// Difficulty Presets
		// Apply new Revive setting
		bis_revive_unconsciousStateMode = BIS_fnc_EXP_camp_initDifficulty_difficulty;
	} else {
		// Individual Settings
		switch (BIS_fnc_EXP_camp_initDifficulty_revive) do {
			// First Aid Kit Required
			case 1: {
				// Require FAK, consume on revive
				bis_revive_requiredItems = 2;
			};

			// Medics Only
			case 2: {
				// Require a Medikit
				bis_revive_requiredItems = 1;
			};

			// Disabled
			case 3: {player call BIS_fnc_disableRevive};
		};
	};
};

true