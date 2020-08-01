/// --- validate input
#include "..\paramsCheck.inc"
#define arr [objNull,0]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_object", "_score"];

if (isServer) then {_object addScore _score};

_score