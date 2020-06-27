if (isServer) then
{
	_fog = param [0,0,[999]];

	if (_fog == 0) then {0 setFog [0,0,0]; 3600 setFog [0,0,0]};
	if (_fog == 1) then {0 setFog [0.1,0.001,250]; 3600 setFog [0.1,0.001,250]};
	if (_fog == 2) then {0 setFog [0.3,0.001,250]; 3600 setFog [0.3,0.001,250]};
	if (_fog == 3) then {0 setFog [0.5,0.001,250]; 3600 setFog [0.5,0.001,250]};
	if (_fog == 4) then {0 setFog [0.8,0.001,250]; 3600 setFog [0.8,0.001,250]};
};
