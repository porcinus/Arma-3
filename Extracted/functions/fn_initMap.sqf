disableserialization;

waituntil {!isnull (finddisplay 12)};
_display = (finddisplay 12);

if (getmissionconfigvalue ["orangeSimpleMap",0] > 0) then {

	//--- Hide textures
	ctrlactivate (_display displayctrl 107);

	//--- Hide top stripe
	{(_display displayctrl _x) ctrlshow false} foreach [2,112,1020,1200,2302];
};

//--- Init map
_ctrlMap = _display displayctrl 51;
_ctrlMap ctrlsetposition [safezoneXAbs,safezoneY,safezoneWAbs,safezoneh];
_ctrlMap ctrlcommit 0;
_ctrlMap ctrladdeventhandler [
	"draw",
	{\
		_ctrlMap = _this select 0;
		_scale = (1 / (ctrlmapscale _ctrlMap max 0.0001));
		{
			_data = +_x;
			_data set [3,(_data select 3) * _scale];
			_data set [4,(_data select 4) * _scale];
			_ctrlMap drawicon _data;
		} foreach bis_orange_draw;
	}\
];

if (isnil "bis_orange_fnc_initMap_handler") then {
	bis_orange_fnc_initMap_handler = addmissioneventhandler ["loaded",{[] spawn bis_orange_fnc_initMap;}];
};