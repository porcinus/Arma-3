### Important note:  
- I modify some of theses mission on a daily basis, this repo can be a bit outdated.  
- All of missions on this repo have: 
  - Debug features enabled.  
  - AI enabled, AI units are removed once the server start. I use this trick to bypass JIP glitch that disallow player from joining when mission started (some time not work, depend on clients).  
- Not tested on dedicated server.  
- Some missions share functions or scripts, this doesn't mean all are sync (uptodate).  
  
## EscapeFromMaldenMOD.Malden  
This mission is based on the original "Escape from Malden" mission.  
English and French localized for added elements.  
  
[![prev](EscapeFromMaldenMOD.Malden%20preview/preview/main.jpg)](EscapeFromMaldenMOD.Malden%20preview/main.jpg)
[![prev](EscapeFromMaldenMOD.Malden%20preview/preview/checkpoint0.jpg)](EscapeFromMaldenMOD.Malden%20preview/checkpoint0.jpg)
[![prev](EscapeFromMaldenMOD.Malden%20preview/preview/checkpoint1.jpg)](EscapeFromMaldenMOD.Malden%20preview/checkpoint1.jpg)
[![prev](EscapeFromMaldenMOD.Malden%20preview/preview/eliminate.jpg)](EscapeFromMaldenMOD.Malden%20preview/eliminate.jpg)
[![prev](EscapeFromMaldenMOD.Malden%20preview/preview/explore-old-base.jpg)](EscapeFromMaldenMOD.Malden%20preview/explore-old-base.jpg)
[![prev](EscapeFromMaldenMOD.Malden%20preview/preview/intel0.jpg)](EscapeFromMaldenMOD.Malden%20preview/intel0.jpg)
[![prev](EscapeFromMaldenMOD.Malden%20preview/preview/intel1.jpg)](EscapeFromMaldenMOD.Malden%20preview/intel1.jpg)
[![prev](EscapeFromMaldenMOD.Malden%20preview/preview/rescue.jpg)](EscapeFromMaldenMOD.Malden%20preview/rescue.jpg)
[![prev](EscapeFromMaldenMOD.Malden%20preview/preview/south-west-base.jpg)](EscapeFromMaldenMOD.Malden%20preview/south-west-base.jpg)
[![prev](EscapeFromMaldenMOD.Malden%20preview/preview/whiteboard.jpg)](EscapeFromMaldenMOD.Malden%20preview/whiteboard.jpg)
  
WIP, work but many things need to be redone the right way. I started this modification while lacking a lot of knowledge about ArmA scripting. Don't look at scripts, you will tear blood...
  
My main idea is to allow me and a group of friends to really enjoy this mission.  
To be honest, I didn't keep track of codes coming from internet and I am pretty sure some stuff may need some credits.  
  
What's done so far (missing some for sure):
```
- Additional options on mission selection:
	- Better equipment (ENVG-II, Nightstalker, GPS for everyone), allow change of class during gameplay.
	- Increased enemy count (Add a tower to each city, allow vehicle spawn 2 units).
	- Custom Escape rules: Original or Permissive (don't loss if everyone is dead, initial respawn trigger remain).
	- Additional objectives.
	- Punish teamkillers: kill teamkillers when become renegade, should not affect team tickets.

- Regarding the original stuff (little modifications/full rework):
	- Win condition: original had a glitch where you can in some case win if a unit is in a helicopter and vehicle is destroyed.
	- Allow server to disable tickets in parameters.
	- Enemy patrol spawn: any spawned group (not including vehicle patrol) are killed if all players distance > 1.8km, recreate trigger when this happen.
	- Empty group cleanup script: now work, original can't.
	- Populate city/triggers: condition now work fine (regarding distances), every spawning stuff moved to associate script, player warned when approaching city/checkpoint.
	- Special events: mortar disabled.
	- Removed Tanoa specific stuff.
	- Rework loadout: one per class, limited with a script afterward.

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
	- End mission statistics tab (Partial data in Map): 
		- For each player: Fire shots (bullet, HE, smoke, rocket, vehicle), distance travelled (foot, vehicle), longest kill (incl weapon name), friendly kills.
		- For group: cumulative fire shots (bullet, HE, smoke, rocket ,vehicle), longest kill (incl player name), friendly kills (incl player name).
		- Server will try to backup/restore player stats if player disconnected/crashed and reconnect.

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
	- You tell me :P
```
  
