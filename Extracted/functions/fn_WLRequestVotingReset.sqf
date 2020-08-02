/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Voting reset routine.
*/

player setVariable ["BIS_WL_funds", (player getVariable "BIS_WL_funds") - BIS_WL_votingResetCost, TRUE];

missionNamespace setVariable [format ["BIS_WL_sectorVotingReset_%1", side group player], TRUE, TRUE];
missionNamespace setVariable [format ["BIS_WL_sectorVotingResetName_%1", side group player], name player, TRUE];