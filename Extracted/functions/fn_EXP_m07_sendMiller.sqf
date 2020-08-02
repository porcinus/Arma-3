// Register as moving
BIS_millerMove = true;

// Unhide Miller
BIS_miller setPosASL (BIS_miller getVariable "BIS_alt");
BIS_miller hideObjectGlobal false;
BIS_miller enableSimulationGlobal true;
BIS_miller enableAI "MOVE";

// Activate his IFF
BIS_miller setVariable ["BIS_fnc_EXP_m07_handleIFF_active", true, true];

// Wait for Miller to reach position
waitUntil {BIS_millerDisarming};

// Play conversation
"80_ProtectMiller" spawn BIS_fnc_missionConversations;

// Stop moving on his own
BIS_miller enableMimics false;
{BIS_miller disableAI _x} forEach ["ANIM", "MOVE"];

// Start sprinting
BIS_miller playActionNow "FastF";
waitUntil {animationState BIS_miller == "AmovPercMevaSrasWrflDf"};

// Move to starting position
BIS_miller setPosASL (getPosASL BIS_miller_dest);
BIS_miller setDir (direction BIS_miller_dest);

// Handle Device animations
private _animEH = BIS_miller addEventHandler [
	"AnimStateChanged",
	{
		params ["_unit", "_anim"];
		_anim = toLower _anim;
		
		switch (_anim) do {
			case "acts_millerdisarming_runtodesk": {
				// Move into position
				_unit setPosASL (getPosASL BIS_miller_wp);
				_unit setDir (direction BIS_miller_wp);
			};
			
			case "acts_millerdisarming_deskloop": {
				// Remove event handler
				_unit removeEventHandler ["AnimStateChanged", _unit getVariable "BIS_fnc_EXP_m07_sendMiller_animEH"];
				_unit setVariable ["BIS_fnc_EXP_m07_sendMiller_animEH", nil];
				
				// Enable automatic animations
				_unit enableAI "ANIM";
			};
		};
	}
];

// Store event handler
BIS_miller setVariable ["BIS_fnc_EXP_m07_sendMiller_animEH", _animEH];

private _time = time + 1.1;
private _break = false;
waitUntil {
	if (time >= _time) then {
		// Play animation
		BIS_miller playMoveNow "acts_millerDisarming_deskLoop";
		_break = true;
	};
	
	_break
};

true