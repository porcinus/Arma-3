params["","","","","","","_sh"];
private _p = getpos _sh;
_p params ["_pX","_pY","_pZ"];

drop [["\A3\data_f\ParticleEffects\Universal\Universal",16,2,32], "", "Billboard", 1,(0.1 + random 0.1),
[0, -1.3,0],
[0, -2, 0], 0, 10, 7.9, 0.075, [1,3],
[[1, 1, 1, -2], [1, 1, 1, -2],
[1, 1, 1, -1], [1, 0.5, 1, -0]],
[5], 1, 0, "", "", _sh];

private _col = [[0.7,0.7,0.7,0],[0.7,0.7,0.7,0.5],[0.7,0.7,0.7,0.4],[0.8,0.8,0.8,0.3],[0.9,0.9,0.9,0.15], [1,1,1,0]];

for "_i" from 0 to (5 + random 3) do
{
	drop [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 7, 48], "", "Billboard", 1, 1.5, [0, - 1.3, 0],
	[-0.2+random 0.2,-0.6*_i + random 0.5,-0.2+random 0.2], 1, 1, 0.80, 0.4, [0.4,(0.8*_i)+random 0.2],_col,[2,0.7,0.5],0.1,0.1,"","",_sh];
};

// ["JmenoModelu"],"NazevAnimace","TypAnimace",RychlostAnimace,DobaZivota,[Pozice],[SilaPohybu],Rotace,Hmotnost,Objem,Rubbing,[Velikost],[Barva],
// [FazeAnimace],PeriodaNahodnehoSmeru,IntensitaNahodnehoSmeru,"OnTimer","PredZnicenim","Objekt";

if ((abs _pZ < 2) and !(surfaceIsWater _p)) then
{
	private _vec = vectordir _sh;
	_vec params ["_vecX","_vecY","_vecZ"];

	for "_i" from 0 to (19 + random 7) do
	{
		drop [["\A3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 12, 13, 0], "", "Billboard", 1, 7,
		[_pX, _pY, 0], [-(_vecX -0.5 +(random 1))*4,
		-(_vecY -0.5 +(random 1))*4, 0.3 + random 0.3],
		0, 0.104, 0.08, 0.04, [2,4], [[0.6, 0.5, 0.4, 0],[0.6, 0.5, 0.4, 0.4], [0.6, 0.5, 0.4, 0.2],
		[0.6, 0.5, 0.4, 0]], [1000], 1, 0, "", "", ""];
	};
};