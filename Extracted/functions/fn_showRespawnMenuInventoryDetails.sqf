_mode = if ((count _this) == 0) then {"auto"} else {_this select 0};

with uiNamespace do {
	disableSerialization;

	_display = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_display} else {BIS_RscRespawnControlsMap_display};
	_ctrlGroup = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_ctrlDetailsControlsGroup} else {BIS_RscRespawnControlsMap_ctrlDetailsControlsGroup};
	_detailsList = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_ctrlDetailsList} else {BIS_RscRespawnControlsMap_ctrlDetailsList};
	_roleList = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_ctrlRoleList} else {BIS_RscRespawnControlsMap_ctrlRoleList};
	_combo = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_ctrlComboLoadout} else {BIS_RscRespawnControlsMap_ctrlComboLoadout};

	// Diagnostics:
	["_display: %1, _ctrlGroup: %2,_detailsList: %3,_roleList: %4,_combo %5",_display,_ctrlGroup,_detailsList,_roleList,_combo] call BIS_fnc_logFormat;

	//=== Functions ===
	_fnc_handler = //handlers for hiding of control when clicked outside of it
	{	
		_state = _this select 0;
		
		switch (_state) do 
		{
			case "create": 
			{
				if (isNil {missionNamespace getVariable "BIS_RscRespawnControls_detailsHandlerDisplay"}) then 
				{
					missionNamespace setVariable ["BIS_RscRespawnControls_detailsHandlerDisplay", _display displayAddEventHandler ["mouseButtonDown",
					{
						[] spawn 
						{
							sleep 0.05;
							_timerDetails = uiNamespace getVariable ["BIS_RscRespawnControls_detailsHandlerTimer",0];
							_timerCombo = uiNamespace getVariable ["BIS_RscRespawnControls_comboHandlerTimer",0];
							_timer = if (_timerCombo > _timerDetails) then {_timerCombo} else {_timerDetails};
							if ((time - 0.2) > _timer) then 
							{	//no control handler in last 0.2s, which means the click was outside the control and the control should be closed
								["close"] spawn BIS_fnc_showRespawnMenuInventoryDetails;
							};
						};
					}]];
				};
				if (isNil {missionNamespace getVariable "BIS_RscRespawnControls_detailsHandlerCombo"}) then 
				{
					missionNamespace setVariable ["BIS_RscRespawnControls_detailsHandlerCombo", _combo ctrlAddEventHandler ["mouseButtonDown",
					{
						uiNamespace setVariable ["BIS_RscRespawnControls_comboHandlerTimer",time]
					}]];
				};
				if (isNil {missionNamespace getVariable "BIS_RscRespawnControls_detailsHandlerGroup"}) then 
				{
					missionNamespace setVariable ["BIS_RscRespawnControls_detailsHandlerGroup", _ctrlGroup ctrlAddEventHandler ["mouseButtonDown",
					{
						uiNamespace setVariable ["BIS_RscRespawnControls_detailsHandlerTimer",time]
					}]];
				};
			};
			case "remove": 
			{	
				_display displayRemoveEventHandler ["mouseButtonDown", missionNamespace getVariable ["BIS_RscRespawnControls_detailsHandlerDisplay", -1]];
				missionNamespace setVariable ["BIS_RscRespawnControls_detailsHandlerDisplay", nil];				
				_ctrlGroup ctrlRemoveEventHandler ["mouseButtonDown", missionNamespace getVariable ["BIS_RscRespawnControls_detailsHandlerGroup", -1]];
				missionNamespace setVariable ["BIS_RscRespawnControls_detailsHandlerGroup", nil];
				_combo ctrlRemoveEventHandler ["mouseButtonDown", missionNamespace getVariable ["BIS_RscRespawnControls_detailsHandlerCombo", -1]];
				missionNamespace setVariable ["BIS_RscRespawnControls_detailsHandlerCombo", nil];
			};
		};
		
	};
	
	_fnc_addItems = {
		_cfg = _this select 0;
		_previewObject = objNull;

		//--- Parse description
		_cfgWeapons = configfile >> "CfgWeapons";
		_cfgMagazines = configfile >> "CfgMagazines";
		_cfgVehicles = configfile >> "CfgVehicles";
		_cfgGoggles = configfile >> "CfgGoggles";
		
		_itemData = {
			_itemCfg = _this select 0;
			_itemCount = _this select 1;

			if (isclass _itemCfg) then {
				_itemName = _itemCfg call bis_fnc_displayName;
				_picture = gettext (_itemCfg >> "picture");
				_text = _text + format [
					"<img image='%1' size='1.5' shadow='0' /> %2<t align='right'>%3</t><br />",
					_picture,
					_itemName,
					_itemCount
				];
			};
		};
		
		_drawCategory = {
			_text = _text + "<img image='#(argb,8,8,3)color(0,0,0,0)' size='0.8' /><br />";
		};
		
		_weaponData = {
			_cfgWeapon = _cfgWeapons >> (_this select 0);
			if (isclass _cfgWeapon) then {
				[_cfgWeapon,1] call _itemData;
				{
					[_cfgWeapons >> _x,1] call _itemData;
				} foreach (_this select 1);
				{
					_magazineID = _magazineTypes find (tolower _x);
					if (_magazineID >= 0) then {
						[_cfgMagazines >> _x,_magazineCounts select _magazineID] call _itemData;
						_magazineTypes set [_magazineID,""];
					};
				} foreach getarray (_cfgWeapon >> "magazines");
				[] call _drawCategory;
			};
		};
		
		_filterArray = {
			_input = _this select 0;
			_outputTypes = _this select 1;
			_outputCounts = _this select 2;

			while {count _input > 0} do {
				_item = _input select 0;
				_outputTypes set [count _outputTypes,tolower _item];
				_outputCounts set [count _outputCounts,{_item == _x} count _input];
				_input = _input - [_item];
			};
			_input
		};

		_text = "";

		if (isnull _previewObject) then {_previewObject = (typeof player) createvehiclelocal [10,10,-10];};
		[_previewObject,_cfg] call bis_fnc_loadInventory;

		_magazines = magazines _previewObject;
		_magazineTypes = [];
		_magazineCounts = [];
		[_magazines,_magazineTypes,_magazineCounts] call _filterArray;
		
		[primaryweapon _previewObject,primaryweaponitems _previewObject] call _weaponData;
		[secondaryweapon _previewObject,secondaryweaponitems _previewObject] call _weaponData;
		[handgunweapon _previewObject,handgunitems _previewObject] call _weaponData;
		{
			[_cfgMagazines >> _x,_magazineCounts select _foreachindex] call _itemData;
		} foreach _magazineTypes;
		[] call _drawCategory;
		
		[_cfgWeapons >> uniform _previewObject,1] call _itemData;
		[_cfgWeapons >> vest _previewObject,1] call _itemData;
		[_cfgVehicles >> backpack _previewObject,1] call _itemData;
		[_cfgWeapons >> headgear _previewObject,1] call _itemData;
		[_cfgGoggles >> goggles _previewObject,1] call _itemData;
		[] call _drawCategory;

		_assignedItems = assignedItems _previewObject;
		_assignedItems = _assignedItems - [headgear _previewObject,goggles _previewObject];
		_assignedItemsTypes = [];
		_assignedItemsCounts = [];
		[_assignedItems,_assignedItemsTypes,_assignedItemsCounts] call _filterArray;
		{
			[_cfgWeapons >> _x,_assignedItemsCounts select _foreachindex] call _itemData;
		} foreach _assignedItemsTypes;

		_items = items _previewObject;
		_items = _items - _magazines;
		_itemsTypes = [];

		_itemsCounts = [];
		[_items,_itemsTypes,_itemsCounts] call _filterArray;
		{
			[_cfgWeapons >> _x,_itemsCounts select _foreachindex] call _itemData;
		} foreach _itemsTypes;
		
		_text = "<t size='0.8'>" + _text + "</t>";	//using small font
		
		//info stored in _text and it requires structured text component
		_detailsList ctrlSetStructuredText parseText _text;
		
		_h = ctrlTextHeight _detailsList;
		_curPos = ctrlPosition _detailsList;
		_detailsList ctrlSetPosition [_curPos select 0,_curPos select 1,_curPos select 2,_h];
		_detailsList ctrlCommit 0;
	};
	
	_fnc_list = {	//processing all items of loadout and fill them in the list
		_curSelList = lbCurSel _roleList;
		_curSelCombo = lbCurSel _combo;
		
		if !(_curSelCombo < 0) then {	//there is something selected
			_metadata = ["get",_curSelList] call BIS_fnc_showRespawnMenuInventoryMetadata;
			_loadouts = _metadata select 1;
			_comboText = _combo lbText _curSelCombo;
			
			//--- Find correct item in metadata
			_loadoutArray = [];
			{
				if ((_x select 1) isEqualTo _comboText) exitWith {_loadoutArray = _x};
			} forEach _loadouts;
			
			//--- Metadata for item found, process it
			if ((count _loadoutArray) > 0) then {
				_cfg = _loadoutArray select 2;
				
				[_cfg] call _fnc_addItems;
			};
		};
	};
	
	//=== Main part ===
	switch (_mode) do {
		case "auto": {	//--- auto mode - detects current state and changes it
			if (BIS_RscRespawnControls_details) then {
				//details opened - close it
				_detailsList ctrlSetStructuredText parseText "";
				_ctrlGroup ctrlSetFade 1;
				_ctrlGroup ctrlCommit 0;
				_ctrlGroup ctrlEnable false;
				
				["remove"] call _fnc_handler;
				BIS_RscRespawnControls_details = false;
			} else {
				//details closed - open it
				_ctrlGroup ctrlEnable true;
				_ctrlGroup ctrlSetFade 0;
				_ctrlGroup ctrlCommit 0;
				
				["create"] call _fnc_handler;
				call _fnc_list;
				ctrlSetFocus _ctrlGroup;
				BIS_RscRespawnControls_details = true;
			};
		};
		case "open": {	//--- open mode - opens details, doesn't care what is the current status
			_ctrlGroup ctrlEnable true;
			_ctrlGroup ctrlSetFade 0;
			_ctrlGroup ctrlCommit 0;
			
			["create"] call _fnc_handler;
			call _fnc_list;
			ctrlSetFocus _ctrlGroup;
			BIS_RscRespawnControls_details = true;
		};
		case "close": {	//--- close mode - closes details, doesn't care what is the current status
			_detailsList ctrlSetStructuredText parseText "";
			_ctrlGroup ctrlSetFade 1;
			_ctrlGroup ctrlCommit 0;
			_ctrlGroup ctrlEnable false;
			
			["remove"] call _fnc_handler;
			BIS_RscRespawnControls_details = false;
		};
	};
};