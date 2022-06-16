# Plutonium T5 Mapvote
Developed by [@DoktorSAS](https://twitter.com/DoktorSAS)

 - [Requirements](#requirements)
 - [How to setup the mapvote step by step](#how-to-setup-the-mapvote-step-by-step)
 - [How to add custom maps to the mapvote list](#how-to-add-custom-maps-to-the-mapvote-list)

### Preview
[![preview](https://pbs.twimg.com/media/FU1ygnhWYAEXUfP?format=jpg&name=large)](https://www.youtube.com/watch?v=UquGVnZljdc)


### Requirements

- The script can only run on Server, It will not work in private games.
- Server must be hosted on Plutonium client, the script works only on Plutonium client.


### How to setup the mapvote step by step

 1) Copy the Compiled mod.ff file in your Directory %localappdata%\Plutonium\storage\t5\mods\YOURMODNAME (Exemple: ..\mods\mp_mapvote, ..\mods\funserver)
 2) Create the .iwd file with .iwi images in the images folder and put in in your Directory %localappdata%\Plutonium\storage\iw5\mods\YOURMODNAME (Exemple: ..\mods\mp_mapvote, ..\mods\funserver)
 3) Copy the Content of the mapvote.cfg in your .cfg (Exemple: server.cfg, dedicated_mp.cfg, dedicated.cfg, etc ) file that manages the Server.
 4) Edit the Dvars to setup the Server, many Dvars are only for Aesthetic Parameters.
    - set the Dvar mv_maps to decide the maps that will be shown in mapvote, Example:
        - set mv_maps "mp_array mp_cracked mp_crisis mp_firingrange mp_duga mp_hanoi mp_cairo mp_havoc mp_cosmodrome mp_nuked mp_radiation mp_mountain mp_villa mp_russianbase"
    - set the dvar mv_enable to 1 if you want have it active on your server.
    - If you want random gametypes you have to set the dvar mv_gametypefiles specifying the gametype .cfg file name. Exemple:
        - set mv_gametypes "@@"
    - to specify the gamemode name you need also to the fine the gamemode name by editing the dvar mv_gametypenames
        - set mv_gametypenames "dm@tdm@sd"
    
    mv_gametypefiles and mv_gametypes must have the same number of @ symbols. The elements on mv_gametypefiles  
    are linked to the element in mv_gametypenames
 5) Copy the mapvote.gsc and put it %localappdata%\Plutonium\storage\iw5\scripts\
 6) Run the Server and have fun. Done!

## How to add custom maps to the mapvote list
  1) Create a new material file for the preview [Not mandatory]
  2) Add the preview iwi file in the mapvote.iwd [if you want use the custom preview is mandatory]
  3) Edit the case in the getmapname function in mapvote.gsc to add the conversion from mp_mapname to MAPNAME (Like mp_minecraft -> MINECRAFT)
  3) Rebuild the mod with the Black ops mod tool
  4) Put the mod.ff and the mp_mapvote.iwd in your mods/modfolder (Like mods/mp_mapvote) in your %localappdata%\Plutonium\storage\t5\mods\    
