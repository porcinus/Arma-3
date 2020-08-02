private ["_competitor", "_cp", "_cpIsStart", "_cpObject", "_radius", "_omniDir", "_timeout", "_onGround", "_slObj", "_slUnload", "_sl", "_timeoutCounter", "_timeoutText", "_timeNow"];
_competitor = _this param [0, player, [objNull]];
_cp = _this param [1, objNull, [objNull]];
_cpIsStart = _this param [2, false, [false]];
_cpObject = _cp getVariable ["CPObject", objNull];
_radius = _cp getVariable ["radius", 5];
_omniDir = _cp getVariable ["omnidirectional", false];
_timeout = _cp getVariable ["timeout", 0];
_onGround = _cp getVariable ["onGround", false];
_slObj = _cp getVariable ["slObject", objNull];
_slUnload = _cp getVariable ["slUnload", false];
_sl = if (isNull _slObj) then {false} else {true};
_timeoutCounter = _timeout;

while {!(_cp getVariable ["clear", false]) && (BIS_TT == 0) && !BIS_TT_reset && ((!BIS_TT_ended && !BIS_TT_ending) || _cpIsStart)} do
{
	private ["_slObjects"];
	_slObjects = [];
	_slObjects = ropeAttachedObjects (vehicle BIS_TT_Competitor);

	//The CP is active when the competitor is inside it
	if ((_competitor distance _cp) < _radius) then 
	{
		if !(_cp getVariable ["active", false]) then 
		{
			_cp setVariable ["active", true];
			_cp call BIS_fnc_moduleTTCPIn;
			
			_timeoutCounter = _timeout;
			_timeNow = time;
		};
	
		//Standard CPs are not onmni-directional and they must be passed through
		if (!_omniDir) then 
		{
			//Normal pass-through CP
			private ["_isBehind"];
			_isBehind = [_competitor, _cpObject] call BIS_fnc_moduleTTCPTriggerBehind;
		
			if (_cp getVariable ["enteredFront", false]) then 
			{
				if (_isBehind) then 
				{
					if ((_timeoutCounter <= 0) && (!_sl || ((!_slUnload && (_slObj in _slObjects)) || (_slUnload && !(_slObj in _slObjects) && ((_slObj distance _cp) < _radius))))) then 
					{					
						_cp setVariable ["enteredFront", nil];
						_cp setVariable ["active", false];
						_cp setVariable ["clear", true];
						_cp call BIS_fnc_moduleTTCPClear;
					};
				};
			} 
			else 
			{
				if (!_isBehind) then 
				{
					_cp setVariable ["enteredFront", true];
				};
			};
		} 
		else 
		{
			//Omni-direction, no timeout or timeout complete
			if ((_timeoutCounter <= 0) && (!_onGround || (isTouchingGround (vehicle _competitor))) && (!_sl || ((!_slUnload && (_slObj in _slObjects)) || (_slUnload && !(_slObj in _slObjects) && ((_slObj distance _cp) < _radius))))) then 
			{					
				_cp setVariable ["enteredFront", nil];
				_cp setVariable ["active", false];
				_cp setVariable ["clear", true];
				_cp call BIS_fnc_moduleTTCPClear;
			};
		};
		
		//Handle possible timeouts for the CP
		if (_timeout > 0) then 
		{
			if (((_timeoutCounter % 1) < 0.1) || ((_timeoutCounter % 1) > 0.9)) then 
			{
				_timeoutText = (str (round (_timeoutCounter max 0))) + ".0";
			} else 
			{
				_timeoutText = str ((_timeoutCounter - (_timeoutCounter % 0.1)) max 0);
			};
			RscFiringDrillCheckpoint_targetTextTotal = _timeoutText;

			_timeoutCounter = _timeoutCounter - (time - _timeNow);
			_timeNow = time;
			
			//Reset the timeout if the competitor is no longer grounded
			if (_onGround && !(isTouchingGround (vehicle _competitor))) then 
			{
				_timeoutCounter = _timeout;
			};
			
			//Reset the timeout if the Sling Load conditions are no longer met
			if (_sl && (!(!_slUnload && (_slObj in _slObjects)) || !(_slUnload && !(_slObj in _slObjects) && ((_slObj distance _cp) < _radius)))) then 
			{
				_timeoutCounter = _timeout;
			};
			
			if (_timeoutCounter <= 0) then 
			{				
				_cp setVariable ["enteredFront", nil];
				_cp setVariable ["active", false];
				_cp setVariable ["clear", true];
				_cp call BIS_fnc_moduleTTCPClear;
			};
		};
	} 
	else 
	{
		if (_cp getVariable ["active", false]) then 
		{
			if (_omniDir && (_timeoutCounter <= 0) && (!_onGround || (isTouchingGround (vehicle _competitor))) && (!_sl || ((!_slUnload && (_slObj in _slObjects)) || (_slUnload && !(_slObj in _slObjects) && ((_slObj distance _cp) < _radius))))) then 
			{
				_cp setVariable ["clear", true];
				_cp call BIS_fnc_moduleTTCPClear;
			};
		
			_cp setVariable ["enteredFront", nil];
			_cp setVariable ["active", false];
			_cp call BIS_fnc_moduleTTCPOut;
		};
	};

	sleep 0.001;
};

true