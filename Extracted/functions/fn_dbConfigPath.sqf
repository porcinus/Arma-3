private ["_path","_config"];

_path =		_this param [0,[],[[]]];
_config =	_this param [1,configfile >> "CfgBase",[configfile]];
{
	_config = _config >> _x;
} foreach _path;

_config