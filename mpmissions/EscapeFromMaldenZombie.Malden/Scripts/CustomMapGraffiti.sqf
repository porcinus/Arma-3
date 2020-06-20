// NNS : add custom graffiti on the map
disableSerialization;

mapDrawCercles = missionNamespace getVariable ["mapCercles",[]];
if (count mapDrawCercles == 0) then {
	mapDrawCercles = [ //img,sx,sy,rot
	[1 + round (random 1), round (500 + random 150), round (500 + random 150), round (random 360)], //north east base
	[1 + round (random 1), round (600 + random 150), round (600 + random 150), round (random 360)], //south west base
	[1 + round (random 1), round (550 + random 150), round (550 + random 150), round (random 360)], //infected city 1
	[1 + round (random 1), round (550 + random 150), round (550 + random 150), round (random 360)], //infected city 2
	[1 + round (random 1), round (550 + random 150), round (550 + random 150), round (random 360)], //infected city 3
	[1 + round (random 1), round (550 + random 150), round (550 + random 150), round (random 360)], //infected city 4
	[1 + round (random 1), round (550 + random 150), round (550 + random 150), round (random 360)] //infected city 5
	];
	missionNamespace setVariable ["mapCercles",mapDrawCercles];
};

waitUntil {sleep 0.1; visibleMap}; 

findDisplay 12 displayCtrl 51 ctrlAddEventHandler ["Draw", {
	_control = _this select 0;
	_mapScale = (10^(abs log (ctrlMapScale _control))) * 0.1;
	
	_control drawIcon [
		getMissionPath "img\escape.paa",
		[0,0,0,0.7],
		[10500,10100,0],
		1728 * _mapScale, 648 * _mapScale, 0
	];
	
	_control drawIcon [
		getMissionPath "img\coffee_traces.paa",
		[1,1,1,1],
		[10000,300,0],
		2700 * _mapScale, 2700 * _mapScale, 90
	];
	
	_control drawIcon [
		getMissionPath "img\why.paa",
		[0,0,0,0.7],
		[2400,10900,0],
		768 * _mapScale, 768 * _mapScale, 0
	];
	
	_tmp = mapDrawCercles select 0;
	_control drawIcon [
		getMissionPath format["img\cercle0%1.paa",(mapDrawCercles select 0) select 0],
		[0,0,0,0.7],
		[7500,10600,0],
		(_tmp select 1) * _mapScale, (_tmp select 2) * _mapScale, (_tmp select 3)
	];
	
	_tmp = mapDrawCercles select 1;
	_control drawIcon [
		getMissionPath format["img\cercle0%1.paa",(mapDrawCercles select 1) select 0],
		[0,0,0,0.7],
		[1500,1400,0],
		(_tmp select 1) * _mapScale, (_tmp select 2) * _mapScale, (_tmp select 3)
	];
	
	//cercle around highly infected cities
	_highlyInfectedCity = missionNamespace getVariable ["HighInfCity",[]];
	
	for "_i" from 0 to ((count _highlyInfectedCity) - 1) do {
		_tmpPos = getPos (_highlyInfectedCity select _i);
		_tmp = mapDrawCercles select (2 + _i);
		_control drawIcon [
			getMissionPath format["img\cercle0%1.paa",(mapDrawCercles select (2 + _i)) select 0],
			[0.9,0,0,0.5],
			_tmpPos,
			(_tmp select 1) * _mapScale, (_tmp select 2) * _mapScale, (_tmp select 3)
		];
	};
	
	//black map border
	_control drawIcon [ //top
		"A3\Data_F\black_sum.paa",
		[0,0,0,1],
		[6400,14800,0],
		10000 * _mapScale, 2000 * _mapScale, 0
	];
	
	_control drawIcon [ //right
		"A3\Data_F\black_sum.paa",
		[0,0,0,1],
		[14800,6400,0],
		2000 * _mapScale, 10000 * _mapScale, 0
	];
	
	_control drawIcon [ //bottom
		"A3\Data_F\black_sum.paa",
		[0,0,0,1],
		[6400,-2000,0],
		10000 * _mapScale, 2000 * _mapScale, 0
	];
	
	_control drawIcon [ //left
		"A3\Data_F\black_sum.paa",
		[0,0,0,1],
		[-2000,6400,0],
		2000 * _mapScale, 10000 * _mapScale, 0
	];
	
}];
