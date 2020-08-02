//#define DEBUG

//--- Bounding box coef, larger mans more tolerant barricade check. Was originally 0.55
#define BBOX_TOLERANCE	0.6

_objects = [
	bis_car_1,
	bis_car_2,
	bis_car_3,
	bis_car_4,
	bis_car_IDAP,
	bis_block_1,
	bis_block_2,
	BIS_barricadeBorder_1,
	BIS_barricadeBorder_2,
	BIS_barricadeBorder_3
];

//--- Scan all objects and get their bounding boxes
if (isnil "bis_barricadeObjectsLocal") then {
	{
		if (_x iskindof "EmptyDetector") then {
			_triggerArea = triggerarea _x;
			_x setvariable ["BIS_bbox",[[0,0,0],[_triggerArea select 0,_triggerArea select 1],[]]];
		} else {
			_bbox1 = _x selectionPosition "BBox_1_1_pos";
			_bbox2 = _x selectionPosition "BBox_1_2_pos";
			if (_bbox1 distance [0,0,0] == 0) then {
				_bbox = boundingboxreal _x;
				_bbox1 = _bbox select 0;
				_bbox2 = _bbox select 1;
			};
			_bboxSizeReal = _bbox2 vectordiff _bbox1;
			_bboxSize = (_bboxSizeReal apply {abs _x}) vectormultiply BBOX_TOLERANCE;
			_bboxCenter = _bbox1 vectoradd (_bboxSizeReal vectormultiply 0.5);

			_bboxSizeX = (_bboxSize select 0) / 1;
			_bboxSizeY = (_bboxSize select 1) / 1;
			_points = [];
			{
				_points append [_bboxCenter vectoradd _x];
			} foreach [
				[-_bboxSizeX,	+_bboxSizeY,	0],
				[0,		+_bboxSizeY,	0],
				[+_bboxSizeX,	+_bboxSizeY,	0],
				[-_bboxSizeX,	-_bboxSizeY,	0],
				[0,		-_bboxSizeY,	0],
				[+_bboxSizeX,	-_bboxSizeY,	0]
			];
			_x setvariable ["BIS_bbox",[_bboxCenter,_bboxSize,_points]];
		};
	} foreach _objects;
	bis_barricadeObjectsLocalOld = [];
};

#ifdef DEBUG
	if (isnil "bis_defaultMarkers") then {bis_defaultMarkers = allmapmarkers;};
	{deletemarker _x} foreach (allMapMarkers - bis_defaultMarkers);
#endif

//--- Reset previous values
{
	_x setvariable ["BIS_intersect",[]];
} foreach _objects;

//--- Go through objects and find intersections
{
	_obj = _x;
	_area = _obj getvariable "BIS_bbox";
	_pos = _obj modeltoworld (_area select 0);
	_size = _area select 1;
	_points = _area select 2;
	_intersect = [];

	//if (vectormagnitude velocity _x < 0.1) then {
		{
			_point = _obj modeltoworld _x;
			_isIntersect = false;
			{
				_xarea = _x getvariable "BIS_bbox";
				_xpos = _obj modeltoworld (_xarea select 0);
				_xsize = _xarea select 1;
				_xdir = if (_x iskindof "EmptyDetector") then {triggerarea _x select 2} else {direction _x};
				_isIntersect = _isIntersect || _point inarea [position _x,_xsize select 0,_xsize select 1,_xdir,true];

				//--- Intersecting
				if (_point inarea [position _x,_xsize select 0,_xsize select 1,_xdir,true]) then {

					//--- Save scanned object into intersecting object
					_intersect = _obj getvariable ["BIS_intersect",[]];
					_intersect pushbackunique _x;
					_obj setvariable ["BIS_intersect",_intersect];

					//--- Save intersecting object into scanned object
					_xIntersect = _x getvariable ["BIS_intersect",[]];
					_xIntersect pushbackunique _obj;
					_x setvariable ["BIS_intersect",_xIntersect];
				};
			} foreach (_objects - [_obj]);

			#ifdef DEBUG
				_marker = createmarker [str _point,_point];
				_marker setmarkertype "mil_dot";
				_marker setmarkercolor "colorred";
				_marker setmarkersize [0.5,0.5];
				if (_isIntersect) then {_marker setmarkercolor "colorgreen";};
			#endif
		} foreach _points;
	//} else {
	//	_obj setvariable ["BIS_intersect",[]];
	//};

	#ifdef DEBUG
		_dir = if (_obj iskindof "EmptyDetector") then {triggerarea _obj select 2} else {direction _obj};
		_marker = createmarker [str _obj,_pos];
		_marker setmarkershape "rectangle";
		_marker setmarkerbrush "solid";
		_marker setmarkercolor "colorblack";
		_marker setmarkerdir _dir;
		_marker setmarkersize [_size select 0,_size select 1];
	#endif
} foreach _objects;

//--- Get all barricade objects
_fnc_getBarricadeConnection = {
	private _barricadeObjects = _this getvariable ["BIS_intersect",[]];
	{
		_allBarricadeObjects pushbackunique _x;
		_x call _fnc_getBarricadeConnection;
	} foreach (_barricadeObjects - _allBarricadeObjects);
};
_fnc_getMainBarricadeConnection = {
	private _barricadeObjects = _this getvariable ["BIS_intersect",[]];
	{
		_allBarricadeObjectsMain pushbackunique _x;
		_x call _fnc_getMainBarricadeConnection;
	} foreach (_barricadeObjects - _allBarricadeObjectsMain);
};

_allBarricadeObjects = []; //--- All objects in the barricade, no matter to what are they connected
_allBarricadeObjectsMain = []; //--- Only objects connected to the truck, used for measuring if the barricade is built

//--- Main connection
BIS_car_1 call _fnc_getMainBarricadeConnection;

//--- Sub-connections
//vehicle player call _fnc_getBarricadeConnection;
BIS_car_1 call _fnc_getBarricadeConnection;
BIS_barricadeBorder_1 call _fnc_getBarricadeConnection;
BIS_barricadeBorder_2 call _fnc_getBarricadeConnection;
BIS_barricadeBorder_3 call _fnc_getBarricadeConnection;

bis_barricadeObjectsLocal = _allBarricadeObjects;
bis_barricadeObjectsMainLocal = _allBarricadeObjectsMain;

//--- Check if sides are individually connected
bis_barricadeConnectedEast = BIS_barricadeBorder_1 in _allBarricadeObjects;
bis_barricadeConnectedWest = BIS_barricadeBorder_2 in _allBarricadeObjects || BIS_barricadeBorder_3 in _allBarricadeObjects;

//--- Check if the barricade is ready
_barricadeConnectedEast = BIS_barricadeBorder_1 in _allBarricadeObjectsMain;
_barricadeConnectedWest = BIS_barricadeBorder_2 in _allBarricadeObjectsMain || BIS_barricadeBorder_3 in _allBarricadeObjectsMain;
bis_barricadeReady = _barricadeConnectedEast && _barricadeConnectedWest;

#ifdef DEBUG
	hintsilent format [
		"%1 cars connected\nConnected to W cliff: %2\nConnected to E cliff: %3",
		{_x iskindof "car"} count bis_barricadeObjectsLocal,
		BIS_barricadeBorder_2 in _allBarricadeObjects || BIS_barricadeBorder_3 in _allBarricadeObjects,
		BIS_barricadeBorder_1 in _allBarricadeObjects
	];
#endif