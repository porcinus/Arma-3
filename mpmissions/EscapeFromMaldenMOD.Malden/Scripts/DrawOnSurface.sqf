/*
NNS
Draw on object surface (locally)


example : _null = [[whiteboard1,whiteboard2],1,5,1000,'r'] execVM "Scripts\DrawOnSurface.sqf";
*/

params [
["_objectList",[]], //object(s) to draw on
["_minDetectDist",0.5], //start distance of virtual line used for object detection
["_maxDetectDist",3], //final distance of virtual line used for object detection
["_drawArrayLimit",100], //draw array "size" limit
["_defaultDrawColor","b"], //lines default color
["_drawDistance",25], //display distance
["_drawCleanDistance",125] //cleaning distance
];

if (count (_objectList) == 0) exitWith {["DrawOnSurface.sqf : Need at least one object to draw on"] call BIS_fnc_NNS_debugOutput;};

//DrawOnObject draw start section
waituntil {!isnull (finddisplay 46)}; //wait until viewpoint initialized

playerObjectDrawOn = _objectList;

playerObjectMinDistDetect = _minDetectDist;
playerObjectMaxDistDetect = _maxDetectDist;
playerObjectDrawDistance = _drawDistance;
playerObjectCleanDrawDistance = _drawCleanDistance;

playerMouseDown=false; //is mouse button 0 pressed
playerMouseDrawFrame=0; //track how many frames drawn
playerDrawLimit=_drawArrayLimit; //draw array elements limit
playerDrawArray=[]; //draw array
playerDrawColorArray=[]; //color array, linked to playerDrawArray
playerDrawColor=_defaultDrawColor; //current point color

playerDrawLastObject=objNull; //last detected object backup
playerDrawLastNearestPos=[0,0,0]; //last detected nearest position backup


 //color to RGBA array
playerColorArray = [
"b", [0,0,0,1], //black
"w", [1,1,1,1], //white
"r", [1,0,0,1], //red
"g", [0,1,0,1], //green
"bl", [0,0,1,1], //blue
"p", [1,0,1,1], //purple
"y", [1,1,0,1]]; //yellow

{ //add action to each playerObjectDrawOn
	_x addAction ["", {} ,cursorTarget, 0, true, true, "", ""]; //here to avoid displaying action when look to object
	_x addAction ["Black Marker", {playerDrawColor="b"} ,cursorTarget, 0, true, true, "", ""];
	_x addAction ["White Marker", {playerDrawColor="w"} ,cursorTarget, 0, true, true, "", ""];
	_x addAction ["Red Marker", {playerDrawColor="r"} ,cursorTarget, 0, true, true, "", ""];
	_x addAction ["Green Marker", {playerDrawColor="g"} ,cursorTarget, 0, true, true, "", ""];
	_x addAction ["Blue Marker", {playerDrawColor="bl"} ,cursorTarget, 0, true, true, "", ""];
	_x addAction ["Purple Marker", {playerDrawColor="p"} ,cursorTarget, 0, true, true, "", ""];
	_x addAction ["Yellow Marker", {playerDrawColor="y"} ,cursorTarget, 0, true, true, "", ""];
	_x addAction ["Clean all drawing", {playerDrawArray=[]; playerDrawColorArray=[];} ,cursorTarget, 0, true, true, "", ""];
} forEach playerObjectDrawOn;

//mouse pressed event handler
(findDisplay 46) displayAddEventHandler ["MouseButtonDown", "if ((_this select 1) == 0 && !playerMouseDown) then {playerMouseDown=true;};"];

//mouse release event handler, add "break" on draw array
(findDisplay 46) displayAddEventHandler ["MouseButtonUp", "if ((_this select 1) == 0) then {playerMouseDown = false; playerDrawArrayInsertBreak = true;};"];

