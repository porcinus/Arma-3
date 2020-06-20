/*
NNS
Set AI unit skill based on BIS_AIskill global variable and additionnal modifier
Note: Initial value will be randomized by 10%.

Modifiers:
any string : default.
AimingAccuracy is -20% of new skill.

"limited" :
-25% at any skill.
AimingAccuracy is -30% of new skill.

"specops" :
+25% at 0.25 skill, +10% at 0.75.
AimingAccuracy is -10% of new skill.

"sniper" :
+35% at 0.25 skill, +15% at 0.75.
AimingAccuracy is unchanged.


Example: 
_skill = [aiunit] call BIS_fnc_NNS_AIskill;
_skill = [aiunit,"sniper"] call BIS_fnc_NNS_AIskill;

*/

// Params
params
[
	["_unit",objNull], //unit to set skill to
	["_type","soldier"] //modifier
];

// Check for validity
if (isNull _unit) exitWith {[format["BIS_fnc_NNS_AIskill : Non-existing unit %1 used!",_unit]] call BIS_fnc_NNS_debugOutput;};


_AIskill = missionNamespace getVariable ["BIS_AIskill",0.5]; //recover var, 0.5 if not set
_AInewSkill = _AIskill - (_AIskill * 0.05) + (random (_AIskill * 0.1)); //random skill +-5%
_modifier = 0; //no modifier
_aiming = _AInewSkill * 0.8; //80% of new skill

if (_type == "limited") then {
	_modifier = -(_AIskill * 0.25); //skill-25%
	_aiming = _AInewSkill * 0.7; //70% of new skill
};

if (_type == "specops") then {
	_modifier = linearConversion [0.25, 0.75, _AIskill, 0.25, 0.1, true]; //progressive
_aiming = _AInewSkill * 0.9; //90% of new skill
};

if (_type == "sniper") then {
	_modifier = linearConversion [0.25, 0.75, _AIskill, 0.35, 0.15, true]; //progressive
	_aiming = _AInewSkill + _modifier; //100% of new skill
};

_AInewSkill = _AInewSkill + _modifier; //compute new skill

//[format["BIS_fnc_NNS_AIskill : _AIskill:%1, _modifier:%2, _AInewSkill:%3",_unit]] call BIS_fnc_NNS_debugOutput;

_unit setSkill _AInewSkill; //set general new skill
_unit setSkill ["AimingAccuracy",_aiming]; //set AimingAccuracy skill

//return new skill
_AInewSkill