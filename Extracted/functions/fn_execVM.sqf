params [["_args1", []], "_args2"];

// --- input format: "script" or ["script"]
if (isNil "_args2" && _args1 isEqualType "") exitWith {[] execVM _args1};

// --- input format: [param, "script"]
if (!isNil "_args2" && {_args2 isEqualType ""}) exitWith {_args1 execVM _args2}; 

// --- error and suggest supported format
[_this, "isEqualTypeParams", [nil, ""]] call (missionNamespace getVariable "BIS_fnc_errorParamsType");

scriptNull