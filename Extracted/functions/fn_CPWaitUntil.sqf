/*
	Author: Josef Zemanek

	Description:
	Combat Patrol optimized waitUntil, no need to call it every frame sometimes
*/

params [
	["_condition", {TRUE}, [{}]],
	["_tmout", 0.5, [0]]
];

while {!call _condition} do {
	sleep _tmout;
};