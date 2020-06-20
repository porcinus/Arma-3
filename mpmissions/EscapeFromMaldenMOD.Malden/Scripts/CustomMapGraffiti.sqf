// NNS : add custom graffiti on the map

waitUntil {visibleMap}; 

findDisplay 12 displayCtrl 51 ctrlAddEventHandler ["Draw", 
{
	//[format["_target: %1",_this select 0]] call BIS_fnc_NNS_debugOutput; //debug
	_this select 0 drawIcon 
	[
		getMissionPath "img\escape.paa",
		[0,0,0,1],
		[10500,10100,0],
		(1152 * 0.15) * 10^(abs log (ctrlMapScale (_this select 0))),
		(432 * 0.15) * 10^(abs log (ctrlMapScale (_this select 0))),
		0
	];
	
	_this select 0 drawIcon 
	[
		getMissionPath "img\coffee_traces.paa",
		[1,1,1,1],
		[10000,300,0],
		(1800 * 0.15) * 10^(abs log (ctrlMapScale (_this select 0))),
		(1800 * 0.15) * 10^(abs log (ctrlMapScale (_this select 0))),
		90
	];
	
	_this select 0 drawIcon 
	[
		getMissionPath "img\why.paa",
		[0,0,0,1],
		[2400,10900,0],
		(512 * 0.15) * 10^(abs log (ctrlMapScale (_this select 0))),
		(512 * 0.15) * 10^(abs log (ctrlMapScale (_this select 0))),
		0
	];
	
}];
