{_x hideobject true; _x enablesimulation false;} foreach (getMissionLayerEntities "N1_PreSpooky" select 0);
{_x hideobject false; _x enablesimulation true;} foreach (getMissionLayerEntities "N1_PostSpooky" select 0);
private _playSound = bis_hauntedHause == 0;
bis_hauntedHause = 1;
if (_playSound) then {
	playsound3d ["A3\Sounds_F\environment\animals\scared_animal1.wss",objnull,false,agltoasl [4505,21445,0],0.4];
	sleep 0.4;
	playsound3d ["A3\Sounds_F\environment\animals\scared_animal2.wss",objnull,false,agltoasl [4505,21445,0],0.4];
};