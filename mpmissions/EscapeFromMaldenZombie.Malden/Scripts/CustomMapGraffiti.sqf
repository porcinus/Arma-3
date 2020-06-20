// NNS : add custom graffiti on the map
disableSerialization;

waitUntil {sleep 0.1; visibleMap}; 

findDisplay 12 displayCtrl 51 ctrlAddEventHandler ["Draw", 
{
	mapScale = (10^(abs log (ctrlMapScale (_this select 0)))) * 0.1;
	
	//[format["_target: %1",_this select 0]] call NNS_fnc_debugOutput; //debug
	_this select 0 drawIcon [
		getMissionPath "img\escape.paa",
		[0,0,0,1],
		[10500,10100,0],
		1728 * mapScale, 648 * mapScale, 0
	];
	
	_this select 0 drawIcon [
		getMissionPath "img\coffee_traces.paa",
		[1,1,1,1],
		[10000,300,0],
		2700 * mapScale, 2700 * mapScale, 90
	];
	
	_this select 0 drawIcon [
		getMissionPath "img\why.paa",
		[0,0,0,1],
		[2400,10900,0],
		768 * mapScale, 768 * mapScale, 0
	];
	
	_this select 0 drawIcon [
		getMissionPath "img\cercle01.paa",
		[0,0,0,1],
		[7500,10600,0],
		525 * mapScale, 525 * mapScale, 0
	];
	
	_this select 0 drawIcon [
		getMissionPath "img\cercle02.paa",
		[0,0,0,1],
		[1500,1400,0],
		675 * mapScale, 675 * mapScale, 0
	];
	
	//black map border
	_this select 0 drawIcon [ //top
		"A3\Data_F\black_sum.paa",
		[0,0,0,1],
		[6400,14800,0],
		10000 * mapScale, 2000 * mapScale, 0
	];
	
	_this select 0 drawIcon [ //right
		"A3\Data_F\black_sum.paa",
		[0,0,0,1],
		[14800,6400,0],
		2000 * mapScale, 10000 * mapScale, 0
	];
	
	_this select 0 drawIcon [ //bottom
		"A3\Data_F\black_sum.paa",
		[0,0,0,1],
		[6400,-2000,0],
		10000 * mapScale, 2000 * mapScale, 0
	];
	
	_this select 0 drawIcon [ //left
		"A3\Data_F\black_sum.paa",
		[0,0,0,1],
		[-2000,6400,0],
		2000 * mapScale, 10000 * mapScale, 0
	];
	
}];
