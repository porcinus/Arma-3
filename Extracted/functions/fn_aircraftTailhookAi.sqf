params["_params","_isLanding"];

if (_isLanding) then
{
	//handle automated tailhook operations (for AI and player's autopilot)
	//["[ ] Tailhook 'landing' eh - this: %1",_this] call bis_fnc_logFormat;

	_params params[["_plane", objNull],"",["_needsHook",false]];

	if (isNull _plane || {!alive _plane}) exitWith {};

	private _cfg = configFile >> "CfgVehicles" >> typeOf _plane;
	private _haveHook = (_cfg >> "tailHook") call bis_fnc_getCfgDataBool;

	if (!_haveHook || !_needsHook) exitWith {};

	if (_plane animationPhase "tailhook" > 0.1) then
	{
		_plane animate ["tailhook",0];
		_plane animate ["tailhook_door_l",0];
		_plane animate ["tailhook_door_r",0];
		_plane say "Plane_Fighter_01_tailhook_down_sound";
		_plane say3D "Plane_Fighter_01_tailhook_down_sound";
	};
	_plane setUserMFDvalue [0,1];

	[_plane] spawn bis_fnc_aircraftTailhook;
}
else
{
	//handle automated tailhook operations (for AI and player's autopilot)
	//["[ ] Tailhook 'landingcanceled' eh - this: %1",_this] call bis_fnc_logFormat;

	private _plane = _params param [0, objNull];

	if (isNull _plane || {!alive _plane}) exitWith {};

	private _cfg = configFile >> "CfgVehicles" >> typeOf _plane;
	private _haveHook = (_cfg >> "tailHook") call bis_fnc_getCfgDataBool;

	if (!_haveHook) exitWith {};

	if (_plane animationPhase "tailhook" < 0.1) then
	{
		_plane animate ["tailhook",1];
		_plane animate ["tailhook_door_l",1];
		_plane animate ["tailhook_door_r",1];
		_plane say "Plane_Fighter_01_tailhook_up_sound";
		_plane say3D "Plane_Fighter_01_tailhook_up_sound";
	};
	_plane setUserMFDvalue [0,0];
};