//Draw3D event handler
addMissionEventHandler ["Draw3D",{
	//weapon safety on if looking a drawable object
	if (cursorObject in playerObjectDrawOn && ({(_x distance2d player) < (playerObjectMaxDistDetect + 2)} count playerObjectDrawOn > 0)) then {if (isNil "weaponSafetyOn") then {weaponSafetyOn = player addAction ["", {}, [], 0, false, false, "DefaultAction", ""];};
	} else {if !(isNil "weaponSafetyOn") then {player removeAction weaponSafetyOn; weaponSafetyOn = nil;};};
	
	if ({(_x distance2d player) < (playerObjectMaxDistDetect + 2)} count playerObjectDrawOn > 0) then { //display only if distance < max detection distance +2
		playerDrawRefresh = ceil (diag_fps/30); //used as "tick" to allow draw record, based on FPS
		if (playerMouseDown) then { //mouse button pressed
			playerMouseDrawFrame = playerMouseDrawFrame + 1; //increment frame count
			if (playerMouseDrawFrame == playerDrawRefresh) then { //allow draw when right frame amount is meet
				if !(cursorTarget isEqualTo objNull) then { //looking at a object
					if (cursorTarget in playerObjectDrawOn) then { //object in drawable object list
						_relWeaponProxyPos = player selectionPosition "proxy:\a3\characters_f\proxies\weapon.001"; //recover proxy position of primary weapon
						_relWeaponProxyPos set [2,(_relWeaponProxyPos select 2) + 0.09]; //offset Z position try to get to bore level
						_camPos = AGLtoASL (player modelToWorld (_relWeaponProxyPos)); //world position
						_weaponVectorDir = player weaponDirection currentWeapon player; //weapon direction
						_startPos = [(_camPos select 0) + playerObjectMinDistDetect * (_weaponVectorDir select 0),(_camPos select 1) + playerObjectMinDistDetect * (_weaponVectorDir select 1),(_camPos select 2) + playerObjectMinDistDetect * (_weaponVectorDir select 2)]; //compute start virtual line position
						_endPos = [(_camPos select 0) + playerObjectMaxDistDetect * (_weaponVectorDir select 0),(_camPos select 1) + playerObjectMaxDistDetect * (_weaponVectorDir select 1),(_camPos select 2) + playerObjectMaxDistDetect * (_weaponVectorDir select 2)]; //compute end virtual line position
						_intersectResult = lineIntersectsSurfaces [_startPos,_endPos,player,objNull,true,1]; //detect intersect position
						if (count _intersectResult > 0) then { //ok
							if (count ((_intersectResult select 0) select 0) > 0) then { //2 level array? why BI?
								if (playerDrawLastObject == ((_intersectResult select 0) select 2)) then {
									_nearestPos = ((_intersectResult select 0) select 0); //only record nearest position
									_fakeDist = (abs((playerDrawLastNearestPos select 0) - (_nearestPos select 0)) + abs((playerDrawLastNearestPos select 1) - (_nearestPos select 1)) + abs((playerDrawLastNearestPos select 2) - (_nearestPos select 2))) / 3; //median instead of real distance to limit load
									if (_fakeDist > 0.008) then {
										playerDrawArray pushBack (ASLToAGL _nearestPos); //add position to array
										playerDrawColorArray pushBack playerDrawColor; //add color to array
										playerDrawLastNearestPos = _nearestPos; //backup nearest pos
									};
								} else {playerDrawArrayInsertBreak=true;}; //line break
							};
						} else {playerDrawArrayInsertBreak=true;}; //line break
					} else {playerDrawArrayInsertBreak=true;}; //line break
				};
				playerDrawLastObject = cursorTarget; //backup current object
			};
			if (playerMouseDrawFrame > playerDrawRefresh) then {playerMouseDrawFrame=0;}; //reset frame count
		};
	};
	
	if (playerDrawArrayInsertBreak) then {
		playerDrawArray pushBack [0,0,0];
		playerDrawColorArray pushBack playerDrawColor;
		playerDrawArrayInsertBreak=false;
	};
	
	while {count playerDrawArray > playerDrawLimit} do {playerDrawArray deleteAt 0; playerDrawColorArray deleteAt 0;}; //array elements count over limits, delete first element
	
	//start draw lines
	_lastPos = []; //array element-1 backup
	if ({(_x distance2d player) < playerObjectDrawDistance} count playerObjectDrawOn > 0) then { //display only if distance < 25m
		for "_i" from 1 to (count playerDrawArray) - 1 do { //draw loop
			_lastPos = playerDrawArray select (_i - 1); //get line start position
			_currentPos = playerDrawArray select _i; //get line end position
			_currentColor = playerDrawColorArray select _i; //get line color
			if (count _lastPos > 0 && count _currentPos > 0) then { //line start/end position are set
				if (!(_lastPos isEqualTo [0,0,0]) && !(_currentPos isEqualTo [0,0,0])) then { //is not a line break
					_tmpcolor = playerColorArray select (playerColorArray find _currentColor) + 1; //recover color array
					drawLine3D [_lastPos, _currentPos, _tmpcolor]; //draw line
				};
			};
		};
	};
	
	if ({(_x distance2d player) > playerObjectCleanDrawDistance} count playerObjectDrawOn == (count playerObjectDrawOn)) then { //all objects over 100m distance, clean draw array
		playerDrawArray=[]; //draw array
		playerDrawColorArray=[]; //color array, linked to playerDrawArray
	};
}];
