params [
	["_mode","",[""]]
];
RscPhoneCall_data = [name bis_eod,bis_eod getvariable ["bis_avatar","#(argb,8,8,3)color(1,0,1,1)"],BIS_playTime];
if (missionname != "Orange_Hiker") then {"RscPhoneCall" cutrsc ["RscPhoneCall","plain"];};
[name bis_eod,format ["Placeholder conversation: %1",_mode]] call bis_fnc_showSubtitle;
bis_template = bis_eod;
["template","template"] call BIS_fnc_kbTell;