/*
	Author: Karel Moricky

	Description:
	Show attributes window of an entity. When no attributes are available, no window is opened.

	Parameter(s):
		OBJECT, GROUP, ARRAY (waypoint) or STRING - entity

	Returns:
	BOOL - true if the window was opened
*/

//#include "\A3\ui_f_curator\ui\defineResinclDesign.inc"

_entity = [_this] param [0,objnull,[objnull,grpnull,[],""]];
_curator = getAssignedCuratorLogic player;
_isPlayer = false;
_curatorInfoType = switch (typename _entity) do {
	case (typename objnull): {
		_isPlayer = isplayer _entity && isnil {_curator getvariable "BIS_fnc_curatorAttributesPlayer"};
		_infoTypeClass = if (isnull group _entity && side _entity != sidelogic) then {"curatorInfoTypeEmpty"} else {"curatorInfoType"};
		gettext (configfile >> "cfgvehicles" >> typeof _entity >> _infoTypeClass)
	};
	case (typename grpnull): {
		//_isPlayer = {isplayer _x} count units _entity > 0;
		_isPlayer = isplayer (leader _entity);
		gettext (configfile >> "cfgcurator" >> "groupInfoType")
	};
	case (typename []): {
		gettext (configfile >> "cfgcurator" >> "waypointInfoType")
	};
	case (typename ""): {
		gettext (configfile >> "cfgcurator" >> "markerInfoType")
	};
	default {""};
};

//--- Cannot edit players
if (_isPlayer) exitwith {
	[_curator,307] spawn bis_fnc_showCuratorFeedbackMessage;
	false
};

if (isclass (configfile >> _curatorInfoType)) then {

	//--- Load default attributes
	_attributes = [_curator,_entity] call bis_fnc_curatorAttributes;
	if (count _attributes > 0) then {
		BIS_fnc_initCuratorAttributes_target = _entity;
		BIS_fnc_initCuratorAttributes_attributes = _attributes;
		createdialog _curatorInfoType;
		true
	};
} else {
	if (_curatorInfoType != "") then {["Display '%1' not found",_curatorInfoType] call bis_fnc_error;};
	false
};