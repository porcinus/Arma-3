/*
	Author: reyhard

	Description:

	Plays a video on the screen of old laptop

	Parameter(s):
	_this select 0: OBJECT - The name of object to play video

	Returns:
	---
*/
params["_object"];

// play video on the screen
_object setObjectTexture [0,"\a3\Props_F_Argo\Items\Electronics\data\OldLaptop_Video.ogv"];

// play sound using say3d so we 3d positional audio
// used this to avoid omni sound that default audio playback from video has
_object say3d ["OldLaptop_VideoSound",20,1];

// store latop id in UI namespace
uiNameSpace setVariable ["BIS_Laptop",_object];

// http://killzonekid.com/arma-scripting-tutorials-ogv-to-texture/
// "In order to start playback the same texture has to be loaded into RscPicture control, and not just any RscPicture control, but the one that has autoplay = 1; RscMissionScreen display has such control with idc 1100"
with uiNamespace do
{
	disableSerialization;
	1100 cutRsc ["RscMissionScreen","PLAIN"];

	private _scr = BIS_RscMissionScreen displayCtrl 1100;
	_scr ctrlSetPosition [-10,-10,0,0];
	_scr ctrlSetText "\a3\Props_F_Argo\Items\Electronics\data\OldLaptop_Video.ogv";
	_scr ctrlCommit 0;
	_scr ctrlAddEventHandler ["VideoStopped",
	{
		// restart screen of the laptop
		private _object = uiNameSpace getVariable ["BIS_Laptop",objNull];
		_object setObjectTexture [0,"\A3\Props_F_Argo\Items\Electronics\data\laptop_02_screen_co.paa"];

		// close display
		uiNameSpace setVariable ["BIS_Laptop",nil];
		(uiNamespace getVariable "BIS_RscMissionScreen") closeDisplay 1;
	}];
};
