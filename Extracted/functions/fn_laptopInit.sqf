/*
	Author: reyhard

	Description:

	Doing some secret magic

	Parameter(s):
	_this select 0: OBJECT - The name of object to add action

	Returns:
	---
*/
params["_object"];

// add action only if mission date matches 22 June of 2001
if((date select [0,3]) isEqualTo [2001,6,22])then
{
	[
		//--- 0: Target
		_object,

		//--- 1: Title
		"Get Back to Main Menu", //--- ToDo: Localize

		//--- 2: Idle Icon
		"\a3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_hack_ca.paa",

		//--- 3: Progress Icon
		"\a3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_hack_ca.paa",

		//--- 4: Condition Show
		// player is less than 3 meteres from laptop and is facing it from the forward arc
		"_this distance _target < 3 && abs((_target getRelDir _this) - 180) < 50",

		//--- 5: Condition Progress
		nil,

		//--- 6: Code Start
		{},

		//--- 7: Code Progress
		{},

		//--- 8: Code Completed
		{_this remoteExec ["BIS_fnc_laptopPlayVideo",0];},

		//--- 9: Code Interrupted
		{},

		//--- 10: Arguments
		[],

		//--- 11: Duration
		1.5,

		//--- 12: Priority
		15,

		//--- 13: Remove When Completed
		true
	] call bis_fnc_holdActionAdd;
};
