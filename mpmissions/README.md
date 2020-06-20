Important note:  
I modify some of theses mission on a daily basis, this repo can be a bit outdated.  
All of missions on this repo have debug features enable, test these missions with friends.

## EscapeFromMaldenMOD.Malden  
This mission is based on the original "Escape from Malden" mission.  
  
![](https://github.com/porcinus/Arma-3/blob/master/mpmissions/EscapeFromMaldenMOD.Malden%20preview/checkpoint0.jpg|width=100)

  
WIP, work but many things need to be redone the right way.  
  
My main idea is to allow me and a group of friends to really enjoy this mission.  
To be honest, I didn't keep track of codes coming from internet and I am pretty sure some stuff may need some credits.  
  
What's done so far (missing some for sure):
```
- Additional options on mission selection:
	- Better equipment (ENVG-II, Nightstalker, GPS for everyone).
	- Increased enemy count (Add a tower to each city, allow vehicle spawn 2 units).
	- Custom Escape rules: Original or Permissive (don't loss if everyone is dead, initial respawn trigger remain).
	- Additional objectives.

- Regarding the original stuff (little modifications/full rework).
	- Win condition: original had a glitch where you can in some case win if a unit is in a helicopter and its destroyed.
	- Enemy patrol spawn: any spawned group (not including vehicle patrol) are killed if all players distance > 1.8km, recreate trigger when this happen.
	- Empty group cleanup script: now work, original can't.
	- Populate city/triggers: condition now work fine (regarding distances), every spawning stuff moved to associate script, player warned when approaching city/checkpoint.
	- Special events: mortar disabled.
	- Removed Tanoa specific stuff.

- Added:
	- Additional objectives (not need to complete the escape mission): Eliminate unit (x2), Clean checkpoint (x3), Explore old base (x2), Collect intel (x2), Power station sabotage (x1).
	- Added Special events: 
		- Orca CAS (ported from Escape from Tanoa)
		- Huron landing, paradrop is no suitable position found (can glitch a bit, work for most).
	- FIA friendly patrols that stalk enemy patrols.
	- AA soldiers added to each patrol (NATO/FIA).
	- Player group added units: Missile Specialist (AA), Missile Specialist (AC), Heavy Gunner.
	- If better equipment option selected: Allow player to respawn with their previous equipment, icon on previous corpse, icon on incapacitated friendly.
	- Random position for original checkpoint: the one near airport don't move, the others have 2/3 positions possible.
	- Two additional big checkpoints around "Le Port" and one near Goisse (depend on optional objectives).
	- A military base on South West corner: possible escape position.
	- Power station in "La Rivière" (depend on optional objectives).
	- "Random" initial respawn position.
	- End mission statistics tab: 
		- For each player: Fire shots (bullet, HE, smoke, rocket, vehicle), distance travelled (foot, vehicle), longest kill (incl weapon name), friendly kills.
		- For group: cumulative fire shots (bullet, HE, smoke, rocket ,vehicle), longest kill (incl player name), friendly kills (incl player name).

- Specific stuff:
	- If optional objectives enabled: All checkpoint markers are hidden.
	- Regarding Intel mission(s):
		- Some intel collected reveal checkpoint markers, another create a CSAT squad rescue objective that lead to the group following your team and possibility to meet a Sniper team if success.
		- Whiteboard on-site to draw on, yes super fancy, work only locally, mouse left button to draw.
	- Regarding Power Station sabotage mission:
		- Shutdown all light on the island.
		- Highly reduce AI ability to spot your team in cities/base/airport, do not affect recon/sniper squad.
	- When respawn, player is teleported in a radius of 50m to limit risk of successive die if stuck in a ambush.
	
- What still need to be done:
	- Increase overall performance.
	- Disable if possible the noise effect when end of mission occurs (not sure it is possible).
	- You tell me :P
```

## EscapeFromMaldenZombie.Malden




