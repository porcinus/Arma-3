_logic = _this param [0,objnull,[objnull]];
_units = _this param [1,[],[[]]];
_activated = _this param [2,true,[true]];

if (_activated) then {
	_sentence = _logic getvariable ["Sentence",""];
	_sideID = (_logic getvariable ["side",side group _logic]) call bis_fnc_parsenumber;
	_side = _sideID call bis_fnc_sideType;

	_hq = _side call bis_fnc_moduleHQ;
	if !(isnull _hq) then {
		_hq sideradio _sentence;
	} else {
		[
			"%1 HQ is missing. Register one by inserting '%1' module.",
			_sideID call bis_fnc_sidename,
			gettext (configfile >> "cfgvehicles" >> "ModuleHQ_F" >> "displayname")
		] call bis_fnc_log;
	};
};

true
