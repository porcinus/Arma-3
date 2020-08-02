private ["_logic","_function","_params","_activate","_isGlobal","_isDisposable","_isPersistent","_spawn","_time"];

_logic = _this param [0,objnull,[objnull]];
_function = _this param [1,"",[""]];
_params = _this param [2,[],[[]]];
_activate = _this param [3,true,[true]];

_isGlobal = _params param [0,false,[false]];
_isDisposable = _params param [2,false,[false]];
_isPersistent = _params param [3,false,[false]];
_isCuratorPlaced = _params param [4,false,[false]];
_is3DEN = _params param [5,false,[false]];

_logic setvariable ["bis_fnc_moduleInit_status",false];
waituntil {_logic getvariable ["bis_fnc_initModules_activate",true] || isnull _logic};
if (isnull _logic) exitwith {false};

//--- Don't execute persistentely when the module was executed before (to avoid spamming the queue)
if (_isPersistent) then {
	_isPersistent = _isPersistent && (_logic getvariable ["bis_fnc_moduleExecute_first",true]);
	_logic setvariable ["bis_fnc_moduleExecute_first",false];
};

//--- Mark the module as activated for persistent execution
_logic setvariable ["bis_fnc_moduleExecute_activate",true,_activate && _isGlobal && _isPersistent];

//--- Execute the function (only if it's enabled)
_arguments = if (_is3DEN) then {
	["init",[_logic,_activate,_isCuratorPlaced]]
} else {
	[_logic,_logic call bis_fnc_moduleUnits,_activate];
};
_spawn = if (simulationenabled _logic || is3DEN) then {
	if (ismultiplayer && _isGlobal && !is3DEN && time > 0) then {
		//--- Global execution
		[_arguments,_function,-2] spawn BIS_fnc_MP; //--- Not on server
	};
	//--- Server execution
	_arguments spawn (missionnamespace getvariable _function);
} else {
	[] spawn {true};
};

//--- Show an error when the function contains errors
if (isnil "_spawn") then {["Cannot execute module, error found in '%1'",_function] call bis_fnc_error; _spawn = [] spawn {true};};

//--- Dispose
if (_isDisposable) then {
	private ["_logicMain","_modules"];
	_logicMain = missionnamespace getvariable ["bis_functions_mainscope",objnull];
	_modules = (_logicMain getvariable ["bis_fnc_moduleInit_modules",[]]);
	_modules deleteat (_modules find _logic);
	_logicMain setvariable ["bis_fnc_moduleInit_modules",_modules,true];
	//deletevehicle _logic;
};

//--- Wait until the function is done and then mark the module as initialized
_time = diag_ticktime + 1;
waituntil {scriptdone _spawn || diag_ticktime > _time};
//_logic setvariable ["bis_fnc_moduleInit_status",true]; //--- Status is now set in BIS_fnc_moduleExecute
true