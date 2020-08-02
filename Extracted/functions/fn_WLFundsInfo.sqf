/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Funds & sector status UI handle
*/

private ["_income"];

disableSerialization;

waitUntil {!isNull findDisplay 46};
_myDisplay = findDisplay 46;

_osd_background = _myDisplay ctrlCreate ["RscText", -1];
_osd_cp_current = _myDisplay ctrlCreate ["RscStructuredText", -1];
_osd_cp_income = _myDisplay ctrlCreate ["RscStructuredText", -1];
_osd_cp_dummies = _myDisplay ctrlCreate ["RscStructuredText", -1];
_osd_cp_progress_background = _myDisplay ctrlCreate ["RscText", -1];
_osd_cp_progress = _myDisplay ctrlCreate ["RscProgress", 9989999];
_osd_cp_action_title = _myDisplay ctrlCreate ["RscStructuredText", -1];
_osd_cp_progress_voting_background = _myDisplay ctrlCreate ["RscText", -1];
_osd_cp_progress_voting = _myDisplay ctrlCreate ["RscProgress", 9989998];
_osd_cp_action_voting_title = _myDisplay ctrlCreate ["RscStructuredText", -1];

_xDef = safezoneX;
_yDef = safezoneY;
_wDef = safezoneW;
_hDef = safezoneH;

_x = _xDef + _wDef * 0.835;
_y = _yDef + _hDef * 0.8;
_w = _wDef * 0.145;
_h = _hDef * 0.145;

_osd_background ctrlSetPosition [_x, _y, _w, _h];
_osd_background ctrlSetBackgroundColor [0, 0, 0, 0];
_osd_background ctrlCommit 0;

_osd_cp_current ctrlSetFontHeight (_h / 4);
_osd_cp_current ctrlSetPosition [_x, _y, _w / 2, _h / 5];
_osd_cp_current ctrlSetBackgroundColor [0, 0, 0, 0];
_osd_cp_current ctrlSetTextColor [1, 1, 1, 1];
_osd_cp_current ctrlCommit 0;

_osd_cp_income ctrlSetFontHeight (_h / 4);
_osd_cp_income ctrlSetPosition [_x + (_w / 2), _y, _w / 2, _h / 5];
_osd_cp_income ctrlSetBackgroundColor [0, 0, 0, 0];
_osd_cp_income ctrlSetTextColor [1, 1, 1, 0.75];
_osd_cp_income ctrlCommit 0;

_osd_cp_dummies ctrlSetFontHeight (_h / 4);
_osd_cp_dummies ctrlSetPosition [_x, _y + (_h / 5), _w, _h / 5];
_osd_cp_dummies ctrlSetBackgroundColor [0, 0, 0, 0];
_osd_cp_dummies ctrlSetTextColor [1, 1, 1, 0.75];
_osd_cp_dummies ctrlCommit 0;

_osd_cp_progress_background ctrlSetPosition [_x, _y + ((_h / 5) * 2), _w, _h / 5];
_osd_cp_progress_background ctrlSetBackgroundColor [0, 0, 0, 0];
_osd_cp_progress_background ctrlCommit 0;

_osd_cp_progress ctrlSetPosition [_x, _y + ((_h / 5) * 2), _w, _h / 5];
_osd_cp_progress ctrlSetTextColor [0, 0, 0, 0];
_osd_cp_progress ctrlCommit 0;

_osd_cp_action_title ctrlSetPosition [_x, _y + ((_h / 5) * 2), _w, _h / 5];
_osd_cp_action_title ctrlSetBackgroundColor [0, 0, 0, 0];
_osd_cp_action_title ctrlSetTextColor [1, 1, 1, 1];
_osd_cp_action_title ctrlCommit 0;

_osd_cp_progress_voting_background ctrlSetPosition [_x, _y + ((_h / 5) * 3.125), _w, _h / 5];
_osd_cp_progress_voting_background ctrlSetBackgroundColor [0, 0, 0, 0];
_osd_cp_progress_voting_background ctrlCommit 0;

_osd_cp_progress_voting ctrlSetPosition [_x, _y + ((_h / 5) * 3.125), _w, _h / 5];
_osd_cp_progress_voting ctrlSetTextColor [0, 0, 0, 0];
_osd_cp_progress_voting ctrlCommit 0;

