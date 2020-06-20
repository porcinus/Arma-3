/*
NNS : add arrow on unit head, broken when enter vehicle.
Current version should be stable.
Used for debug purpuse.

example : {[_x,'green',true] execVM 'scripts\AttachArrow.sqf';} forEach (units group player);

color : blue, yellow, pink, red, cyan, green
if _persistant is true, arrow will be moved back to new unit when respawn.

*/

params
[
	["_target",objNull],
	["_color","red"],
	["_persistant",false]
];


_oldhandle = _target getVariable ['debug_arrow_handle',-1]; //try to recover old handle

//Cleanup before start
if(!_persistant) then {
	if(_oldhandle!=-1) then {_target removeMPEventHandler ["MPKilled", _oldhandle]; 
	}else{_target removeAllMPEventHandlers "MPKilled";};
}else{
	if(_oldhandle!=-1) then {_target removeMPEventHandler ["MPRespawn", _oldhandle]; 
	}else{_target removeAllMPEventHandlers "MPRespawn";};
};

_attached = attachedObjects _target;
{deleteVehicle _x;} forEach (_attached);

_arrow = objNull;
if(_color == "blue") then {_arrow = 'Sign_Arrow_Large_Blue_F' createVehicle [0,0,0];};
if(_color == "yellow") then {_arrow = 'Sign_Arrow_Large_Yellow_F' createVehicle [0,0,0];};
if(_color == "pink") then {_arrow = 'Sign_Arrow_Large_Pink_F' createVehicle [0,0,0];};
if(_color == "red") then {_arrow = 'Sign_Arrow_Large_F' createVehicle [0,0,0];};
if(_color == "cyan") then {_arrow = 'Sign_Arrow_Large_Cyan_F' createVehicle [0,0,0];};
if(_color == "green") then {_arrow = 'Sign_Arrow_Large_Green_F' createVehicle [0,0,0];};

if (_arrow isEqualTo objNull) exitWith {["Failed to create Arrow, color problem?"] call NNS_fnc_debugOutput;};

_arrow attachTo [_target, [0,0,1.2], 'Head'];

if (_persistant) then {
	_handle = _target addMPEventHandler ["MPRespawn", {
		params ["_unit", "_corpse"];
		_arrowtypes = ['Sign_Arrow_Large_Blue_F','Sign_Arrow_Large_Yellow_F','Sign_Arrow_Large_Pink_F','Sign_Arrow_Large_F','Sign_Arrow_Large_Cyan_F','Sign_Arrow_Large_Green_F']; //list to check if arrow
		_attached = attachedObjects _corpse; //recover attached object from corpse
		{if !(_x isEqualTo objNull) then {if ((typeOf _x) in _arrowtypes) then {_x attachTo [_unit, [0,0,1.2], 'Head'];};};} forEach _attached; //reattach arrow to head
	}];
	_target setVariable ['debug_arrow_handle',_handle]; //set new handle
	_handle;
} else {
	_handle = _target addMPEventHandler ["MPKilled", {
		params ["_unit"];
		_arrowtypes = ['Sign_Arrow_Large_Blue_F','Sign_Arrow_Large_Yellow_F','Sign_Arrow_Large_Pink_F','Sign_Arrow_Large_F','Sign_Arrow_Large_Cyan_F','Sign_Arrow_Large_Green_F']; //list to check if arrow
		_attached = attachedObjects _unit; //recover attached object from dead unit
		{if !(_x isEqualTo objNull) then {if (typeOf _x in _arrowtypes) then {deleteVehicle _x;};};} forEach _attached; //remove arrow from dead body
		_unit removeMPEventHandler ["MPKilled", _thisEventhandler]; //remove mp handle
	}];
	_target setVariable ['debug_arrow_handle',_handle]; //set new handle
	_handle;
};
