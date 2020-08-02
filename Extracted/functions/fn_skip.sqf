//#define TIME_SKIP	1.4 // Apex
#define TIME_SKIP	0.5

params [
	["_skipNow",false,[false]]
];
if (_skipNow) exitwith {
	bis_cameraSkipTimer = -999;
	playSound ["click", true];

	bis_orange_timelineDone = true;
	bis_orange_cameraDone = true;
	bis_orange_cameraDoneTime = time;

	"BIS_cameraBlack" cuttext ["","black in",2];
	"BIS_skip" cuttext ["","plain"];
	"RscPhoneCall" cuttext ["","plain"];
	if (!isnil "bis_orange_outro") then {"BIS_skip" cuttext ["","black in",999];};

	//--- Interrupt conversation
	//bis_eod call bis_fnc_kbSkip; //--- Skip the current conversation
	true call bis_orange_fnc_kbTell;
	//[] call bis_orange_fnc_initKB; //--- Reset speakers to interrupt the current sentence
	{deletevehicle _x;} foreach ([0,0,0] nearObjects ["#soundonvehicle",10]); //--- Delete playSounds
	"" call bis_fnc_showSubtitle; //--- Hide subtitles
	1 fademusic 0;
	1 fadesound 1;
};

disableserialization;
if (isnil {(finddisplay 46) getvariable "BIS_skipKeyDown"}) then {
	bis_cameraSkipTimer = 0;
	{
		_x setvariable [
			"BIS_skipKeyDown",
			_x displayaddeventhandler [
				"keydown",
				{

					//--- Skipping disabled
					if !(isnil "BIS_disableSkip") exitwith {false};

					//--- Allowed keys
					_key = _this select 1;
					if (_key in (actionkeys "personView" + actionkeys "ingamePause")) exitwith {false};

					//--- Cutscene terminated, remove the handler
					if (savingEnabled) exitwith {
						(_this select 0) displayremoveeventhandler ["keydown",(_this select 0) getvariable ["BIS_skipKeyDown",-1]];
						(_this select 0) setvariable ["BIS_skipKeyDown",nil];
						false;
					};

					//--- Show controls hint
					if (bis_cameraSkipTimer == 0) then {
						"BIS_skip" cuttext [ 
							format [ 
								"<t size='1.25'>%2 <t color = '%1'>%3</t> %4</t>", 
								(["GUI", "BCG_RGB"] call BIS_fnc_displayColorGet) call BIS_fnc_colorRGBtoHTML, 
								toupper localize "STR_A3_ApexProtocol_notification_Skip0", 
								toupper localize "STR_A3_ApexProtocol_notification_Skip1", 
								toupper localize "STR_A3_ApexProtocol_notification_Skip2" 
							], 
							"plain down", 
							1, 
							false, 
							true 
						];
					};

					//--- Action key pressed, skip
					if (_key in actionkeys "action") then {

						bis_cameraSkipTimer = (bis_cameraSkipTimer max 0) + 1 / diag_fps;
						if (bis_cameraSkipTimer > TIME_SKIP) then {
							true call bis_orange_fnc_skip;
						};
					} else {
						bis_cameraSkipTimer = 0;
					};
					((_this select 1) != 1)
				}
			]
		];
	} foreach [
		finddisplay 46,
		uinamespace getvariable ["RscDisplayOrangeChoice",displaynull]
	];
};