"Attempt to unlock achievement ExpFastExtract started" call BIS_fnc_log;

if (getStatValue "ExpFastExtract" == 0) then
{
	setStatValue ["ExpFastExtract", 1];
	"Achievement successfully unlocked (ExpFastExtract)" call BIS_fnc_log;
}
else
{
	"Achievement (ExpFastExtract) already unlocked" call BIS_fnc_log;
};