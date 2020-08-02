params [
	["_input",objnull,[objnull,[]]],
	["_layer","Shared",[""]]
];

private _objects = if (_input isequaltype []) then {
	if (count _input > 0) then {
		if ((_input select 0) isequaltype objnull) then {

			//--- Use objects directly
			_input
		} else {

			//--- Detect near objects dynamically
			_input params [
				["_inputTypes",[],[[],""]],
				["_inputDistance",7,[0]],
				["_inputPosition",position this,[[]]],
				["_inputUseObjects",false,[false]]
			];
			if (_inputTypes isequaltype "") then {_inputTypes = [_inputTypes];};
			if (_inputUseObjects) then {
				nearestObjects [_inputPosition,_inputTypes,_inputDistance];
			} else {
				nearestTerrainObjects [_inputPosition,_inputTypes,_inputDistance];
			};
		};
	} else {
		[]
	};
} else {
	//--- Single object
	[_input]
};
if (count _objects > 0) then {
	{
		//_x enablesimulation false;
		//_x hideobject true;
		if !(simulationenabled _x) then {_x setvariable ["BIS_defaultSimulation",false];};
		_x setvariable ["BIS_layer",tolower _layer];
		if (_x iskindof "Default") then {
			//missionnamespace getvariable [format ["BIS_%1",_x],getposatl _x];
			_explosivesVar = format ["bis_layer_%1_explosives",_layer];
			_explosives = missionnamespace getvariable [_explosivesVar,[]];
			_explosives pushbackunique _x;
			missionnamespace setvariable [_explosivesVar,_explosives];
		};
	} foreach _objects;

	if (!isnil "this" && {vehiclevarname this != ""}) then {
		_var = vehiclevarname this + "_" + _layer;
		_objLink = (_objects select {typeof _x != ""}) param [0,objnull]; //--- Make sure the linked object is not a plant
		if !(isnull _objLink) then {
			_objLink setvehiclevarname _var;
			missionnamespace setvariable [_var,_objLink];
		};
	};

	_layerVar = format ["BIS_layer_%1",_layer];
	_layerObjects = missionnamespace getvariable [_layerVar,[]];
	_layerObjects append _objects;
	missionnamespace setvariable [_layerVar,_layerObjects];
	_layerObjects
} else {
	[]
};