waitUntil {{isNil _x} count ["BIS_cop1", "BIS_copRescued"] == 0};

if (alive BIS_cop1 && {!BIS_copRescued}) then
{
	if (isServer) then
	{
		BIS_fnc_serverOnCopUntie =
		{
			if (BIS_copRescued && {alive BIS_cop1}) then
			{
				// Detect when the animation finishes
				private _animEH = BIS_cop1 addEventHandler ["AnimDone",
				{
					params ["_unit", "_anim"];

					if (_anim == "Acts_AidlPsitMstpSsurWnonDnon_out") then
					{
						// Remove event handler
						_unit removeEventHandler ["AnimDone", _unit getVariable "BIS_animEH"];
						_unit setVariable ["BIS_animEH", nil];

						// him look around
						{_unit enableAI _x} forEach ["AUTOTARGET", "TARGET"];
						_unit enableMimics true;
					};
				}];

				// Store event handler
				BIS_cop1 setVariable ["BIS_animEH", _animEH];

				// Play animation
				BIS_cop1 playMoveNow "Acts_AidlPsitMstpSsurWnonDnon_out";

				// Play conversation
				private _conversationScript = ["p35_Rescued"] spawn BIS_fnc_missionConversations;
				//["p35_Rescued", "BIS_fnc_missionConversations"] call BIS_fnc_MP;
			};
		};

		"BIS_copRescued" addPublicVariableEventHandler
		{
			[] call BIS_fnc_serverOnCopUntie;
		};
	};

	if (hasInterface) then
	{
		BIS_fnc_canUntiePoliceman =
		{
			params [["_player", objNull, [objNull]], ["_policeman", objNull, [objNull]]];

			alive _policeman
			&&
			!(missionNamespace getVariable ["BIS_copRescued", false])
			&&
			{vehicle _player == _player}
			&&
			{_player distance _policeman <= 3}
		};

		private _fn_onUntiePoliceman =
		{
			BIS_copRescued = true;
			publicVariable "BIS_copRescued";

			if (isServer) then
			{
				[] call BIS_fnc_serverOnCopUntie;
			};
		};

		private _iconIdle = "A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_unbind_ca.paa";
		private _iconProgress = _iconIdle;
		private _condShow = "[_this, _target] call BIS_fnc_canUntiePoliceman;";
		private _actionTitle = localize "STR_A3_ApexProtocol_action_Untie";

		private _actionID = [BIS_cop1, _actionTitle, _iconIdle, _iconProgress, _condShow, _condShow, {}, {}, _fn_onUntiePoliceman, {}, [], 4.0, 1000, false, true] call bis_fnc_holdActionAdd;
	};
};

true