//#define DEBUG
#define MINDIS	10

params [
	["_unit",objnull,[objnull]]
];

//if (random 1 > 0.25 && !(_unit getvariable ["BIS_forceIncapacitate",false])) exitwith {}; //--- Don't apply for everyone

//--- Register moaning sounds
_speaker = speaker _unit;
_cfg = configfile >> "CfgVehicles" >> typeof _unit >> "SoundInjured";
_index = 0;
{
	_array = getarray _x;
	_identities = _array param [0,[]];
	if ({_x == _speaker} count _identities > 0) exitwith {
		_index = _foreachindex;
	};
} foreach configProperties [_cfg];

_moans = [];
_array = getarray (_cfg select _index);
for "_i" from 2 to 3 do { // 0 - Identity, 1 - Low, 2 - Mid, 3 - Max
	_sounds = _array param [_i,[]];
	if (count _sounds > 0) then {
		_soundData = (selectrandom _sounds) param [0,[]];
		_sound = _soundData param [0,""];
		_volume = 2;//_soundData param [1,""];
		_pitch = _soundData param [2,""];
		_distance = _soundData param [3,""];
		_moans pushback [_sound + ".wss",_unit,false,[0,0,0],_volume,_pitch,_distance * 1.5];
	};
};
_unit setvariable ["BIS_moans",_moans];


//--- Add event handler which will send unit to incapacitaed state when killed by a mine
_unit addeventhandler [
	"handleDamage",
	{
		_unit = _this select 0;
		_part = _this select 1;
		_damage = _this select 2;
		_source = _this select 3;
		_ammo = _this select 4;
		if (_ammo iskindof "MineBase" && _damage > 0.9) then {

			//--- Already incapacitated, nearby explosions won't kill him
			if (lifestate _unit == "incapacitated") exitwith {0.9};

			//--- Terminate when conditions for incapacitation are not suitable
			if (
				//--- Another incapacitated around
				(
					{lifestate _x == "incapacitated"} count (_unit nearEntities ["CAManBase",MINDIS]) > 0
					&&
					!(_unit getvariable ["BIS_forceIncapacitate",false])
				)
				||
				vehicle _unit != _unit
			) exitwith {_damage};

			//--- Incapacitate
			["BIS_incapacitated",1] call bis_fnc_counter;
			_unit setdamage 0.9;
			_unit setUnconscious true;
			_unit disableconversation true;
			_unit setspeaker "novoice";
			_unit disableai "move";
			_unit disableai "target";
			_unit disableai "autotarget";
			[_unit] join grpnull;
			_unit spawn {
				waituntil {vectormagnitude velocity _this < 0.1};
				createvehicle ["Land_ClutterCutter_medium_F",position _this,[],0,"can_collide"];
			};

			#ifdef DEBUG
				[_unit,(_unit nearEntities ["CAManBase",MINDIS]) select {lifestate _x == "incapacitated"}] call bis_fnc_log;
				_marker = createmarker [str _unit,position _unit];
				_marker setmarkershape "ellipse";
				_marker setmarkerbrush "solid";
				_marker setmarkersize [MINDIS,MINDIS];
				_marker setmarkercolor "colororange";
			#endif

			if (isnil {_unit getvariable "BIS_moanHandle"}) then {
				//--- Keep moaning
				_handle = _unit spawn {
					_unit = _this;
					scriptname format ["BIS_orange_fnc_incapacitate: Moaning of %1",_unit];
					_moans = _unit getvariable ["BIS_moans",[]];
					if (count _moans == 0) exitwith {};
					while {alive _unit} do {
						_sound = selectrandom _moans;
						_sound set [3,getposasl _unit]; //--- Update the position (using object directly makes the sound too faint)
						playsound3d _sound;
						sleep (5 + random 5);
					};
				};
				_unit setvariable ["BIS_moanHandle",_handle];

				//--- Record if player killed incapacitated person
				_unit addeventhandler [
					"killed",
					{
						if ((_this select 1) == player) then {
							_counter = ["BIS_incapacitatedKills",1] call bis_fnc_counter;
							if ((_this select 0) == bis_brother) then {
								bis_brotherExecuted = true;
								["Brother_Executed"] spawn bis_fnc_missionConversations;
							} else {
								if (_counter == 1) then {
									["Incapacitated_Executed"] spawn bis_fnc_missionConversations;
								};
							};
							(_this select 0) setvelocity [0,0,0];
						};
					}
				];
			};
			0.9
		} else {
			if (side _source == resistance) then {_damage} else {0.9};
		};
	}
];