while {true} do
{
	{if ((side _x in [east,resistance]) and {((count units _x) == 0)}) then {deleteGroup _x}} forEach (allGroups - [BIS_grpMain]);
	sleep 30;
};