_osd_cp_action_voting_title ctrlSetPosition [_x, _y + ((_h / 5) * 3.25), _w, _h / 5];
_osd_cp_action_voting_title ctrlSetBackgroundColor [0, 0, 0, 0];
_osd_cp_action_voting_title ctrlSetTextColor [1, 1, 1, 1];
_osd_cp_action_voting_title ctrlCommit 0;

_income = 0;
_prevFunds = 0;
sleep 1;

while {TRUE} do {
	_tmout = 1;
	if (visibleMap) then {_tmout = 0.1};
	if (BIS_WL_recalculateIncome) then {
		BIS_WL_recalculateIncome = FALSE;
		_income = (side group player) call BIS_fnc_WLcalculateIncome;
	};
	_matesAvail = BIS_WL_matesAvailable + 1 - count units group player;
	if (_matesAvail < 0) then {_matesAvail = 0};
	_curFunds = floor (player getVariable ["BIS_WL_funds", 0]);
	_osd_cp_current ctrlSetStructuredText parseText format ["<t shadow = '2' size = '%3' color = '%4'>%1 %2</t>", _curFunds, localize "STR_A3_WL_unit_cp", (1 call BIS_fnc_WLSubroutine_purchaseMenuGetUIScale), if (_curFunds == BIS_WL_maxCP) then {"#aaaaaa"} else {if (_curFunds <= _prevFunds) then {"#ffffff"} else {"#287e3d"}}];
	if (_curFunds > _prevFunds) then {
		_osd_cp_current spawn {
			sleep 0.25;
			_this ctrlSetStructuredText parseText format ["<t shadow = '2' size = '%3'>%1 %2</t>", floor (player getVariable "BIS_WL_funds"), localize "STR_A3_WL_unit_cp", (1 call BIS_fnc_WLSubroutine_purchaseMenuGetUIScale)];
		};
	};
	_prevFunds = _curFunds;
	_osd_cp_income ctrlSetStructuredText parseText format ["<t align = 'right' shadow = '2' size = '%3'>+%1/%2</t>", floor _income, localize "STR_A3_rscmpprogress_min", (1 call BIS_fnc_WLSubroutine_purchaseMenuGetUIScale)];
	if (_matesAvail > 0) then {
		_osd_cp_dummies ctrlSetStructuredText parseText format ["<t size = '%2' align = 'center' shadow = '2'>" + localize "STR_A3_WL_max_group_size" + "</t>", _matesAvail, (0.75 call BIS_fnc_WLSubroutine_purchaseMenuGetUIScale)];
	} else {
		_osd_cp_dummies ctrlSetStructuredText parseText "";
	};
	if (count BIS_WL_seizingBar_progress > 0) then {
		if !(BIS_WL_seizingBar_progress isEqualTo BIS_WL_seizingBar_progress_prev) then {
			_cond = if (count BIS_WL_seizingBar_progress_prev == 0) then {TRUE} else {(BIS_WL_seizingBar_progress # 1) != (BIS_WL_seizingBar_progress_prev # 1)};
			if (_cond) then {
				terminate BIS_WL_seizingBar_progress_loop;
				BIS_WL_seizingBar_progress_prev = +BIS_WL_seizingBar_progress;
				_osd_cp_action_title ctrlSetStructuredText parseText format ["<t align = 'center' shadow = '2' size = '%2'>%1</t>", BIS_WL_seizingBar_progress # 4, (1 call BIS_fnc_WLSubroutine_purchaseMenuGetUIScale)];
				_osd_cp_progress_background ctrlSetBackgroundColor (BIS_WL_seizingBar_progress # 3);
				_osd_cp_progress ctrlSetTextColor (BIS_WL_seizingBar_progress # 2);
				BIS_WL_seizingBar_progress_loop = [_osd_cp_action_title, _osd_cp_progress_background, _osd_cp_progress] spawn {
					disableSerialization;
					_osd_cp_action_title = _this # 0;
					_osd_cp_progress_background = _this # 1;
					_osd_cp_progress = _this # 2;
					_timeLeft = BIS_WL_seizingBar_progress # 0;
					_timeout = BIS_WL_seizingBar_progress # 1;
					_progressStartTime = (call BIS_fnc_WLSyncedTime) - _timeout + _timeLeft;
					_progressEndTime = _progressStartTime + _timeout;
					_hidden = FALSE;
					while {count BIS_WL_seizingBar_progress > 0} do {
						_progressCur = linearConversion [_progressStartTime,_progressEndTime,(call BIS_fnc_WLSyncedTime),0,1];
						if (_progressCur <= 0) then {
							_hidden = TRUE;
							_osd_cp_action_title ctrlSetStructuredText parseText "";
							_osd_cp_progress_background ctrlSetBackgroundColor [0, 0, 0, 0];
							_osd_cp_progress ctrlSetTextColor [0, 0, 0, 0];
						} else {
							if (_hidden && count BIS_WL_seizingBar_progress >= 5) then {
								_hidden = FALSE;
								_osd_cp_action_title ctrlSetStructuredText parseText format ["<t align = 'center' shadow = '2' size = '%2'>%1</t>", BIS_WL_seizingBar_progress # 4, (1 call BIS_fnc_WLSubroutine_purchaseMenuGetUIScale)];
								_osd_cp_progress_background ctrlSetBackgroundColor (BIS_WL_seizingBar_progress # 3);
								_osd_cp_progress ctrlSetTextColor (BIS_WL_seizingBar_progress # 2);
							};
							(findDisplay 46 displayCtrl 9989999) progressSetPosition _progressCur;
							if (_progressCur >= 1) exitWith {
								_osd_cp_action_title ctrlSetStructuredText parseText "";
								_osd_cp_progress_background ctrlSetBackgroundColor [0, 0, 0, 0];
								_osd_cp_progress ctrlSetTextColor [0, 0, 0, 0];
							};
						};
						sleep 0.05;
					};
				};
			};
		};
	} else {
		if !(BIS_WL_seizingBar_progress isEqualTo BIS_WL_seizingBar_progress_prev) then {
			terminate BIS_WL_seizingBar_progress_loop;
			BIS_WL_seizingBar_progress_prev = +BIS_WL_seizingBar_progress;
			_osd_cp_action_title ctrlSetStructuredText parseText "";
			_osd_cp_progress_background ctrlSetBackgroundColor [0, 0, 0, 0];
			_osd_cp_progress ctrlSetTextColor [0, 0, 0, 0];
		};
	};
	if (count BIS_WL_votingBar_progress > 0) then {
		if !(BIS_WL_votingBar_progress isEqualTo BIS_WL_votingBar_progress_prev) then {
			_cond = if (count BIS_WL_votingBar_progress_prev == 0) then {TRUE} else {(BIS_WL_votingBar_progress # 1) != (BIS_WL_votingBar_progress_prev # 1) || (BIS_WL_votingBar_progress # 4) != (BIS_WL_votingBar_progress_prev # 4)};
			if (_cond) then {
				terminate BIS_WL_votingBar_progress_loop;
				BIS_WL_votingBar_progress_prev = +BIS_WL_votingBar_progress;
				_osd_cp_action_voting_title ctrlSetStructuredText parseText format ["<t align = 'center' shadow = '2' size = '%2'>%1</t>", BIS_WL_votingBar_progress # 4, (0.75 call BIS_fnc_WLSubroutine_purchaseMenuGetUIScale)];
				_osd_cp_progress_voting_background ctrlSetBackgroundColor (BIS_WL_votingBar_progress # 3);
				_osd_cp_progress_voting ctrlSetTextColor (BIS_WL_votingBar_progress # 2);
				BIS_WL_votingBar_progress_loop = [] spawn {
					_timeLeft = BIS_WL_votingBar_progress # 0;
					_timeout = BIS_WL_votingBar_progress # 1;
					_progressStartTime = (call BIS_fnc_WLSyncedTime) - _timeout + _timeLeft;
					_progressEndTime = _progressStartTime + _timeout;
					while {count BIS_WL_votingBar_progress > 0} do {
						_progressCur = linearConversion [_progressStartTime,_progressEndTime,(call BIS_fnc_WLSyncedTime),0,1];
						(findDisplay 46 displayCtrl 9989998) progressSetPosition _progressCur;
						sleep 0.05;
					};
				};
			};
		};
	} else {
		if !(BIS_WL_votingBar_progress isEqualTo BIS_WL_votingBar_progress_prev) then {
			terminate BIS_WL_votingBar_progress_loop;
			BIS_WL_votingBar_progress_prev = +BIS_WL_votingBar_progress;
			_osd_cp_action_voting_title ctrlSetStructuredText parseText "";
			_osd_cp_progress_voting_background ctrlSetBackgroundColor [0, 0, 0, 0];
			_osd_cp_progress_voting ctrlSetTextColor [0, 0, 0, 0];
		};
	};
	sleep _tmout;
};