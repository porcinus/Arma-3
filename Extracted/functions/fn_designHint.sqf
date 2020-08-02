if !(cheatsenabled) exitwith {};

params [
	["_text",""]
];

_title = format ["Design Hint #%1",["BIS_DesignHint",1] call bis_fnc_counter];
hint parsetext format ["<t size='1.4' color='#99ffffff'>%2</t><br /><br /><t align='left'>%1</t>",_text,_title];

if !(player diarysubjectexists "design") then {
	player creatediarysubject ["design", "Design Hints"];
};
player createDiaryRecord ["design",[_title,_text]];
setacctime 1;