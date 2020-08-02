if (getMissionConfigValue ["ShowLawOfWar",0] > 0 && {!is3DEN}) then {
	private _mode = param [0,"",[""]];
	private _this = param [1,[]];

	_hint = [];

	switch _mode do {

		case "entityKilled": {
			_obj = param [0,objnull,[objnull]];
			_shooter = param [1,objnull,[objnull]];
			_shooterReal = param [2,objnull,[objnull]]; //--- Person who actually fired the weapon, used for drones
			_objSide = side group _obj;

			//--- Not killed by player, terminate
			if (_shooter != player && _shooterReal != player) exitwith {};

			if !(isnull group _obj) then {

				//--- Art. 51 - Civilian Population
				if (_objSide == civilian && {primaryweapon _obj == "" && secondaryweapon _obj == "" && handgunweapon _obj == ""}) exitwith {
					_hint = ["GenevaConvention","Article51","Hint"];
				};

				//--- Art. 41 - Safeguard of an enemy hors de combat
				if (lifestate _obj == "INCAPACITATED" && {!([_objSide,side group _shooter] call bis_fnc_areFriendly)}) exitwith {
					_hint = ["GenevaConvention","Article41","Hint"];
				};

				//--- Art. 42 - Occupants of Aircraft
				if (vehicle _obj iskindof "ParachuteBase" && {_obj getvariable ["isPilot",false] || {gettext (configfile >> "CfgVehicles" >> typeof _obj >> "textSingular") == "pilot"}}) exitwith {
					_hint = ["GenevaConvention","Article42","Hint"];
				};
			} else {
				_cfgObj = configfile >> "CfgVehicles" >> typeof _obj;
				_editorSubcategory = tolower gettext (_cfgObj >> "editorSubcategory");

				//--- Art. 53 - Cultural Objects
				if (_editorSubcategory in ["edsubcat_historical","edsubcat_religious"]) exitwith {
					_hint = ["GenevaConvention","Article53","Hint"];
				};

				//--- Art. 52 - Civilian Objects
				if (_editorSubcategory in ["edsubcat_residential_city","edsubcat_residential_village","edsubcat_services"]) exitwith {
					_hint = ["GenevaConvention","Article52","Hint"];
				};
			};
		};

		case "firedCluster": {
			_shooter = param [0,objnull,[objnull]];
			if (_shooter != player) exitwith {};
			_hint = ["ClusterConvention","Article1","Hint"];
		};

		case "firedMine": {
			_shooter = param [0,objnull,[objnull]];
			if (_shooter != player) exitwith {};
			_hint = ["OttawaTreaty","Article3","Hint"];
		};

		//--- System init
		case "postInit": {
			addmissioneventhandler ["entityKilled",{["entityKilled",_this] call bis_fnc_showLawOfWar}];
		};
	};

	if (count _hint > 0) then {

		//--- Show on the screen
		[_hint,nil,nil,nil,nil,nil,true,true] call BIS_fnc_advHint;

		//--- Register for debriefing
		private "_debriefing";
		_debriefing = missionnamespace getvariable "RscDisplayDebriefing_LOAC";
		if (isnil "_debriefing") then {
			_debriefing = [];
			missionnamespace setvariable ["RscDisplayDebriefing_LOAC",_debriefing];
		};
		_debriefing pushbackunique _hint;
	};
};