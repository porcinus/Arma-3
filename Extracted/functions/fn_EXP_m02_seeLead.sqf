// Wait for status to sync
waitUntil {!(isNil "BIS_leadSpotted")};

if (!(BIS_leadSpotted)) then {
	// Wait to be allowed to see the Support Lead
	waitUntil {BIS_leadSpotted || { missionNamespace getVariable ["BIS_spottingLead", false] }};
	
	if (!(BIS_leadSpotted)) then {
		// Wait for player to see Support Lead
		waitUntil {
			BIS_leadSpotted
			||
			{
				player reveal BIS_supportLead;
				cursorTarget == BIS_supportLead
			}
		};
		
		if (!(BIS_leadSpotted)) then {
			// Register that the Support Lead was spotted
			BIS_leadSpotted = true;
			publicVariable "BIS_leadSpotted";
		};
	};
};

true