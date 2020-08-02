private ["_logic","_units","_isPosition","_isRotation","_pitch","_bank","_pos","_dir","_radius"];

_logic = _this param [0,objnull,[objnull]];
_units = _this param [1,[],[[]]];
_activated = _this param [2,true,[true]];

if (_activated) then {

	//--- Extract the user defined module arguments
	_isPosition = _logic getvariable ["position",0];
	_isRotation = _logic getvariable ["rotation",0];
	if (_isPosition isequaltype "") then {_isPosition = parsenumber _isPosition;};
	if (_isRotation isequaltype "") then {_isRotation = parsenumber _isRotation;};
	_pitch		= _logic getvariable ["pitch",0];	
	_bank 		= _logic getvariable ["bank",0];
	_radius		= _logic getvariable ["radius",3];
	_elevation 	= _logic getvariable ["elevation",0];

	//---saving module position and orientation
	_pos = getPos _logic;
	_dir = getDir _logic;

	//--- Repositioning objects to posion of module
	if (_isPosition > 0) then
	{
		_pos set [2,((_pos select 2) + _elevation)]; // adding elevation if available
		{
			(vehicle _x) setPos ([_pos,random _radius,random 360] call BIS_fnc_relPos);
		} foreach _units;
	};
	//--- Rotating objects in direction of module
	if (_isRotation > 0) then
	{
		{
			_veh = vehicle _x;
			_veh setDir _dir;
			if (_veh isKindOf "CaManBase") then 
			{
				(group _veh) setFormDir _dir;
			};
		} foreach _units;	
	};	
	//--- Object pitch and bank
	if !((_pitch==0)&&(_bank==0)) then
	{
		{
			_veh = vehicle _x;
			[_veh,_pitch,_bank] call BIS_fnc_setPitchBank; 
		} foreach _units;	
	};
};

true