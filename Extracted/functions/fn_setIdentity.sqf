/*
	Author: 
		Karel Moricky, modified by Killzone_Kid

	Description:
		Sets unit identity globally and persistently
		DO NOT PUT IN UNIT INIT

	Parameter(s):
		0: OBJECT - unit
		1: STRING (Optional) - face from CfgFaces
		2: STRING (Optional) - speaker from CfgVoice
		3: NUMBER (Optional) - speaker pitch (1 is unchanged pitch)
		4: STRING (Optional) - callsign
		5: STRING (Optional) - unit name
		6: STRING (Optional) - glasses ("" to remove glasses, nil to leave unchanged)

	Returns:
		BOOLEAN
		
	Examples: 
		[bob, "Kerry", "Male01ENG", 0.7, "Kerry", "Kerry", "G_Spectacles_Tinted"] call BIS_fnc_setIdentity;
		[bob, nil, nil, 1.6, nil, nil, "G_Shades_Black"] call BIS_fnc_setIdentity;
*/

#define THIS_FUNCTION "BIS_fnc_setIdentity"

params 
[
	["_unit", objNull, [objNull]],
	["_face", "", [""]],
	["_speaker", "", [""]],
	["_pitch", 0, [0]],
	["_nameSound", "", [""]],
	["_name", "", [""]],
	"_glasses",
	"_JIPID"
];

private _fnc_setIdentity =  
{		
	if !(_face isEqualTo "") then { _unit setFace _face };
	if !(_speaker isEqualTo "") then { _unit setSpeaker _speaker };
	if (_pitch > 0) then { _unit setPitch _pitch };
	if !(_nameSound isEqualTo "") then { _unit setNameSound _nameSound };
	if !(_name isEqualTo "") then { _unit setName _name };

	if (local _unit && !isNil "_glasses") then
	{
		if (_glasses isEqualTo "") exitWith { removeGoggles _unit };
		if (_glasses isEqualType "") then { _unit addGoggles _glasses };
	};
};

// JIP queue call for joining player
if (isRemoteExecutedJIP) exitWith 
{ 
	if (isNull _unit) exitWith 
	{ 
		remoteExec ["", _JIPID]; // remove from JIP
	};

	call _fnc_setIdentity;
};

// immediate client exec from server
if (isRemoteExecuted && remoteExecutedOwner isEqualTo 2) exitWith 
{ 
	call _fnc_setIdentity;
};

// force server execution if called from client
if (!isServer) exitWith 
{
	_this remoteExecCall [THIS_FUNCTION, 2];
	true 
};

// SERVER
!isNil
{	
	// abort if no unit
	if (isNull _unit) exitWith 
	{ 
		["Unit cannot be null"] call BIS_fnc_error; 
		nil
	};
		
	// if some values are not supplied, get them from the server unit
	// JIP call should have complete identity (minus glasses)
	if (_face isEqualTo "") then { _face = face _unit };
	if (_speaker isEqualTo "") then { _speaker = speaker _unit };
	if (_pitch <= 0) then { _pitch = pitch _unit };
	if (_nameSound isEqualTo "") then { _nameSound = nameSound _unit };
	if (_name isEqualTo "") then { _name = name _unit };
			
	// exec locally on the server (and SP)
	call _fnc_setIdentity;
	
	// exec on every client via RE and add to JIP queue
	if (isMultiplayer) then
	{	
		private _JIPID = format ["%1_%2", netId _unit, THIS_FUNCTION];
		[_unit, _face, _speaker, _pitch, _nameSound, _name, _glasses, _JIPID] remoteExecCall [THIS_FUNCTION, -2, _JIPID];
	};
};