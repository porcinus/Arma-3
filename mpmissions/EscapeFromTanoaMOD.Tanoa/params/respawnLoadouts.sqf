if (isServer) then
{
	_respawnLoadouts = param [0,1,[999]];

	If (_respawnLoadouts == 0) Then
	{
                BIS_loadoutLevel = 0;
		publicVariable "BIS_loadoutLevel";
	};
	If (_respawnLoadouts == 1) Then
	{
                BIS_loadoutLevel = 1;
		publicVariable "BIS_loadoutLevel";
	};
	If (_respawnLoadouts == 2) Then
	{
                BIS_loadoutLevel = 2;
		publicVariable "BIS_loadoutLevel";
	};
};
