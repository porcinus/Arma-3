params [
	["_mode","",[""]],
	["_input",[],[[]]]
];
switch _mode do {
	case "init": {
		_input params [
			["_logic",objnull,[objnull]],
			["_isActivated",true,[true]],
			["_isCuratorPlaced",false,[true]]
		];
		_model = _logic getvariable "Model";
		if (_model != "") then {
			_obj = createsimpleobject [_model,getposasl _logic];
			_obj attachto [_logic,[0,0,0]];
			_var = vehiclevarname _logic;
			if (_var != "") then {
				missionnamespace setvariable [_var,_obj,true];
				_obj setvehiclevarname _var;
			};
			_init = _logic getvariable "Init";
			if (_init != "") then {
				this = _obj;
				[] call compile _init;
				this = nil;
			};
			deletevehicle _logic;
		};
	};
	case "attributesChanged3DEN";
	case "registeredToWorld3DEN": {
		_input params [
			["_logic",objnull,[objnull]]
		];
		_model = (_logic get3denattribute "ModuleSimpleObject_F_Model") param [0,""];
		_modelCurrent = _logic getvariable ["BIS_model",""];
		_obj = _logic getvariable ["BIS_object",objnull];
		if (_model != "" && _model != _modelCurrent) then {
			deletevehicle _obj;
			_obj = createsimpleobject [_model,getposasl _logic];
			_logic setvariable ["BIS_object",_obj];
			_logic setvariable ["BIS_model",_model];
		};
		_obj attachto [_logic,[0,0,0]];
	};
	case "unregisteredFromWorld3DEN": {
		_input params [
			["_logic",objnull,[objnull]]
		];
		deletevehicle (_logic getvariable ["BIS_object",objnull]);
	};
	//case "dragged3DEN": {
	//	_input params [
	//		["_logic",objnull,[objnull]]
	//	];
	//};
};