private["_spawnpoint","_activated"];

_spawnpoint = _this param [0,objNull,[objNull]];
_activated  = _this param [2,true,[true]];

_spawnpoint setVariable ["activated",_activated];