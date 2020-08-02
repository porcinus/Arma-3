/*
	Author: 
		Karel Moricky, improved by Killzone_Kid

	Description:
		Measures how much time it takes to execute given expression

	Parameter(s):
		0: STRING - tested expression
		1 (Optional): ANY - Param(s) passed into code (default: [])
		2 (Optional): NUMBER - Number of cycles (default: 10000)
		3 (Optional): DISPLAY - Display in which the message window with results will be opened. Use displayNull to disable the window.

	Returns:
		NUMBER - avarage time spend in code execution [ms]
*/

#define GREEN_TO_RED \
[ \
	"#00FF00", "#12FF00", "#24FF00", "#47FF00", "#58FF00", "#6AFF00", "#7CFF00", \
	"#8DFF00", "#9FFF00", "#B0FF00", "#C2FF00", "#D4FF00", "#E5FF00", "#F7FF00", \
	"#FFF600", "#FFE400", "#FFD300", "#FFC100", "#FFAF00", "#FF9E00", "#FF8C00", \
	"#FF7B00", "#FF6900", "#FF5700", "#FF4600", "#FF3400", "#FF2300", "#FF1100", \
	"#FF0000", "#FF0000", "#FF0000", "#FF0000", "#FF0000", "#FF0000", "#FF0000" \
]

//--- allow function to be spawned
if (canSuspend) then {disableSerialization};

params [
	["_testCode", "", [""]],
	["_params", []],
	["_wantedCycles", 10000, [0]],
	["_display", [] call BIS_fnc_displayMission, [displayNull]]
];

diag_codePerformance [compile _testCode, _params, _wantedCycles] params ["_result", "_actualCycles"];

"----------------------------------" call BIS_fnc_logFormat;
["Test Start. Code: %1", _testCode] call BIS_fnc_logFormat;
["Test Cycles: %1 / %2", _actualCycles, _wantedCycles] call BIS_fnc_logFormat;
["Test End. Result: %1 ms", _result] call BIS_fnc_logFormat;
"----------------------------------" call BIS_fnc_logFormat;

if (!isNull _display) then 
{
	[_result, _actualCycles, _wantedCycles, _testCode, _display] spawn 
	{
		disableSerialization;	
		
		params ["_result", "_actualCycles", "_wantedCycles", "_testCode", "_display"];
		
		//--- trim large code if needed
		private _testCodeTrimmed = _testCode;
		if (count _testCode > 500) then {_testCodeTrimmed = (_testCode select [0, 497]) + "..."};
		
		if (
			[
				composeText 
				[
					parseText format 
					[
						format ["<t color='#99ffffff'>%1</t>",format [localize "str_a3_cfgnotifications_timetrialended_1"]] +
						"<br />" +
						"<t color='%1' font='EtelkaMonospacePro' size='2'>%2 ms</t>" +
						"<br />" +
						"<br />" +
						format ["<t color='#99ffffff'>%1</t>",localize "str_disp_xbox_editor_wizard_unit_count"] +
						"<br />" +
						"%3 / %4" +
						"<br />" +
						"<br />" +
						format ["<t color='#99ffffff'>%1:</t><br />",localize "STR_3DEN_Trigger_AttributeCategory_Expression"],
						GREEN_TO_RED select round linearConversion [0, 1, _result, 0, 34, true],
						_result,
						_actualCycles,
						_wantedCycles
					], 
					parseText "<t font='EtelkaMonospacePro' size='0.8'>", 
					text _testCodeTrimmed, 
					parseText "</t>"
				],
				nil,
				localize "str_ca_copy",
				localize "str_disp_cancel",
				_display
			] 
			call BIS_fnc_guiMessage
		) 
		then 
		{
			// COPY RESULT
			copyToClipboard format 
			[
				"Result:%1%%2 ms%1%1Cycles:%1%3/%4%1%1Code:%1%5", 
				endl, 
				_result, 
				_actualCycles, 
				_wantedCycles, 
				_testCode
			];
		};
	};
};

_result 