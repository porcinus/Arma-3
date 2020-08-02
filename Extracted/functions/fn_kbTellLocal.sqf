private _data = _this;
_mode = _this param [0,"",[""]];
_this = _this param [1,[]];

switch _mode do {
	case "sentence": {
		private _from = _this select 0;
		private _params = _this select 1;

		// Play audio
		if (local _from) then {_from kbtell _params};

		private _to = _params select 0;
		private _sentence = _params select 2;
		private _channel = _params param [3,"",["", true]];
		if (typeName _channel == "STRING") then {_channel = toUpper _channel};

		_data = _data param [2, [], [[]]];
		private _mission = _data param [0, "", [""]];
		private _topic = _data param [1, "", [""]];

		_showSubtitles = [missionnamespace,"BIS_fnc_kbTellLocal_played",[_from,_to,_sentence,_channel],true] call bis_fnc_callScriptedEventHandler;
		_showSubtitles = _showSubtitles param [0,false,[false]];

		if (_channel in ["DIRECT", "VEHICLE"] || _showSubtitles || (hasInterface && { "ItemRadio" in (assignedItems player) })) then
		{
			// Search for disconnected subtitles, play if necessary
			private _text = getText (configFile >> "CfgSentences" >> _mission >> _topic >> "Sentences" >> _sentence >> "textPlain");
			if (_text != "") then {[_from getvariable ["bis_fnc_kbTellLocal_name",name _from], _text] call BIS_fnc_showSubtitle;};
		};
	};

	case "conversationStart": {
		private ["_volumeCoef", "_disableRadio"];
		_volumeCoef = _this select 0;
		_disableRadio = _this select 1;

		//--- Disable radio protocol
		if (hasInterface && { _disableRadio }) then
		{
			enablesentences false;
		};

		//--- Decrease music and sound volume
		if (_volumeCoef >= 0 && isnil "BIS_fnc_kbTellLocal_volumeSound") then {
			BIS_fnc_kbTellLocal_volumeSound = soundvolume;
			BIS_fnc_kbTellLocal_volumeMusic = musicvolume;
			if (_volumeCoef >= 0 && _volumeCoef < 1) then {
				0.5 fadesound (BIS_fnc_kbTellLocal_volumeSound * _volumeCoef);
				0.5 fademusic (BIS_fnc_kbTellLocal_volumeMusic * _volumeCoef);
			};
		};
	};
	case "conversationEnd": {
		private ["_volumeCoef", "_disableRadio"];
		_volumeCoef = _this select 0;
		_disableRadio = _this select 1;

		//--- Enable radio protocol
		if (hasInterface && { _disableRadio }) then
		{
			enablesentences true;
		};

		//--- Return music and sound volume to original values
		if (_volumeCoef >= 0 && _volumeCoef < 1) then {
			0.5 fadesound (missionnamespace getvariable ["BIS_fnc_kbTellLocal_volumeSound",1]);
			0.5 fademusic (missionnamespace getvariable ["BIS_fnc_kbTellLocal_volumeMusic",1]);
		};
		BIS_fnc_kbTellLocal_volumeSound = nil;
		BIS_fnc_kbTellLocal_volumeMusic = nil;
	};
	default {["'%1' is not a valid section"] call bis_fnc_error};
};