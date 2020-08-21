/*
NNS
Not Mario Kart Knockoff
Replace elements of string by others, case sensible
*/

params [
	["_str", ""],
	["_search", ""],
	["_replace", ""]
];

if (typeName _str != "STRING") exitWith {_str}; //str is not a string
if (_str == "" || {_search == ""}) exitWith {_str}; //empty str or search

private _strSearchLength = (count _search); //string and seach lenght
private _strFindPos = 0; //last find position
private _tmpArray = []; //store extracted parts of string

while {_strFindPos != -1} do { //search loop
	_strFindPos = _str find _search; //search
	if (_strFindPos == -1) then {_tmpArray pushBack _str; //seach string no more found
	} else {
		if (_strFindPos != 0) then {_tmpArray pushBack (_str select [0, _strFindPos])}; //add wanted part to array if not empty
		_str = _str select [_strFindPos + _strSearchLength]; //update string to search in
	};
};

_tmpArray joinString _replace; //return new string