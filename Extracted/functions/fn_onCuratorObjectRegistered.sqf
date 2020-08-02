_curator = _this param [0,objnull,[objnull]];
_code = _this param [1,true,[{},true]];

if (typename _code == typename {}) then {
	_curator setvariable ["bis_fnc_curatorSystem_objectRegistered",_code,true];
} else {
	_code = _curator getvariable ["bis_fnc_curatorSystem_objectRegistered",{}];
};

_code