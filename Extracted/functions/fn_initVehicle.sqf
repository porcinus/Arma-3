/*
	Author: Julien `Tom_48_97` VIDA, optimized by Jiri Wainar

	Description:
	This function aims to simplify the way to customize vehicles. It can change the textures and/or the animation sources of a given object. Usage of this function is explained in the below examples.

	Important note: Unless it explicitly mentionned (example case 10), the function will restore the initial state of every animation sources of the given object.

	Additional information:
	OPREP - https://dev.arma3.com/post/oprep-vehicle-customization
	Community Wiki - https://community.bistudio.com/wiki/Vehicle_Customization_%28VhC%29

	Parameter(s):
		0: vehicle to customize
		1: Variant (textures)
			BOOL - true to restore default texture source ; false to skip texture source change
			VOID - Nil to skip the texture source change
			ARRAY - Array of texture sources with their given probability: ["textureSource1", 0.5, "textureSource2", 0.5]
			STRING - Variant class name(from the configFile >> cfgVehicles or from the missionConfigfile >> cfgVehicleTemplate)
			SCALAR - index of the texture source (same as the old system)
		2: Animations
			BOOL - true to restore init phase of every animation sources
			VOID - Nil to skip change of the animation sources
			ARRAY - Array of animation sources and probability: ["AnimationSource1", 0.5, "animationSource2", 0.5]. Note, if the first element is false, it will skip the reset of the animation sources
			STRING - Variant class name(from the configFile >> cfgVehicles or from the missionConfigfile >> cfgVehicleTemplate)
		3: Mass
			BOOL - true to set the default mass, false to disable the mass change
			SCALAR - Mass to add or remove the vehicle

	Returns:
	BOOL - True if success, otherwise, false

	Examples:
	1) Do nothing because default VAR texture and VAR animation are "false"
	result = [this] call bis_fnc_initVehicle;

	2) Restore default texture and animation sources (reset)
	result = [this, true, true] call bis_fnc_initVehicle;

	3) Randomize everything according to the config file
	result = [this, "", []] call bis_fnc_initVehicle; //<-- Prefered
	result = [this, "", ""] call bis_fnc_initVehicle;

	4) Skip everything
	result = [this, nil, nil] call bis_fnc_initVehicle; //<-- Prefered
	result = [this, false, false] call bis_fnc_initVehicle;

	5) Apply the given texture and ignore the animations
	Priority is given to [missionConfigFile, "CfgVehicleTemplates"]
	result = [this, "TemplateName", nil] call bis_fnc_initVehicle;

	6) random weighted on the given texture sources and their probability, then randomize the animation sources according to the config file
	result = [this, ["MyTextureSource1", 0.5, "MyTextureSource2", 0.6], []] call bis_fnc_initVehicle;

	7) MyAnimationSource1 phase has a 50% chance to be set to 1 and MyAnimationSource2 has a 70% chance to be set to 1
	result = [this, nil, ["MyAnimationSource1", 0.5, "MyAnimationSource2", 0.7]] call bis_fnc_initVehicle;

	8) MyAnimationSource1 phase will be 1 whereas MyAnimationSource2 will be set to 0
	result = [this, nil, ["MyAnimationSource1", 1, "MyAnimationSource2", 0]] call bis_fnc_initVehicle;

	9) Change animation sources with a given template
	result = [this, nil, "MyTemplate"] call bis_fnc_initVehicle;

	10) Change animation source with a given array of probabilities but skip the reset of all animation sources
	// Algo: Skip the change of texture, [don't reste of the animation sources, proceed the given animation sources with their, probabilities], skip the change of mass
	result = [this, nil, [false,"MyAnimationSource1", 0.5, "MyAnimationSource2", 0.8], nil] call bis_fnc_initVehicle;

	11) Restore the vehicle to its default state as defined in the config (texture, animation sources, mass)
	result = [this, true, true, true] call bis_fnc_initVehicle;

	Todo:
		* Support for SPZ :)
		* Optimization (performance)
*/

//["[i] input: %1",_this] call bis_fnc_logFormat;

#define ANIM(veh,cfg,source,phase)\
if (getText(cfg >> "source") == "door") then\
{\
	veh animateDoor [source,phase,true];\
}\
else\
{\
	if (getNumber(cfg >> "useSource") == 1) then\
	{\
		veh animateSource [source,phase,true];\
	}\
	else\
	{\
		veh animate [source,phase,true];\
	};\
}

params
[
	["_vehicle", objNull, [objNull]],
	["_variant", false, ["STRING", false, 0, []]],
	["_animations", false, [[], false, "STRING"]],
	["_bChangeMass", false, [false, 0]]
];

