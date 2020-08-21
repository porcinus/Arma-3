/*
NNS
Not Mario Kart Knockoff
Collect value of wanted variable for a specific object array and return the highest number counts (its basically to collect votes).
*/

params [
	["_varToCheck", ""], //variable to check
	["_objectsArray", []], //objects array
	["_indexCount", 10], //maximum amount of different votes possible
	["_resetIndex", 0] //set back _varToCheck value on object once variable checked
];

if (_varToCheck == "") exitWith {["MKK_fnc_votes : _varToCheck not set"] call NNS_fnc_debugOutput};
if (count _objectsArray == 0) exitWith {["MKK_fnc_votes : _objectsArray need to contain at least a element"] call NNS_fnc_debugOutput};

private _votesArr = []; //collected votes array init

for "_i" from 0 to (_indexCount - 1) do {_votesArr pushBack [0, _i]}; //fill votes array with 0

{ //objects loop
	_tmpVote = _x getVariable [_varToCheck, -1]; //get var from object
	_x setVariable [_varToCheck, _resetIndex, true]; //set object default var
	if (!(_tmpVote == -1) && {_tmpVote < _indexCount}) then { //valid vote
		_tmpArr = _votesArr select _tmpVote; //recover right array element
		_tmpArr set [0, (_tmpArr select 0) + 1]; //update vote count
		_votesArr set [_tmpVote, _tmpArr]; //update vote array
	};
} forEach _objectsArray;

_votesArr sort false; //highest vote counts first

private _highestVotes = (_votesArr select 0) select 0; //highest vote count
private _highestVotesIndex = [(_votesArr select 0) select 1]; //vote index array, used for multiple mode with same amount of votes
for "_i" from 1 to count (_votesArr) - 1 do { //vote array loop
	_tmpVotes = (_votesArr select _i) select 0; //votes for current element
	if (_tmpVotes == _highestVotes) then { //current element votes equal to highest votes
		_highestVotesIndex pushBack ((_votesArr select _i) select 1); //add index to array
	} else {_i = 9999}; //else overflow _i to exit loop
};

[format["MKK_fnc_votes : highest vote count for '%1' var: %2", _varToCheck, _highestVotesIndex]] call NNS_fnc_debugOutput;

selectRandom _highestVotesIndex; //return random highest index