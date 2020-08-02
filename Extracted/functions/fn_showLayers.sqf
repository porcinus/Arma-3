params [
	["_layers",[],[[]]]
];

//--- Sort layers first (objects which are supposed to be hidden has to be hidden before others in their place are revealed)
bis_orange_layersShow = [];
bis_orange_layersHide = [];
{
	_layerName = _x;
	_xLayers = if ({_x == _layerName} count _layers > 0) then {bis_orange_layersShow} else {bis_orange_layersHide};
	_xLayers pushback tolower _layerName;
} foreach BIS_Orange_layers;

//--- Hide
if (bis_orange_isHub) then {
	//--- Hub - hide layers for later use
	{
		_layerName = _x;
		_layerObjects = missionnamespace getvariable [format ["BIS_layer_%1",_layerName],[]];
		_layerExplosives = missionnamespace getvariable [format ["BIS_layer_%1_explosives",_layerName],[]];
		_layerParticles = missionnamespace getvariable [format ["BIS_layer_%1_particles",_layerName],[]];
		_layerLights = missionnamespace getvariable [format ["BIS_layer_%1_lights",_layerName],[]];
		_layerSounds = missionnamespace getvariable [format ["BIS_layer_%1_sounds",_layerName],[]];
		//_layerSoundObjects = missionnamespace getvariable [format ["BIS_layer_%1_soundObjects",_layerName],[]];
		_layerFunction = missionnamespace getvariable format ["BIS_orange_fnc_initLayer_%1",_layerName];
		{
			_x enablesimulation false;
			_x hideobject true;
			_x allowdamage false;
		} foreach _layerObjects;

		//--- Disable particle and light effects
		{(_x select 0) setdropinterval 0;} foreach _layerParticles;
		{(_x select 0) setlightbrightness 0;} foreach _layerLights;
		{
			_x params ["_sound","_pos"];
			if (isnull _sound) then {_sound = (_pos nearobjects ["#dynamicsound",1]) param [0,objnull]; _x set [0,_sound];}; //--- Sound not serialized, find it again after load
			_sound setposatl (_pos vectoradd [0,0,-100]);
		} foreach _layerSounds;
		//{deletevehicle _x;} foreach _layerSoundObjects;

		//--- Move explosives to the air to hide their icons
		{
			if ((getposatl _x select 2) < 1000) then {_x setposatl ((getposatl _x) vectoradd [0,0,10000]);};
		} foreach _layerExplosives;

		if !(isnil "_layerFunction") then {["Hide",_layerObjects] call _layerFunction;};
	} foreach bis_orange_layersHide;
} else {
	//--- Not hub - delete what's not needed
	{
		_layerName = _x;
		_layerObjects = missionnamespace getvariable [format ["BIS_layer_%1",_layerName],[]];
		{
			_obj = _x;
			{_obj deletevehiclecrew _x;} foreach crew _obj;
			{deletevehicle _x;} foreach (_obj getvariable ["BIS_effects",[]]);
			_x enablesimulation false; //--- Hide and disable map objects, they cannot be deleted
			_x hideobject true;
			deletevehicle _obj;
		} foreach _layerObjects;
	} foreach bis_orange_layersHide;
};

//--- Show
{
	_layerName = _x;
	_layerObjects = missionnamespace getvariable [format ["BIS_layer_%1",_layerName],[]];
	_layerExplosives = missionnamespace getvariable [format ["BIS_layer_%1_explosives",_layerName],[]];
	_layerParticles = missionnamespace getvariable [format ["BIS_layer_%1_particles",_layerName],[]];
	_layerLights = missionnamespace getvariable [format ["BIS_layer_%1_lights",_layerName],[]];
	_layerSounds = missionnamespace getvariable [format ["BIS_layer_%1_sounds",_layerName],[]];
	//_layerSoundObjects = [];
	_layerFunction = missionnamespace getvariable format ["BIS_orange_fnc_initLayer_%1",_layerName];
	{
		_x enablesimulation (_x getvariable ["BIS_defaultSimulation",true]);
		_x hideobject false;
		_x allowdamage true;
		_x setvelocitymodelspace [0,0,0];
	} foreach _layerObjects;

	//--- Enable particle and light effects
	{(_x select 0) setdropinterval (_x select 1);} foreach _layerParticles;
	{(_x select 0) setlightbrightness (_x select 1);} foreach _layerLights;
	{
		_x params ["_sound","_pos"];
		if (isnull _sound) then {_sound = ((_pos vectoradd [0,0,-100]) nearobjects ["#dynamicsound",1]) param [0,objnull]; _x set [0,_sound];}; //--- Sound not serialized, find it again after load
		_sound setposatl _pos;
	} foreach _layerSounds;
	//{_layerSoundObjects pushback createSoundSource [_x select 0,_x select 1,[],0];} foreach _layerSounds;
	//missionnamespace setvariable [format ["BIS_layer_%1_soundObjects",_layerName],_layerSoundObjects];

	//--- Move explosives back to the ground
	{
		if ((getposatl _x select 2) > 1000) then {_x setposatl ((getposatl _x) vectoradd [0,0,-10000]);};
	} foreach _layerExplosives;

	if !(isnil "_layerFunction") then {["Show",_layerObjects] call _layerFunction;};
} foreach bis_orange_layersShow;