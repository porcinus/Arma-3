"Attempt to unlock achievement ExpNoneTheWiser started" call BIS_fnc_log;

if (getStatValue "ExpNoneTheWiser" == 0) then
{
	setStatValue ["ExpNoneTheWiser", 1];
	"Achievement successfully unlocked (ExpNoneTheWiser)" call BIS_fnc_log;
}
else
{
	"Achievement (ExpNoneTheWiser) already unlocked" call BIS_fnc_log;
};