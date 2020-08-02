//--- Play hint for beginners who haven't played Arma properly yet
if (
	(uinamespace getvariable ["BIS_Orange_showBeginnerHints",false]) //--- Debug
	||
	{
		getStatValue "BCFirstDeployment" == 0 //--- Haven't finished Bootcamp campaign
		&&
		{
			getStatValue "CompletedEPA" == 0 //--- Haven't finished EPA
			&&
			{((getStatValue "SPPlayTime" + getStatValue "MPPlayTime") / 3600) < 6} //--- Total SP time in hours is lower than 6 hours
		}
	}
) then {
	_this call bis_fnc_advHint;
};