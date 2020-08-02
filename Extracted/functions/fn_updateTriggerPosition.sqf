//Parameters
private ["_trigger"];
_trigger = [_this, 0, objNull, [objNull]] call BIS_fnc_param;

//Loop
while { alive player } do
{
	private _pos = position player;

	if (leader group player == BIS_leadPlayer && {isNil {BIS_movingToMaxwell}}) then
	{
		_pos = position BIS_leadPlayer;
	};

	_trigger setPos _pos;

	sleep 0.1;
};