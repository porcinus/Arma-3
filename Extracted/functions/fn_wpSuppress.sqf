private ["_group","_pos","_target","_wp"];
_group = _this param [0,grpnull,[grpnull]];
_pos = _this param [1,[],[[]],3];
_target = _this param [2,objnull,[objnull]];
_wp = [_group,currentwaypoint _group];