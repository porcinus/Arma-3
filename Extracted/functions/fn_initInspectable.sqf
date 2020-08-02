/*
	Author: Karel Moricky

	Description:
	Initialize inspectable object.
	Adds "Inspect" action to the object. When player activates it, full-screen detail of the objects is shown.

	Parameter(s):
		0: OBJECT - object on which the action is added
		1:
			STRING - texture
			ARRAY of following items:
				0: STRING - texture
				1 (Optional): NUMBER - index on which the texture will be mapped on the object using setObjectTexture. Use -1 to ignore. Default is 0.
				2 (Optional): NUMBER - aspect ratio. 0.5 means width will be 0.5 of the height. Default is -1, which means texture default.
			BOOL - show the full-screen preview instantly (following params are ignored)
		2: (Optional) STRING - text of the texture, shown after clicking on READ button. Ideally localized.
		3 (Optional): STRING - sound played when enetering full-screen preview. Class from CfgSounds.

	Examples:
		// Initialize
		[this,"#(argb,8,8,3)color(1,0,1,1)","Pink"] call bis_fnc_initInspectable;

		// Show preview instantly
		[myLeaflet,true] call bis_fnc_initLeaflet;

	Returns:
	NOTHING
*/

params [
	["_object",objnull,[objnull]],
	["_textureData","",["",[],true]],
	["_text","",[""]],
	["_sound","",[""]]
];

//--- Inspect directly
if (_textureData isequaltype true) exitwith {
	disableserialization;
	private _data = _object getvariable ["bis_fnc_initInspectable_data",[]];
	missionnamespace setvariable ["RscDisplayRead_data",_data];
	([] call bis_fnc_displayMission) createdisplay "RscDisplayRead";
	[missionnamespace,"objectInspected",[_object] + _data] spawn bis_fnc_callScriptedEventHandler;
};

//--- Add action
_textureData params [
	["_texture","",[""]],
	["_textureIndex",0,[0]],
	["_textureRatio",-1,[0]]
];
if (_textureIndex >= 0) then {_object setobjecttexture [0,_texture];};

_object setvariable ["bis_fnc_initInspectable_data",[_texture,_text,_sound,_textureRatio]];

//--- Add action
if (isnil {_object getvariable "bis_fnc_initInspectable_actionID"}) then {
	private _actionID = [
		//--- 0: Target
		_object,

		//--- 1: Title
		localize "STR_A3_Functions_F_Orange_Examine",

		//--- 2: Idle Icon
		"\a3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_search_ca.paa",

		//--- 3: Progress Icon
		"\a3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_search_ca.paa",

		//--- 4: Condition Show
		"_this distance _target < 3",

		//--- 5: Condition Progress
		nil,

		//--- 6: Code Start
		{},

		//--- 7: Code Progress
		{
			_progressTick = _this select 4;
			if (_progressTick % 2 == 0) exitwith {};
			playsound3d [((getarray (configfile >> "CfgSounds" >> "Orange_Action_Wheel" >> "sound")) param [0,""]) + ".wss",player,false,getposasl player,1,0.9 + 0.2 * _progressTick / 24];
		},

		//--- 8: Code Completed
		{[_this select 0,true] call bis_fnc_initInspectable;},

		//--- 9: Code Interrupted
		{},

		//--- 10: Arguments
		[],

		//--- 11: Duration
		0.5,

		//--- 12: Priority
		nil,

		//--- 13: Remove When Completed
		false
	] call bis_fnc_holdActionAdd;
	_object setvariable ["bis_fnc_initInspectable_actionID",_actionID];
};
