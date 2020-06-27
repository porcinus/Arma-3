if (isServer) then
{
	_quake = param [0,1,[999]];

	if (_quake == 0) then {};
	if (_quake == 1) then {_null = [] execVM "Scripts\Earthquake.sqf"};

};
