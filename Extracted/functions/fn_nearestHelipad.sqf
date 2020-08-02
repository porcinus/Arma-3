private ["_pos","_radius","_selectRandom","_types","_pos","_nearLocations","_posLocation","_nearObjects"];

_pos =		_this param [0,position vehicle player];
_radius =	_this param [1,999999,[0]];
_selectRandom =	_this param [2,false,[false]];
_types =	_this param [3,["Heliport"],[[]]];

//--- Find all helipads around
_pos = _pos call bis_fnc_position;
_nearLocations = nearestLocations [_pos,_types,_radius];

if (count _nearLocations > 0) then {
	_location = if (_selectRandom) then {

		//--- Select random helipad
		_nearLocations call bis_fnc_selectrandom;
	} else {

		//--- Select nearest helipad
		[_nearLocations,_pos] call bis_fnc_nearestPosition;
	};
	_posLocation = position _location;

	//--- Find helipad object
	_nearObjects = _posLocation nearobjects ["RooftopLanding_Base_H",500];
	if (count _nearObjects > 0) then {
		[(_nearObjects select 0) modeltoworld [0,0,1],(_nearObjects select 0),_location];
	} else {
		[_posLocation,objnull,_location]
	};
	
} else {

	//--- No locations found
	[[0,0,0],objnull,locationnull]
};