/*
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Checks whether icon texture is defined in CfgVehicleIcons and if so, returns the texture.

	Parameter(s):
		0: STRING - icon texture property as defined in CfgVehicleIcons

	Returns:
		STRING - texture if found, otherwise passed property
*/

private _property = param [0, -1];
if !(_property isEqualType "") exitWith {["Invalid input '%1'", _this] call BIS_fnc_error; ""};
private _texture = configFile >> "CfgVehicleIcons" >> _property;
[_property, getText _texture] select isText _texture 