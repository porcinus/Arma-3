private ["_logic","_units","_rating","_score"];

_logic = _this param [0,objnull,[objnull]];
_units = _this param [1,[],[[]]];
_activated = _this param [2,true,[true]];

if (_activated) then {

	//--- Extract the user defined module arguments
	_rating = _logic getvariable ["rating",0];
	_score = _logic getvariable ["score",0];

	[_units,_rating,_score] spawn {
		if (isMultiPlayer) then sleep 0.5; //<----------------- initialization of MP is slow, without it addScore does not work
		_units = _this select 0;
		_rating = _this select 1;
		_score = _this select 2;	
		{
			_x addRating _rating;
			_x addScore _score;	
		} foreach _units;
	};
};

true