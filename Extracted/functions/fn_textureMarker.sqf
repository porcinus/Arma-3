/*
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Checks whether texture is defined in CfgMarkers and if so, returns the marker texture

	Parameter:
		0: STRING - marker classname as defined in CfgMarkers

	Returns:
		STRING - texture if found, otherwise passed classname
*/

private _class = param [0, -1];
if !(_class isEqualType "") exitWith {["Invalid input '%1'", _this] call BIS_fnc_error; ""};
private _texture = configFile >> "CfgMarkers" >> _class >> "icon";
[getText _texture, _class] select isNull _texture 