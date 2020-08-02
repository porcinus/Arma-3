params [
	["_area",objnull,[objnull,"",[],locationNull]],
	["_speech","",[""]],
	["_text","",[""]]
];

private _areaData = _area call bis_fnc_getArea;

_loc = createlocation ["Invisible",_areaData select 0,_areaData select 1,_areaData select 2];
_loc setdirection (_areaData select 3);
_loc setspeech _speech;
_loc setText _text;
_loc