private _object = param [0,objnull,[objnull]];
private _owner = param [1,objnull,[objnull]];
if (isnull _object) exitwith {["Object cannot be null"] call bis_fnc_error; false};

//--- Execute only on server
if !(isserver) exitwith {[_object,_owner] remoteexec [_fnc_scriptname,2]; false};

//--- Remove existing event handler
_object removeeventhandler ["fired",_object getvariable ["bis_fnc_setObjectShotParents_fired",-1]];

//--- Terminate the system
if (isnull _owner) exitwith {
	_object setvariable ["bis_fnc_setObjectShotParents_owner",nil];
	_object setvariable ["bis_fnc_setObjectShotParents_fired",nil];
	false
};

//--- Save the owner and re-initiate the event handler
_object setvariable ["bis_fnc_setObjectShotParents_owner",_owner];
_object setvariable [
	"bis_fnc_setObjectShotParents_fired",
	_object addeventhandler [
		"fired",
		{
			_owner = (_this select 0) getvariable ["bis_fnc_setObjectShotParents_owner",objnull];
			if !(isnull _owner) then {(_this select 6) setshotparents [_owner,_owner];};
			KEK = _this select 6;
[(_this select 0),getshotparents (_this select 6)] call bis_fnc_log;
		}
	]
];
true