// Campaign common includes
#include "\A3\Missions_F_Exp\Campaign\commonDefines.inc"

// Parameters
private _boss = _this param [0, objNull, [objNull]];

// Validate boss object
if (isNull _boss) exitWith
{
	"fn_getBossIntel: Provided _boss object is NULL" call BIS_fnc_error;
	objNull;
};

// Return the intel associated with this boss
_boss getVariable ["BIS_coop_campaign_m07_bossObjective", objNull];