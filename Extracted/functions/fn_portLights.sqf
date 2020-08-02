// Campaign common includes
#include "\A3\Missions_F_Exp\Campaign\commonDefines.inc"

// Modes
#define INITIALIZE 		0
#define ON_STATE_CHANGED 	1
#define SET_STATE		2
#define GET_STATE		3
#define GET_ALL_LIGHTS		4

// Light States
#define ON			0
#define OFF			1
#define RED_ON			2
#define RED_OFF			3
#define DEF			ON

// Function wrappers
#define SELF			{ _this call (missionNamespace getVariable ["BIS_fnc_portLights", {"Function BIS_fnc_portLights does not exist" call BIS_fnc_error}]) }

// Misc
#define MIN_DELAY		1.0
#define MAX_DELAY		1.5

// Parameters
params
[
	["_mode", 0, [0]],
	["_params", [], [[]]]
];

// Store sounds
BIS_fnc_portLights_soundsOn = [1,2,3];
BIS_fnc_portLights_soundsOff = [1,2,3];

// Mode
switch (_mode) do
{
	case INITIALIZE :
	{
		if (hasInterface) then
		{
			// Event for state changes
			"BIS_portLightsState" addPublicVariableEventHandler
			{
				[ON_STATE_CHANGED, [missionNamespace getVariable ["BIS_portLightsState", DEF]]] call SELF;
			};

			// Default state
			[ON_STATE_CHANGED, [missionNamespace getVariable ["BIS_portLightsState", DEF]]] call SELF;
		};
	};

	case ON_STATE_CHANGED :
	{
		private _state = _params param [0, DEF, [0]];

		switch (_state) do
		{
			case ON :
			{
				terminate (missionNamespace getVariable ["BIS_portLightsScript", scriptNull]);

				missionNamespace setVariable ["BIS_portLightsScript", [] spawn
				{
					{
						_x setLightBrightness 3.0;
						_x setLightAmbient [1.0, 1.0, 1.0];
						_x setLightColor [1.0, 1.0, 1.0];

						sleep (selectRandom [MIN_DELAY, MAX_DELAY]);
					}
					forEach ([GET_ALL_LIGHTS] call SELF);
				}];
			};

			case OFF :
			{
				terminate (missionNamespace getVariable ["BIS_portLightsScript", scriptNull]);

				missionNamespace setVariable ["BIS_portLightsScript", [] spawn
				{
					{
						_x setLightBrightness 0.0;
						sleep random 0.1;
						_x setLightBrightness 3.0;
						sleep random 0.1;
						_x setLightBrightness 0.0;
						
						// Replenish pool if needed
						if (count BIS_fnc_portLights_soundsOff == 0) then {BIS_fnc_portLights_soundsOff = [1,2,3]};
						
						// Select a random sound
						private _sound = BIS_fnc_portLights_soundsOff call BIS_fnc_selectRandom;
						BIS_fnc_portLights_soundsOff = BIS_fnc_portLights_soundsOff - [_sound];
						_sound = "EXP_m07_lightsOff_0" + (str _sound);
						
						// Play sound
						playSound _sound;

						sleep (selectRandom [MIN_DELAY, MAX_DELAY]);
					}
					forEach ([GET_ALL_LIGHTS] call SELF);
				}];
			};

			case RED_ON :
			{
				terminate (missionNamespace getVariable ["BIS_portLightsScript", scriptNull]);

				missionNamespace setVariable ["BIS_portLightsScript", [] spawn
				{
					// Replenish pool if needed
					if (count BIS_fnc_portLights_soundsOn == 0) then {BIS_fnc_portLights_soundsOn = [1,2,3]};
					
					// Select a random sound
					private _sound = BIS_fnc_portLights_soundsOn call BIS_fnc_selectRandom;
					BIS_fnc_portLights_soundsOn = BIS_fnc_portLights_soundsOn - [_sound];
					_sound = "EXP_m07_lightsOn_0" + (str _sound);
					
					// Play sound
					playSound _sound;
					
					{
						_x setLightBrightness 2.0;
						_x setLightAmbient [1.0, 0.1, 0.1];
						_x setLightColor [1.0, 0.1, 0.1];
					}
					forEach ([GET_ALL_LIGHTS] call SELF);
				}];
			};

			case RED_OFF :
			{
				terminate (missionNamespace getVariable ["BIS_portLightsScript", scriptNull]);

				missionNamespace setVariable ["BIS_portLightsScript", [] spawn
				{
					// Replenish pool if needed
					if (count BIS_fnc_portLights_soundsOff == 0) then {BIS_fnc_portLights_soundsOff = [1,2,3]};
					
					// Select a random sound
					private _sound = BIS_fnc_portLights_soundsOff call BIS_fnc_selectRandom;
					BIS_fnc_portLights_soundsOff = BIS_fnc_portLights_soundsOff - [_sound];
					_sound = "EXP_m07_lightsOff_0" + (str _sound);
					
					// Play sound
					playSound _sound;
					
					{
						_x setLightBrightness 0.0;
					}
					forEach ([GET_ALL_LIGHTS] call SELF);
				}];
			};
		};
	};

	case SET_STATE :
	{
		private _state = _params param [0, DEF, [0]];

		if (_state == missionNamespace getVariable ["BIS_portLightsState", DEF]) exitWith {};

		if (isServer) then
		{
			BIS_portLightsState = _state;
			publicVariable "BIS_portLightsState";
			[ON_STATE_CHANGED, [_state]] call SELF;
		}
		else
		{
			"SetState can only be called on the server" call BIS_fnc_error;
		};
	};

	case GET_STATE :
	{
		missionNamespace getVariable ["BIS_portLightsState", DEF];
	};

	case GET_ALL_LIGHTS :
	{
		[BIS_light_1, BIS_light_2, BIS_light_3, BIS_light_4, BIS_light_5, BIS_light_6];
	};

	default
	{
		["Unknown mode (%1) used in BIS_fnc_portLights", _mode] call BIS_fnc_error;
	};
};