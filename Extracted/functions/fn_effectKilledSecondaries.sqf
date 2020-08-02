//small secondary fuel explosions
if (isServer) then
{
	_this spawn
	{
		scriptName "fn_effectKilledSecondaries_mainLoop";

		params["_vehicle",["_int",1,[123]],["_lifecheck",true,[true]]];

		if (_int < 1) exitWith {};

		for "_i" from 1 to _int do
		{
			sleep ((random 45) + 1);

			if ((_lifecheck && {alive _vehicle}) || {isnull _vehicle || {!simulationenabled _vehicle || {(getposASL _vehicle) select 2 < 0}}}) exitwith {};

			createVehicle ["SmallSecondary", _vehicle modelToWorld (_vehicle selectionposition "destructionEffect2"), [], 0, "CAN_COLLIDE"];
		};
	};
};