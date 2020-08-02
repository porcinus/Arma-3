
//--- Basic information
_map = BIS_RscRespawnControlsMap_map;
_mapInfo = _this select 0;
_iconInfo = _this select 1;
_focus = _this select 2;
_cursor = _this select 3;

//map info
//TODO!

//icon info
_pos = _iconInfo select 0;
_name = _iconInfo select 1;
_icon = _iconInfo select 2;
_showName = _iconInfo select 3;
_enemyState = _iconInfo select 4;
_aliveState = _iconInfo select 5;
_selected = _iconInfo select 6;

//--- Basic defines
_colorSelected = [1,0.2,0.2,1];
_iconBackground = if ((!_cursor) || {!_aliveState}) then {"\a3\ui_f\data\map\respawn\respawn_background_ca.paa"} else {"\a3\ui_f\data\map\respawn\respawn_backgroundHover_ca.paa"};
_iconColor = if (_aliveState) then {BIS_RscRespawnControls_iconColor} else {[BIS_RscRespawnControls_iconColor select 0,BIS_RscRespawnControls_iconColor select 1,BIS_RscRespawnControls_iconColor select 2,0.6]};
_unitColor = if (_aliveState) then {[1,1,1,1]} else {[1,1,1,0.6]};

//--- Icon drawing
_map drawIcon [		//background
	_iconBackground,
	_iconColor,
	_pos,
	36,
	36,
	0,
	"",
	false
];

_map drawIcon [		//unit icon
	_icon,
	_unitColor,
	_pos,
	20,
	20,
	0,
	"",
	false
];

if (_showName) then {
	_map drawIcon [		//text (with invisible texture)
		"#(argb,8,8,3)color(0,0,0,0)",
		[1,1,1,1],
		_pos,
		48,
		48,
		0,
		_name,	//text
		2,	//shadow
		0.07,	//text size
		'RobotoCondensed',	//font, TahomaB
		'right'	//align
	];
};

if !(_aliveState) then {	//dead unit as respawn point
	_iconDead = "\a3\ui_f\data\map\respawn\respawn_dead_ca.paa";
	_iconDisabled = "\a3\ui_f\data\map\respawn\respawn_disabled_ca.paa";
	
	_map drawIcon [
		_iconDisabled,
		[1,1,1,1],
		_pos,
		36,
		36,
		0,
		"",
		false
	];
	
	_map drawIcon [
		_iconDead,
		[1,1,1,1],
		_pos,
		36,
		36,
		0,
		"",
		false
	];
	
} else {	//active respawn point, check the enemies around
	if (_enemyState < 100) then {
		_iconEnemy = "\a3\ui_f\data\map\respawn\respawn_enemy_ca.paa";
		
		_map drawIcon [
			_iconEnemy,
			[1,1,1,1],
			_pos,
			36,
			36,
			0,
			"",
			false
		];
	};
};

if (_selected) then {	//icon selected
	_iconSelected = "selector_selectedMission" call bis_fnc_textureMarker;
	
	_map drawIcon [
		_iconSelected,
		[1,1,1,1],
		_pos,
		48,
		48,
		time * 60,
		"",
		1
	];
	
	if (_focus) then {	//new selection, map should be focused on this icon
		_map ctrlMapAnimAdd [0.3,ctrlMapScale _map,_pos];
		ctrlMapAnimCommit _map;
	};
};