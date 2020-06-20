//NNS: draw all triggers on the map

_draw_debug_trigger_handle_tmp = player getVariable ["draw_debug_trigger_handle",objNull];
if (_draw_debug_trigger_handle_tmp isEqualTo objNull) then {
	_draw_debug_trigger_handle = (findDisplay 12 displayCtrl 51) ctrlAddEventHandler ["Draw",{
			{
				_trigger_area = triggerArea _x;
				if ((_trigger_area select 3)) then { //isRectangle
					(_this select 0) drawRectangle [getPos _x, _trigger_area select 0, _trigger_area select 1, _trigger_area select 2, [0,0,1,0.5]];
				} else {
					(_this select 0) drawEllipse [getPos _x, _trigger_area select 0, _trigger_area select 1, _trigger_area select 2, [0,0,1,0.5]];
				};
				
				_trigger_name=str _x; _trigger_text=triggerText _x; if(_trigger_text!="") then {_trigger_name=format["%1 (%2)",_trigger_text,_trigger_name];};
				
				(_this select 0) drawIcon ["\a3\ui_f\data\map\vehicleicons\iconLogic_ca.paa",[0,0,1,0.5],getPos _x,24,24,_trigger_area select 2,_trigger_name,0,0.03,"TahomaB","right"];
			} forEach allMissionObjects "EmptyDetector"; //trigger
	}];

	player setVariable ["draw_debug_trigger_handle",_draw_debug_trigger_handle];
};
