params [
	["_input",[objnull,0],[[]]],
	["_layer","",[""]]
];
_input params [
	["_effect",objnull,[objnull,""]],
	["_var",0]
];

//--- Create sound
if (_effect isequaltype "") then {
	_effect = createSoundSource [_effect,_var,[],0];
	//private _soundEffect = _effect;
	//_effect = createtrigger ["EmptyDetector",_var];
	//_effect settriggerstatements ["true","",""];
	//_effect setsoundeffect ["$NONE$","","",_soundEffect];
	_input set [0,_effect];
};

private _varName = switch (typeof _effect) do {
	case "#particlesource": {"BIS_layer_%1_particles"};
	case "#lightpoint": {"BIS_layer_%1_lights"};
	case "#dynamicsound": {"BIS_layer_%1_sounds"};
	//case "EmptyDetector": {"BIS_layer_%1_sounds"};
};

_varName = format [_varName,_layer];
private _effects = missionnamespace getvariable [_varName,[]];
_effects pushback _input;
missionnamespace setvariable [_varName,_effects];
_effects