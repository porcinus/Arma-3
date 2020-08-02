params [
	["_mode","",[""]],
	["_objects",[],[[]]]
];

switch _mode do {
	case "Init": {
	};
	case "Show": {
		(missionnamespace getvariable ["BIS_A1_Flag",objnull]) setflagtexture "\A3\Data_F\Flags\Flag_AAF_CO.paa";
	};
	case "Hide": {
	};
};