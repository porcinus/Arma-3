if (isServer) then
{
	_enemyEquipment = param [0,1,[999]];

	If (_enemyEquipment == 0) Then {missionNamespace setVariable ["BIS_enemyEquipment",0]};
	If (_enemyEquipment == 1) Then {missionNamespace setVariable ["BIS_enemyEquipment",1]};
};
