/*
	Author: 
		Killzone_Kid

	Description:
		Returns the current size of map grid square

	Parameter(s):
		0 (Optional): CONTROL - Map control. Default: main mission map control

	Returns:
		NUMBER - the current size of the map grid or -1 if cannot find
*/

disableSerialization;

params [["_ctrl", findDisplay 12 displayCtrl 51]];
private _currentScale = ctrlMapScale _ctrl;

// cache (makes access 2-3 times faster)
private _mapZooms = _ctrl getVariable "BIS_mapZooms";
if (isNil "_mapZooms") then 
{
	_mapZooms = "true" configClasses (configFile >> "CfgWorlds" >> worldName >> "Grid") apply { [getNumber (_x >> "zoomMax"), getNumber (_x >> "stepX")] };
	_ctrl setVariable ["BIS_mapZooms", _mapZooms]; 
};

{ if (_currentScale <= _x # 0) exitWith { _x # 1 }; -1 } forEach _mapZooms;