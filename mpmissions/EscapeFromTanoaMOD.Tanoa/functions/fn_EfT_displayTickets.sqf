// Display remaining respawn tickets after reaching certain limits
// green = '#00cc00';
// orange = '#d96600';
// red = '#e60000';

private ["_text","_goodLuck","_startingTickets","_respawnDisabled"];

_text = "RESPAWN TICKETS REMAINING"; // TODO: Localize
_goodLuck = "GOOD LUCK!"; // TODO: Localize
_respawnDisabled = "RESPAWN DISABLED"; // TODO: Localize
_startingTickets = (west call BIS_fnc_respawnTickets);

sleep 10;

// 100% green
if ((west call BIS_fnc_respawnTickets) > 0) then {
	hintSilent parseText format ["<t align='center' size='1.5' color='#00cc00'>%1</t> <br />%2",west call BIS_fnc_respawnTickets,_text];
} else {
	hintSilent parseText format ["<t align='center' size='1.25' color='#00cc00'>%1</t> <br />%2",_respawnDisabled,_goodLuck];
};

sleep 15;

hintSilent "";

/*
// 80% green
WaitUntil {(west call BIS_fnc_respawnTickets) <= (_startingTickets * 0.8)};
hintSilent parseText format ["<t align='center' size='1.5' color='#00cc00'>%1</t> <br />%2",west call BIS_fnc_respawnTickets,_text];

// 60% orange
WaitUntil {(west call BIS_fnc_respawnTickets) <= (_startingTickets * 0.6)};
hintSilent parseText format ["<t align='center' size='1.5' color='#d96600'>%1</t> <br />%2",west call BIS_fnc_respawnTickets,_text];

// 40% orange
WaitUntil {(west call BIS_fnc_respawnTickets) <= (_startingTickets * 0.4)};
If (west call BIS_fnc_respawnTickets > 10) Then {
hintSilent parseText format ["<t align='center' size='1.5' color='#d96600'>%1</t> <br />%2",west call BIS_fnc_respawnTickets,_text];
};

// 20% red
WaitUntil {((west call BIS_fnc_respawnTickets) <= (_startingTickets * 0.2)) or (west call BIS_fnc_respawnTickets <= 10)};
If (west call BIS_fnc_respawnTickets > 10) Then {
hintSilent parseText format ["<t align='center' size='1.5' color='#e60000'>%1</t> <br />%2",west call BIS_fnc_respawnTickets,_text];
};

// Last 10 + good luck when out of tickets
waitUntil {west call BIS_fnc_respawnTickets <= 10};
hintSilent parseText format ["<t align='center' size='1.5' color='#e60000'>%1</t> <br />%2",west call BIS_fnc_respawnTickets,_text];

waitUntil {west call BIS_fnc_respawnTickets <= 9};
hintSilent parseText format ["<t align='center' size='1.5' color='#e60000'>%1</t> <br />%2",west call BIS_fnc_respawnTickets,_text];

waitUntil {west call BIS_fnc_respawnTickets <= 8};
hintSilent parseText format ["<t align='center' size='1.5' color='#e60000'>%1</t> <br />%2",west call BIS_fnc_respawnTickets,_text];

waitUntil {west call BIS_fnc_respawnTickets <= 7};
hintSilent parseText format ["<t align='center' size='1.5' color='#e60000'>%1</t> <br />%2",west call BIS_fnc_respawnTickets,_text];

waitUntil {west call BIS_fnc_respawnTickets <= 6};
hintSilent parseText format ["<t align='center' size='1.5' color='#e60000'>%1</t> <br />%2",west call BIS_fnc_respawnTickets,_text];

waitUntil {west call BIS_fnc_respawnTickets <= 5};
hintSilent parseText format ["<t align='center' size='1.5' color='#e60000'>%1</t> <br />%2",west call BIS_fnc_respawnTickets,_text];

waitUntil {west call BIS_fnc_respawnTickets <= 4};
hintSilent parseText format ["<t align='center' size='1.5' color='#e60000'>%1</t> <br />%2",west call BIS_fnc_respawnTickets,_text];

waitUntil {west call BIS_fnc_respawnTickets <= 3};
hintSilent parseText format ["<t align='center' size='1.5' color='#e60000'>%1</t> <br />%2",west call BIS_fnc_respawnTickets,_text];

waitUntil {west call BIS_fnc_respawnTickets <= 2};
hintSilent parseText format ["<t align='center' size='1.5' color='#e60000'>%1</t> <br />%2",west call BIS_fnc_respawnTickets,_text];

waitUntil {west call BIS_fnc_respawnTickets <= 1};
hintSilent parseText format ["<t align='center' size='1.5' color='#e60000'>%1</t> <br />%2",west call BIS_fnc_respawnTickets,_text];

waitUntil {west call BIS_fnc_respawnTickets == 0};
hintSilent parseText format ["<t align='center' size='2.0' color='#e60000'>%1</t> <br />%2 <br /><br /> %3",west call BIS_fnc_respawnTickets,_text,_goodLuck];
*/