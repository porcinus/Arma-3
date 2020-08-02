params [
	["_animData","",["",[]]],
	["_person",if (isnil "this") then {objnull} else {this},[objnull]],
	["_disableAttach",false,[false]]
];
_animData params [
	["_anim","",[""]],
	["_animExit","",[""]]
];

_useCollisions = true;

if (_anim != "") then {
	if (isnil "bis_oreokastro") then {bis_oreokastro = (creategroup sidelogic) createunit ["Logic",[4559.894,21404.803,0],[],0,"can_collide"];};
	_vector = [vectordir _person,vectorup _person];
	if !(_disableAttach) then {_person attachto [bis_oreokastro];};
	_person setvectordirandup _vector;
	_person disableai "anim";
	_person disableai "move";
	_person disableai "target";
	_person disableai "autotarget";
	_person enablemimics false;
	_person switchmove _anim;
	_person setvariable ["BIS_playAnim",_anim];
	_person setvariable ["BIS_playAnimExit",_animExit];
	if (isnil {_person getvariable "BIS_playAnim_animDone"}) then {
		_person setvariable [
			"BIS_playAnim_animDone",
			_person addeventhandler [
				"animDone",
				{
					(_this select 0) switchmove ((_this select 0) getvariable ["BIS_playAnim",""])
				}
			]
		];
	};
	if (isnil {_person getvariable "BIS_playAnim_killed"}) then {
		_person setvariable [
			"BIS_playAnim_killed",
			_person addeventhandler ["killed",{["",_this select 0] call bis_orange_fnc_playanim;}]];
	};
	//if (isnil {_person getvariable "BIS_playAnim_hit"}) then {
	//	_person setvariable [
	//		"BIS_playAnim_hit",
	//		_person addeventhandler ["hit",{["",_this select 0] call bis_orange_fnc_playanim;}]
	//	];
	//};
	if (isnil {_person getvariable "BIS_playAnim_handleDamage"}) then {
		_person setvariable [
			"BIS_playAnim_handleDamage",
			_person addeventhandler ["handleDamage",{ if ((_this select 3) == player) then {["",_this select 0] call bis_orange_fnc_playanim; _this select 2} else {0}}]
		];
	};
} else {
	if (isnil {_person getvariable "BIS_playAnim"}) exitwith {}; //--- Not playing anim
	detach _person;
	_person enableai "anim";
	_person enableai "move";
	_person enableai "target";
	_person enableai "autotarget";
	_person enablemimics true;
	_person switchmove (_person getvariable ["BIS_playAnimExit",""]);
	_person removeeventhandler ["animDone",_person getvariable ["BIS_playAnim_animDone",-1]];
	_person removeeventhandler ["killed",_person getvariable ["BIS_playAnim_killed",-1]];
	_person removeeventhandler ["hit",_person getvariable ["BIS_playAnim_hit",-1]];
	_person setvariable ["BIS_playAnim",nil];
	_person setvariable ["BIS_playAnimExit",nil];
	_person setvariable ["BIS_playAnim_animDone",nil];
	_person setvariable ["BIS_playAnim_killed",nil];
};


/*
HubSittingChairB_idle1

HubSittingChairC_idle1

HubSittingChairUA_idle1

HubSittingChairUB_idle1

HubSittingChairUC_idle1

Acts_ShowingTheRightWay_loop
Acts_ShieldFromSun_loop
Acts_WalkingChecking
*/