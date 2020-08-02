params [
	["_mode","",[""]],
	["_objects",[],[[]]]
];

switch _mode do {
	case "Init": {
		_objects = [];
/*
		//--- Create the tree
		if !(isnil "bis_treeBase") then { //--- ToDo: Remove isNil check
			_pos = getposasl bis_treeBase;
			_pos = _pos vectoradd [-0.15,0.55,9.15];
			bis_tree = createsimpleobject ["A3\Plants_F\Tree\t_QuercusIR2s_F.p3d",_pos];
			_objects pushback bis_tree;
		};

		//--- Use Malden houses when available
		{
			_old = _x select 0;
			_class = _x select 1;
			_pos = _x select 2;
			if (isclass (configfile >> "CfgVehicles" >> _class)) then {
				_new = createvehicle [_class,position _old,[],0,"can_collide"];
				_new setPosworld _pos;
				_new setdir direction _old;
				_objects pushback _new;
				deletevehicle _old;
			};
		} foreach [
			//[BIS_S5,"Land_i_House_Big_01_b_pink_F",[4536.37,21340.6,293.883]],
			//[BIS_N2,"Land_i_House_Big_01_b_whiteblue_F",[4563.63,21447.705,305.3415]]
			//[BIS_N7,"Land_i_House_Big_02_b_blue_F",getposworld bis_n7]
		];
*/
		[_objects,"Town"] call bis_orange_fnc_register;
	};
	case "Show": {
	};
	case "Hide": {
	};
};