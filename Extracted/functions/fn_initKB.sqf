#define VIRTUAL_CLASS	"C_man_1"

//--- Create virtual speakers
{
	_speaker = missionnamespace getvariable [_x,objnull];
	if (typeof _speaker in ["",VIRTUAL_CLASS]) then {
		deletevehicle _speaker; //--- Delete the previous speaker to terminate conversations

		_speaker = (creategroup civilian) createunit [VIRTUAL_CLASS,[10000,10000,0],[],0,"none"];
		_speaker hideobject true;
		_speaker allowdamage false;
		_speaker setvehiclevarname _x;
		missionnamespace setvariable [_x,_speaker];
	};
} foreach [
	"BIS_EOD",
	"BIS_Journalist",
	"BIS_Driver",
	"BIS_Editor"
];

//--- Initialize identities
BIS_EOD setidentity "Orange_EOD";
BIS_EOD setvariable ["bis_avatar",gettext (configfile >> "CfgIdentities" >> "Orange_EOD" >> "avatar")];
BIS_EOD setvariable ["bis_nameCall",gettext (configfile >> "CfgIdentities" >> "Orange_EOD" >> "nameCall")];
BIS_EOD setvariable ["bis_nameShort",gettext (configfile >> "CfgIdentities" >> "Orange_EOD" >> "nameShort")];

BIS_Journalist setidentity "Orange_Journalist";
BIS_Journalist setvariable ["bis_avatar",gettext (configfile >> "CfgIdentities" >> "Orange_Journalist" >> "avatar")];
BIS_Journalist setvariable ["bis_nameCall",gettext (configfile >> "CfgIdentities" >> "Orange_Journalist" >> "nameCall")];
BIS_Journalist setvariable ["bis_nameShort",gettext (configfile >> "CfgIdentities" >> "Orange_Journalist" >> "nameShort")];

BIS_Driver setidentity "Orange_Driver";

BIS_Editor setname localize "STR_dn_man";