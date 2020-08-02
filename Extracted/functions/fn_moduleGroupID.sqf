_logic = _this param [0, objNull, [objNull]];
_units = _this param [1, [], [[]]];
_activated = _this param [2,true,[true]];

if (_activated) then {
	_company = _logic getvariable ["company","CompanyAlpha"];
	_platoon = _logic getvariable ["platoon","Platoon1"];
	_squad = _logic getvariable ["squad","Squad1"];
	_custom = _logic getvariable ["custom",""];

	_groups = [];
	while {count _units > 0} do {
		_unit = _units select 0;
		_group = group _unit;
		_groups set [count _groups,_group];
		_units = _units - units _group - [_unit];
	};
	_groupID = if (_custom == "") then {
		[gettext (configfile >> "CfgWorlds" >> "groupNameFormat"),_company,_platoon,_squad]
	} else {
		if (islocalized _custom) then {_custom = localize _custom;};
		[_custom]
	};
	{_x setgroupid _groupID;} foreach _groups;
};