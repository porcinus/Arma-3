private ["_topic","_actor","_id"];

_actor =	_this param [0,"",[""]];
_id =		_this param [1,-1,[0]];
_topic =	if (!isnil "_topicName") then {_topicName} else {""};
_topic =	_this param [2,_topic,[""]];
_mission =	if (!isnil "_mission") then {_mission} else {""};
_mission =	_this param [3,_mission,[""]];
private _topicID = _this param [4,if (!isnil "_topicID") then {_topicID} else {""},[""]];

_topic = _topicID + _topic + "_" + _actor;
if (_id >= 0) then {_topic = _mission + "_" + _topic + "_" + str _id};
tolower _topic