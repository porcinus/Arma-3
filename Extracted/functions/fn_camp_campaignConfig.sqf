/*
	Author: Jiri Wainar

	Description:
	Returns cfg to the campaign config.

	Example:
	[] call BIS_fnc_camp_campaignConfig;
*/

private["_config"];

_config = if (isclass (campaignconfigfile >> "campaign")) then
{
	campaignconfigfile
}
else
{
	if (isclass (missionconfigfile >> "hubs")) then
	{
		//configfile >> "CfgMissions" >> "Campaigns" >> "RootCampaign" >> _stage
		configfile >> "CfgMissions" >> "Campaigns" >> "EastWind"
	}
	else
	{
		configfile
	};
};

_config