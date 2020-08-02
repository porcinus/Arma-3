params [
	["_mode","",[""]],
	["_objects",[],[[]]]
];

switch _mode do {
	case "Init": {
	};
	case "Show": {
		if !(isnil "BIS_A1_Flag") then {BIS_A1_Flag setflagtexture "\A3\Data_F\Flags\Flag_FIA_CO.paa";};
	};
	case "Hide": {
	};
};