//if (_animations isEqualType []) then {{["[ ] _animations: %1",_x] call bis_fnc_logFormat;}forEach _animations;};

if !(local _vehicle) exitWith {false};

private _localData = _vehicle getVariable "bis_fnc_initVehicle_customization";

if (!is3DEN && !isNil{_localData}) then
{
	_vehicle setVariable ["bis_fnc_initVehicle_customization",nil];

	_variant 	 = _localData param [0, _variant, ["STRING", false, 0, []]];
	_animations  = _localData param [1, _animations, [[], false, "STRING"]];
	_bChangeMass = _localData param [2, _bChangeMass, [false, 0]];
};

/*---------------------------------------------------------------------------
	Get parameters from the config & the vehicle & prepare the local variables
---------------------------------------------------------------------------*/
private _vehicleType = typeOf _vehicle;
private _skipRandomization = ({(_vehicleType isEqualTo _x) || (_vehicleType isKindOf _x) || (format ["%1", _vehicle] isEqualTo _x)} count (getArray(missionConfigfile >> "disableRandomization")) > 0);
private _addMass = 0;
private _cfgAnimationSources = configFile >> "CfgVehicles" >> _vehicleType >> "AnimationSources";
private _allAnimationSourcesConfigs = "true" configClasses _cfgAnimationSources;

if (_bChangeMass isEqualType 0) then
{
	_addMass = _bChangeMass;
	_bChangeMass = true;
};

if (getNumber(missionConfigfile >> "CfgVehicleTemplates" >> "disableMassChange") == 1) then
{
	_bChangeMass = false;
};

private _isCampaign = isClass(campaignConfigFile >> "CfgVehicleTemplates");

/*---------------------------------------------------------------------------
	Texture source selection & Set the selected texture
---------------------------------------------------------------------------*/
if !(_variant isEqualTo false) then
{
	private _texturesToApply = [];
	private _materialsToApply = [];
	private _textureList = getArray(configFile >> "CfgVehicles" >> _vehicleType >> "textureList");

	if (_variant isEqualType []) then
	{
		_textureList = _variant;
		_variant = "";
	};

	if (_variant isEqualType true) then
	{
		if (count _textureList > 0) then
		{
			_variant = _textureList select 0;
		} else {
			_variant = "";
		};
	};

	// 1 Support for the old method from Pettka
	if (_variant isEqualType 0) then {
		_variant = if ((_variant >= 0) && ((_variant * 2) <= (count _textureList) -2)) then {_textureList select (_variant * 2)} else {""};
	};

	// 2 Try from the config file (parents only)
	private _cfgVariant = configFile >> "CfgVehicles" >> _variant;
	if (_vehicleType in ([_cfgVariant, true] call BIS_fnc_returnParents)) then
	{
		_textureList = getArray(_cfgVariant >> "textureList");
		private _cfgRoot = _cfgVariant >> "textureSources" >> selectRandomWeighted _textureList;
		_texturesToApply = getArray(_cfgRoot >> "textures");
		_materialsToApply = getArray(_cfgRoot >> "materials");
	};

	// 3 Try from the textureSources of the current vehicle
	private _cfgTextureSourcesVariant = configfile >> "CfgVehicles" >> _vehicleType >> "textureSources" >> _variant;
	if (count _texturesToApply == 0 && {isClass _cfgTextureSourcesVariant}) then
	{
		_texturesToApply = getArray(_cfgTextureSourcesVariant >> "textures");
		_materialsToApply = getArray(_cfgTextureSourcesVariant >> "materials");
	};

	// 4 Valid class from the campaign config file
	private _cfgVehicleTemplatesVariant = campaignConfigFile >> "CfgVehicleTemplates" >> _variant;
	if (_isCampaign && {isClass _cfgVehicleTemplatesVariant}) then
	{
		if (count (getArray(_cfgVehicleTemplatesVariant >> "textures")) >= 1) then
		{
			_texturesToApply = getArray(_cfgVehicleTemplatesVariant >> "textures");
			_materialsToApply = getArray(_cfgVehicleTemplatesVariant >> "materials");
		}
		else
		{
			_texturesToApply = [];
			_materialsToApply = [];
			_textureList = getArray(_cfgVehicleTemplatesVariant >> "textureList")
		};
	};

	// 5 If _variant is a valid class from the mission config file, override textureList and empty texturesToApply
	private _cfgVehicleTemplatesVariant = missionConfigFile >> "CfgVehicleTemplates" >> _variant;
	if (isClass (_cfgVehicleTemplatesVariant)) then {
		if (count (getArray(_cfgVehicleTemplatesVariant >> "textures")) >= 1) then
		{
			_texturesToApply = getArray(_cfgVehicleTemplatesVariant >> "textures");
			_materialsToApply = getArray(_cfgVehicleTemplatesVariant >> "materials");
		}
		else
		{
			_texturesToApply = [];
			_materialsToApply = [];
			_textureList = getArray(_cfgVehicleTemplatesVariant >> "textureList")
		};
	};

	// 4 Else, randomize using the texture list (from the config of the current vehicle)
	if (!(_skipRandomization) && {count _texturesToApply == 0 && {count _textureList >= 2}}) then
	{
		private _cfgRoot = configFile >> "CfgVehicles" >> _vehicleType >> "textureSources" >> selectRandomWeighted _textureList;
		_texturesToApply = getArray(_cfgRoot >> "textures");
		_materialsToApply = getArray(_cfgRoot >> "materials");
	};

	// change the textures
	{_vehicle setObjectTextureGlobal [_forEachindex, _x];} forEach _texturesToApply;

	// change the materials when it is appropriate
	{if (_x != "") then {_vehicle setObjectMaterialGlobal [_forEachindex, _x];};} forEach _materialsToApply;
};

