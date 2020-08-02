// Register that the extraction is inbound
BIS_extractMove = true;

{
	private _heli = _x;
	private _units = units group driver _heli;
	_units = _units + (crew _heli);
	
	// Unhide extract
	{
		_x hideObjectGlobal false;
		_x enableSimulationGlobal true;
	} forEach ([_heli] + _units);
	
	// Fly at reasonable altitude
	_heli flyInHeight 50;
} forEach [BIS_heliExtract, BIS_heliSling, BIS_heliAttack];

// Wait for the slingload heli to start to land
waitUntil {((getPosATL BIS_heliSling) select 2) <= 5 || BIS_missionEnding};

if (!(BIS_missionEnding)) then {
	// Open ramp
	BIS_heliSling animateDoor ["Door_rear_source", 1];
};

true