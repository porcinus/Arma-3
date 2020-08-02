//--- Register RSC layers in the correct order (they are not serialized)
{
	_x cuttext ["","plain"];
} foreach [
	"RscCinemaBorder", 
	"BIS_cameraBlack", 
	"BIS_memoryFragment", 
	"BIS_timeline", 
	"RscPhoneCall", 
	"BIS_zoneRestriction", 
	"BIS_skip", 
	"BIS_fnc_showSubtitle"
];

//--- Turn off lights on barricade vehicles
if (!bis_orange_isHub && bis_missionID > 2) then {
	[] spawn {
		sleep 0.1;
		{
			_x enablesimulation true;
		} foreach bis_barricadeObjects;
		sleep 0.001;
		{
			_x enablesimulation false;
			_x setposworld ((_x getvariable "bis_pos") select 0);
			_x setvectordirandup ((_x getvariable "bis_pos") select 1);
		} foreach bis_barricadeObjects;
	};
};