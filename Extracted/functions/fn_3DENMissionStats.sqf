#include "\a3\3DEN\UI\resincl.inc"
(finddisplay IDD_DISPLAY3DEN) createdisplay "Display3DENMissionStats";

/*
#include "\a3\3DEN\UI\resincl.inc"

"LOL" call bis_Fnc_log;

_export = "";

all3denentities params ["_objects","_groups","_triggers","_logics","_waypoints","_markers","_layers","_comments"];

_export = _export + format ["%1: %2",localize "str_3den_object_textSingular",count _objects] + endl;
_export = _export + format ["  %1: %2",localize "str_team_switch_ai",{!isnull group _x} count _objects] + endl;
_export = _export + format ["  %1: %2",localize "str_dn_vehicle",{_x iskindof "AllVehicles" && isnull group _x} count _objects] + endl;
_export = _export + format ["  %1: %2",localize "str_3den_object_attribute_simpleobject_displayName",{(_x get3denattribute "objectIsSimple") # 0} count _objects] + endl;
_export = _export + format ["%1: %2",localize "str_3den_group_textSingular",count _groups] + endl;
_export = _export + format ["%1: %2",localize "str_3den_trigger_textSingular",count _triggers] + endl;
_export = _export + format ["%1: %2",localize "str_3den_logic_textSingular",count _logics] + endl;
_export = _export + format ["%1: %2",localize "str_3den_waypoint_textSingular",count _waypoints] + endl;
_export = _export + format ["%1: %2",localize "str_3den_marker_textSingular",count _markers] + endl;

uinamespace setvariable ["Display3DENCopy_data",[localize "STR_Brief_Statistics",_export]];
(finddisplay IDD_DISPLAY3DEN) createdisplay "Display3DENCopy";
*/