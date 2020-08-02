private
[
	"_path",
	"_br",
	"_result",
	"_resultText",
	"_resultCount"
];

startLoadingScreen [""];

_path = _this param [0, configFile >> "cfgVehicles", [configFile]];
_pathText = toUpper configName _path;
_br = toString [13,10];

_result = [];
{
	_result = _result + [format ["#define %1_AUTHOR_%2	author = $STR_A3_Bohemia_Interactive;", _pathText, configName _x]];
} forEach (_path call bis_fnc_returnChildren);

_result = _result call BIS_fnc_sortAlphabetically;

_resultCount = ((count(_result) - 1) max 1);

_resultText = "";
{
	_resultText = _resultText + _x + _br;
	progressLoadingScreen ((_forEachIndex * _forEachIndex) / (_resultCount * _resultCount));
} forEach _result;

copyToClipboard _resultText;
endLoadingScreen;
hint "Finished diagMacrosAuthor";
_resultText