## EscapeFromMaldenZombie.Malden  
This mission is based on "EscapeFromMaldenMOD" mission.  
English and French localized.  
  
Require Ryan's Zombies and Demons addon (https://steamcommunity.com/sharedfiles/filedetails/?id=501966277).  
Enhanced Movement addon is recommended (https://steamcommunity.com/sharedfiles/filedetails/?id=333310405).  
  
[![prev](EscapeFromMaldenZombie.Malden%20preview/preview/main.jpg)](EscapeFromMaldenZombie.Malden%20preview/main.jpg)
[![prev](EscapeFromMaldenZombie.Malden%20preview/preview/map.jpg)](EscapeFromMaldenZombie.Malden%20preview/map.jpg)
[![prev](EscapeFromMaldenZombie.Malden%20preview/preview/checkpoint1.jpg)](EscapeFromMaldenZombie.Malden%20preview/checkpoint1.jpg)
[![prev](EscapeFromMaldenZombie.Malden%20preview/preview/northeastbase.jpg)](EscapeFromMaldenZombie.Malden%20preview/northeastbase.jpg)
[![prev](EscapeFromMaldenZombie.Malden%20preview/preview/southwestbase.jpg)](EscapeFromMaldenZombie.Malden%20preview/southwestbase.jpg)
[![prev](EscapeFromMaldenZombie.Malden%20preview/preview/startheli.jpg)](EscapeFromMaldenZombie.Malden%20preview/startheli.jpg)
[![prev](EscapeFromMaldenZombie.Malden%20preview/preview/city-fire.jpg)](EscapeFromMaldenZombie.Malden%20preview/city-fire.jpg)
[![prev](EscapeFromMaldenZombie.Malden%20preview/preview/jerrycan1.jpg)](EscapeFromMaldenZombie.Malden%20preview/jerrycan1.jpg)
[![prev](EscapeFromMaldenZombie.Malden%20preview/preview/jerrycan2.jpg)](EscapeFromMaldenZombie.Malden%20preview/jerrycan2.jpg)
  
It still is a escape mission but now with zombies.  
To be honest, I didn't keep track of codes coming from internet and I am pretty sure some stuff may need some credits.  
  
WIP, some things still need to be done but look stable for now.  
Some locality problem can happen when a zombie hit a vehicle. Sadly, this problem is related to Ryan's Zombies and Demons addon and can't be fixed by me.  
  
What's done so far (missing some for sure):  
```
- Random initial spawn location (more than 5 possible).
- Track player stats : ammo fired (incl grenades and other stuff), distance traveled (foot and vehicle), accessible from map and defriening.
- All military units/vehicles converted to CSAT
- All fuel stations are empty but you can found jerrycan. this will allow you to drain fuel from vehicles tank.
- Some CSAT patrol can be found on the map.
- All vehicles on the map are damaged and have low fuel tank level.
- Renegade punishment by Zeus hand.

- Mission parameters:
	- Respawn: allow server to set to infinite.
	- Rules: original escape rules (everybody dead = failed) and permissive.
	- Zombies amount : 50%, 100%, 150%.
	- Ammobox contain : 25%, 50%, 75%, 100%.
	- Stamina : enable or disable.
	- Punish teamkillers: kill teamkillers when become renegade, should not affect team tickets.

- Cities:
	- Some buildings are destroyed, if so, there is a chance of big fire.
	- Some garages can have a civilian vehicle in, jerrycan can be here as well.
	- Random level of infection for some cities.
	
- Ambiance: 
	- Weird noise spawn some time to stress players (no jump scare).
	- Lamps can sometime flicker with noise.
	
- Looting:
	- Ammo, weapons and equipements can be found in buildings like cargo tower and HQ.
	- When looting a soldier zombie, there is a change to add a marker on the map for loot point.
	- Player can drain or refill vehicle tank when have a jerrycan (inventory screen), can drain tank on refueler

- Workaround:
	- Zombies addon can create locality problem, when player enter or get out vehicle, light are repared or destroyed to avoid binking effect (sometime work, sometime not).
	- Refuel of escape vehicles : additional function to force addition of fuel when refueler nearby.
	- Friendly AI is dumb : a script is used to limit damage (no inclure one shot) from friendly AI.

- Inventory:
	- Restore previous loadout when respawn, refill primary weapon magazine to 25 rounds.
	- Jerrycan contain visible from inventory screen when have a jerrycan.

- Other:
	- Server will try to backup/restore player stats if player disconnected/crashed and reconnect.

- What still need to be done: You tell me :P
```
  
## EscapeFromTanoaMOD.Tanoa  
This mission is based on the original "Escape from Malden" mission.  
I haven't decided so far if major modification like sub-missions will be added for this mission.  
English and French localized for added elements.  
  
[![prev](EscapeFromTanoaMOD.Tanoa%20preview/preview/main.jpg)](EscapeFromTanoaMOD.Tanoa%20preview/main.jpg)
[![prev](EscapeFromTanoaMOD.Tanoa%20preview/preview/stats-map.jpg)](EscapeFromTanoaMOD.Tanoa%20preview/stats-map.jpg)
[![prev](EscapeFromTanoaMOD.Tanoa%20preview/preview/stats-debrief.jpg)](EscapeFromTanoaMOD.Tanoa%20preview/stats-debrief.jpg)
  
My main idea is to allow me and a group of friends to really enjoy this mission.  
  
WIP, some things still need to be done but look stable for now.  
During test, game sometime crashed on multiple client when enemy vehicule spawned (can be because of Memory Allocation setting in launcher).  
  
What's done so far (may miss some for sure):
```
- Additional options on mission selection:
	- Better equipment (ENVG-II, Nightstalker, GPS for everyone), allow change of class during gameplay.
	- Custom Escape rules: Original or Permissive (don't loss if everyone is dead, initial respawn trigger remain).
	- Increase enemy amount: Normal, +2 or +4 units per squad (not apply to Viper).
	- Possibility to disable stamina.
	- Punish teamkillers: kill teamkillers when become renegade, should not affect team tickets.

- Regarding the original stuff (little modifications/full rework):
	- Win condition: original had a glitch where you can in some case win if a unit is in a helicopter and vehicle is destroyed.
	- Allow server to disable tickets in parameters.
	- Empty group cleanup script: full rework.
	- Enemy patrol spawn: any spawned group (not including vehicle patrol) are killed if all players distance > 1.3km, recreate trigger when this happen.
	- Special events: mortar disabled.
	- Rework loadout: one per class, limited with a script afterward.

- Added:
	- If standard equipment option selected: Allow player to respawn with their previous equipment.
	- End mission statistics tab (Partial data in Map): 
		- For each player: Fire shots (bullet, HE, smoke, rocket, vehicle), distance travelled (foot, vehicle), longest kill (incl weapon name), friendly kills.
		- For group: cumulative fire shots (bullet, HE, smoke, rocket ,vehicle), longest kill (incl player name), friendly kills (incl player name).
		- Server will try to backup/restore player stats if player disconnected/crashed and reconnect.

- Specific stuff:
	- When respawn, player is teleported in a radius of 50m to limit risk of successive die if stuck in a ambush.
	
- What still need to be done:
	- You tell me :P
```
  
## NNS-Sandbox.Malden  
Well, as its name suggest, it is a "sandbox", I mainly use it to test new functions/scripts.  
Can be useful to understand how specific functions like 'spawnVehicleOnRoad_Adv' work.  
  
[![prev](NNS-Sandbox.Malden%20preview/preview/map01.jpg)](NNS-Sandbox.Malden%20preview/map01.jpg)
[![prev](NNS-Sandbox.Malden%20preview/preview/eden-main01.jpg)](NNS-Sandbox.Malden%20preview/eden-main01.jpg)
[![prev](NNS-Sandbox.Malden%20preview/preview/eden-main02.jpg)](NNS-Sandbox.Malden%20preview/eden-main02.jpg)
[![prev](NNS-Sandbox.Malden%20preview/preview/main02.jpg)](NNS-Sandbox.Malden%20preview/main02.jpg)
[![prev](NNS-Sandbox.Malden%20preview/preview/destroyzone01.jpg)](NNS-Sandbox.Malden%20preview/destroyzone01.jpg)
[![prev](NNS-Sandbox.Malden%20preview/preview/eden-patrolVeh.jpg)](NNS-Sandbox.Malden%20preview/eden-patrolVeh.jpg)
[![prev](NNS-Sandbox.Malden%20preview/preview/eden-spawnvehionroad01.jpg)](NNS-Sandbox.Malden%20preview/eden-spawnvehionroad01.jpg)
[![prev](NNS-Sandbox.Malden%20preview/preview/map-spawnvehionroad01.jpg)](NNS-Sandbox.Malden%20preview/map-spawnvehionroad01.jpg)
[![prev](NNS-Sandbox.Malden%20preview/preview/spawnvehionroad01.jpg)](NNS-Sandbox.Malden%20preview/spawnvehionroad01.jpg)
[![prev](NNS-Sandbox.Malden%20preview/preview/helisupportlanding01.jpg)](NNS-Sandbox.Malden%20preview/helisupportlanding01.jpg)
  
```
What's done so far (missing some for sure):

- Additional options on mission selection:
	- Better equipment: allow change of class during gameplay.
	- Limit enemy amount.
	- Custom Escape rules: Original or Permissive (don't loss if everyone is dead, initial respawn trigger remain).
	- Possibility to disable stamina.
	- Punish teamkillers: kill teamkillers when become renegade, should not affect team tickets.
	- Respawn: allow server to set to infinite.
	- Ammobox contain : 25%, 50%, 75%, 100%.
	- Limit AI skill: Novice (0.25), Normal (0.50), Expert (0.75)
	- Debug options.

- General:
	- Win condition: original had a glitch where you can in some case win if a unit is in a helicopter and vehicle is destroyed.
	- Trigger based spawning units (like Escape from Malden/Tanoa):
		- Partially based on Vasek work on its missions:
			- Allow big scalability: edit one line and adding 7 lines of code in initServer.sqf allow to add support for a full faction.
			- Downside of this scalability: big memory use for this feature (so far).
		- Any spawned group (not including vehicle patrol) are killed if all players distance > 1.5km and recreate trigger when this happen. This allow server to free useless groups.
		- Enemy patrol can stalk you and friendly patrol can stalk enemy units (35% chance).
	- Empty group cleanup script: Clean units, groups, vehicles > 1.5km from players (not include Air kind).
	- End mission statistics tab (Partial data in Map): 
		- For each player: Fire shots (bullet, HE, smoke, rocket, vehicle), distance travelled (foot, vehicle), longest kill (incl weapon name), friendly kills.
		- For group: cumulative fire shots (bullet, HE, smoke, rocket ,vehicle), longest kill (incl player name), friendly kills (incl player name).
		- Server will try to backup/restore player stats if player disconnected/crashed and reconnect.
	- When respawn, player is teleported in a radius of 50m to limit risk of successive die if stuck in a ambush.
	- All fuel stations are empty but you can found jerrycan. this will allow you to drain fuel from vehicles tank.
	- Renegades punishment by Zeus hand.
	- Friendly AI is dumb : a script is used to limit damage (no inclure one shot) from friendly AI.
	- Server will try to backup/restore player stats if player disconnected/crashed and reconnect.
	- Lamps can sometime flicker with noise.
	- Drawable whiteboard, work only locally, mouse left button to draw.
	- Helicopter airborne units support:
		- Allow deployment of AI units on field.
		- High scalability:
			- Allow usage of most helicopter (need cargo field in config) / group class / side.
			- Can work in any way: side specific vehicle with enemy side units.
			- Can join wanted group is same side, otherwise with stalk player group (enemy or ally).
		- Land if valid position found, paradrop if not.

- Inventory:
	- When respawn with previous loadout, refill primary weapon magazine to 25 rounds.
	- Jerrycan contain is visible in inventory screen when player have a jerrycan.

- What still need to be done: You tell me :P
```