/*---------------------------------------------------------------------------
	Animation sources
---------------------------------------------------------------------------*/
if !(_animations isEqualTo false) then
{
	private _animationList = getArray(configFile >> "CfgVehicles" >> _vehicleType >> "animationList");

	// Find if whether or not the reset of the animation sources should be reset
	private _resetAnimationSources = if (_animations isEqualType [] && {count _animations > 0 && {(_animations select 0) isEqualType true}}) then
	{
		[_animations] call bis_fnc_arrayShift
	}
	else
	{
		true
	};

	//disable animations reset in 3DEN no matter of input
	_resetAnimationSources = _resetAnimationSources && !is3DEN;

	//perform animations reset on all animations in "AnimationSources" class, not only _animationList as it was before
	if (_resetAnimationSources) then
	{
		private _phase = -1;
		private _phaseCurrent = -1;
		private _source = "";

		{
			_source = configName _x;
			_phaseCurrent = _vehicle animationPhase _source;
			_phase = getNumber(_x >> "initPhase");

			if (_phase != _phaseCurrent) then
			{
				//["[ ] reseting %1 -> %2 (is door: %3)",_source,_phase,getText(_x >> "source") == "door"] call bis_fnc_logFormat;

				ANIM(_vehicle,_x,_source,_phase);
			};
		}
		forEach _allAnimationSourcesConfigs;
	};

	// Exit if _animations is true (nothing else to do)
	if (_animations isEqualTo true) exitWith {true};

	if (!(_skipRandomization) && {(_animations isEqualType "" || _variant isEqualType "")}) then
	{
		if (_variant isEqualType "") then
		{
			// 6 - Variant parameter - If the variant is a string and animation is either, an empty string or array
			private _cfgVariant = configFile >> "CfgVehicles" >> _variant;
			if (isClass _cfgVariant && {_animations isEqualTo "" || _animations isEqualTo []}) then
			{
				_animationList = getArray(_cfgVariant >> "animationList");
			};

			// 5 - Variant parameter - Campaign
			if (_isCampaign && {(_animations isEqualTo "" || _animations isEqualTo []) && {isClass (campaignConfigFile >> "CfgVehicleTemplates" >> _variant)}}) then
			{
				_animationList = getArray(campaignConfigFile >> "CfgVehicleTemplates" >> _variant >> "animationList");
			};

			// 4 - Variant parameter - Try from the mission config (_variant)
			private _cfgVehicleTemplatesVariant = missionConfigFile >> "CfgVehicleTemplates" >> _variant;
			if (isClass _cfgVehicleTemplatesVariant && {_animations isEqualTo "" || _animations isEqualTo []}) then
			{
				_animationList = getArray(_cfgVehicleTemplatesVariant >> "animationList");
			};
		};

		if (_animations isEqualType "") then
		{
			// 3 - animation parameter - Try from the config (_animations)
			private _cfgAnimationList = configFile >> "CfgVehicles" >> _animations >> "animationList";
			if (isArray _cfgAnimationList) then {
				_animationList = getArray _cfgAnimationList;
			};

			// 2 - animation parameter - Campaign
			private _cfgAnimationList = campaignConfigFile >> "CfgVehicleTemplates" >> _animations >> "animationList";
			if (_isCampaign && {isArray _cfgAnimationList}) then {
				_animationList = getArray _cfgAnimationList;
			};

			// 1 - animation parameter - Try from the mission config (template class name)
			private _cfgAnimationList = missionConfigFile >> "CfgVehicleTemplates" >> _animations >> "animationList";
			if (isArray _cfgAnimationList) then {
				_animationList = getArray _cfgAnimationList;
			};
		};
	};

	// 4 If (_animations is an array) then, use it
	if (_animations isEqualType [] && {count _animations > 1 && {count _animations mod 2 == 0 && {(_animations select 1) isEqualType 0}}}) then
	{
		_animationList = _animations;
	};

	if (count _animationList > 1) then
	{
		for "_i" from 0 to (count _animationList - 2) step 2 do
		{
			private _source = _animationList select _i;
			private _forceAnimatePhase = getNumber(_cfgAnimationSources >> _source >> "forceAnimatePhase");
			private _forceAnimate = getArray(_cfgAnimationSources >> _source >> "forceAnimate");
			private _chance = _animationList select (_i+1);

			private _phase = if ((random 1) <= _chance) then {1} else {0};
			private _phaseCurrent = _vehicle animationPhase _source;

			//use alternative force animate to the off-phase
			if (_forceAnimatePhase != _phase) then
			{
				_forceAnimate = getArray(_cfgAnimationSources >> _source >> "forceAnimate2");
				_forceAnimatePhase = (1 - _forceAnimatePhase);
			};

			private _forceAnimateAllowed = _forceAnimatePhase == _phase && {_phase != _phaseCurrent && {count _forceAnimate >= 2}};

			//changing animation according to input or according to update from force animation
			if (_phase != _phaseCurrent) then
			{
				//["[!] animating %1 -> %2 (is door: %3)",_source,_phase,getText(_cfgAnimationSources >> _source >> "source") == "door"] call bis_fnc_logFormat;

				ANIM(_vehicle,_cfgAnimationSources >> _source,_source,_phase);
			};

			if (_forceAnimateAllowed) then
			{
				private _forcedAnimName = "";
				private _forcedAnimState = -1;
				private _forcedAnimStateCurrent = -1;
				private _forcedAnimIndex = -1;

				for "_i" from 0 to (count _forceAnimate - 2) step 2 do
				{
					_forcedAnimName = _forceAnimate select _i;
					_forcedAnimState = _forceAnimate select (_i +1);
					_forcedAnimStateCurrent = _vehicle animationPhase _forcedAnimName;

					if (_forcedAnimState != _forcedAnimStateCurrent) then
					{
						//["[ ] force animating %1 -> %2 (is door: %3)",_forcedAnimName,_forcedAnimState,getText(_cfgAnimationSources >> _forcedAnimName >> "source") == "door"] call bis_fnc_logFormat;

						ANIM(_vehicle,_cfgAnimationSources >> _forcedAnimName,_forcedAnimName,_forcedAnimState);
					};

					//propagate the force animation into the _animationList
					_forcedAnimIndex = _animationList find _forcedAnimName;

					if (_forcedAnimIndex > -1) then
					{
						_animationList set [_forcedAnimIndex,_forcedAnimName];
						_animationList set [_forcedAnimIndex + 1,_forcedAnimState];
					};
				};
			};
		};

		//post process animations
		{
			private _source = configName _x;
			private _phase = _vehicle animationPhase _source;

			//lock cargo positions
			private _lockCargoAnimationPhase = getNumber(_x >> "lockCargoAnimationPhase");
			private _lockCargo = getArray(_x >> "lockCargo");
			{_vehicle lockCargo [_x, _lockCargoAnimationPhase == _phase];} forEach _lockCargo;

			//execute phase related code
			private _code = getText(_x >> "onPhaseChanged");
			if (_code != "") then {[_vehicle,_phase] call compile _code;};
		}
		forEach _allAnimationSourcesConfigs;
	};
};


/*---------------------------------------------------------------------------
	Mass change
---------------------------------------------------------------------------*/
if (_bChangeMass && !is3DEN && !isSimpleObject _vehicle) then
{
	//original mass calculation removed
	//[_vehicle, _bChangeMass, _addMass] call bis_fnc_setVehicleMass;

	private _mass = _vehicle getVariable ["bis_fnc_initVehicle_mass",getMass _vehicle];
	_vehicle setVariable ["bis_fnc_initVehicle_mass",_mass,true];

	private _massAdjustment = 0;

	{
		private _source = configName _x;
		private _phase = _vehicle animationPhase _source;

		if (_phase > 0.95) then {_massAdjustment = _massAdjustment + (getNumber(_x >> "mass"))};
	}
	forEach _allAnimationSourcesConfigs;

	_vehicle setMass (_mass + _massAdjustment);
};

/*---------------------------------------------------------------------------
	End of function
---------------------------------------------------------------------------*/
true