params ["_drone"];

// Enable connections to the activated drone
if (!(isDedicated)) then {player enableUAVConnectability [_drone, false]};

true