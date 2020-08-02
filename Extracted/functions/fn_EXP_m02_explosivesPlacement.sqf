//check if player just planted charge at wrong location
BIS_planGiven = false;
BIS_convoySpotted = false;
BIS_dialogueTriggered = false;

waitUntil {sleep 1;BIS_planGiven};
debugLog "Plan activated";
BIS_wrongPlacement = false;

BIS_explosiveTypes = [
	"DemoCharge_Remote_Mag",
	"ClaymoreDirectionalMine_Remote_Mag",
	"SatchelCharge_Remote_Mag",
	"APERSBoundingMine_Range_Mag",
	"APERSMine_Range_Mag"
];

player addEventHandler ["fired", {
	_mag = _this select 5;
	debugLog _mag;
	if ({_mag == _x} count BIS_explosiveTypes > 0) then {
		debugLog "charge planted";
		if ({player == _x} count (list BIS_wrongExplosives) > 0) then {
			BIS_wrongPlacement = true;
			publicVariable "BIS_wrongPlacement";
			debugLog "Charge planted inside trigger";
		};
	};
}];

waitUntil {sleep 1; BIS_wrongPlacement || BIS_convoySpotted}; //wait for wrong explosive or new phase of the game - this has to be PBd
player removeAllEventHandlers "Fired";
debugLog "Removing eventHandlers";
//execute sentence
if (!BIS_convoySpotted && !BIS_dialogueTriggered) then {
	debugLog "Wrong placement dialogue";
	["x15_Ambush_Spatne"] spawn BIS_fnc_missionConversations;
	BIS_dialogueTriggered = true;
	publicVariable "BIS_dialogueTriggered";
};