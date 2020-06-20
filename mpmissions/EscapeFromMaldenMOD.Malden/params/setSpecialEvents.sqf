if (isServer) then {
	BIS_EfM_events = ["Blackfoot","Pawnee","Pawnee","Paradrop","Orca","Orca","Huron","Huron"];
	_specialEvents = param [0,1,[999]];
	if (_specialEvents == 0) then {missionNamespace setVariable ["BIS_specialEvents",0]};
	if (_specialEvents == 1) then {missionNamespace setVariable ["BIS_specialEvents",1]};
};
