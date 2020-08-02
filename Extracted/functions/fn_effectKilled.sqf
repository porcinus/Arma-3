params["_vehicle","","","_playEffects"];

if (!_playEffects) exitWith {};

if (_vehicle iskindof "car" || {_vehicle iskindof "ship"}) then
{
	[_vehicle] remoteExec ["BIS_fnc_effectKilledSecondaries", 2];
}
else
{
	if (_vehicle iskindof "tank") then
	{
		[_vehicle, round((fuel _vehicle) * (2 + random 2))] remoteExec ["BIS_fnc_effectKilledSecondaries", 2];
	}
	else
	{
		if (_vehicle iskindof "helicopter" || {_vehicle iskindof "plane"}) then
		{
			[_vehicle] remoteExec ["BIS_fnc_effectKilledAirDestruction", 2];
		};
	};
};