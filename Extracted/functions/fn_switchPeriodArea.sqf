#define MAX_DIS	20

//--- Obsolete, collisions are now checked dynamically
if (true) exitwith {};





if !(bis_orange_isHub) exitwith {}; //--- Continue only on hub, time switch is not available elsewhere

params [
	["_object",objnull,[]],
	["_baked",true,[true]]
];

//--- Init
if !(bis_orange_init) exitwith {

	//--- Register
	_objects = missionnamespace getvariable ["BIS_switchPeriodAreas",[]];
	_objects pushback _object;
	missionnamespace setvariable ["BIS_switchPeriodAreas",_objects];

	//--- Caulculate bounding box
	_bboxPos1 = _object selectionposition "bbox_1_1_pos";
	_bboxPos2 = _object selectionposition "bbox_1_2_pos";
	if (_bboxPos1 distance [0,0,0] == 0 || true) then {
		_bbox = boundingboxreal _object;
		_bboxPos1 = _bbox select 0;
		_bboxPos2 = _bbox select 1;
	};
	if (_baked) then {
		//--- Baked
		_object setvariable [
			"bis_switchPeriodArea",
			[
				true,
				[
					_object modeltoworld [
						((_bboxPos1 select 0) + (_bboxPos2 select 0)) / 2,
						((_bboxPos1 select 1) + (_bboxPos2 select 1)) / 2
					],
					(abs(_bboxPos1 select 0) + abs(_bboxPos2 select 0)) / 2,
					(abs(_bboxPos1 select 1) + abs(_bboxPos2 select 1)) / 2,
					direction _object,
					true
				]
			]
		];
	} else {
		//--- Dynamic
		_object setvariable [
			"bis_switchPeriodArea",
			[
				false,
				[
					//--- Center
					[
						((_bboxPos1 select 0) + (_bboxPos2 select 0)) / 2,
						((_bboxPos1 select 1) + (_bboxPos2 select 1)) / 2
					],
					//--- Size
					(abs(_bboxPos1 select 0) + abs(_bboxPos2 select 0)) / 2,
					(abs(_bboxPos1 select 1) + abs(_bboxPos2 select 1)) / 2
				]
			]
		];
	};
};

//--- Object's layer is now active
_layer = _object getvariable ["BIS_Layer",""];
if (_layer in bis_orange_layersShow) then {
	_pos = position player;
	_data = _object getvariable "bis_switchPeriodArea";
	_baked = _data select 0;
	_area = _data select 1;

	//--- Check if in
	_in = if (_baked) then {
		if (_pos distance (_area select 0) < MAX_DIS) then {
			_pos inarea _area
		} else {
			false
		};
	} else {
		_areaPos = _object modeltoworld (_area select 0);
		if (_pos distance _areaPos < MAX_DIS) then {
			_pos inarea [_areaPos,_area select 1,_area select 2,direction _object,true];
		} else {
			false
		}
	};

	//--- In, move out
	if (_in) then {player setvehicleposition [_pos,[],0,"none"];};
};