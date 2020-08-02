params [["_args1", []], "_args2"];

// --- input format: {code} or [{code}]
if (isNil "_args2" && _args1 isEqualType {}) exitWith {[] call _args1};

// --- input format: [param, {code}]
if (!isNil "_args2" && {_args2 isEqualType {}}) exitWith {_args1 call _args2};

// --- error and suggest supported format
[_this, "isEqualTypeParams", [nil, {}]] call (missionNamespace getVariable "BIS_fnc_errorParamsType");

nil