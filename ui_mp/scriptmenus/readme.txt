----------------------------------------

          BLACK OPS PLUTONIUM                 
          MULTIPLAYER MAPVOTE

        Developed by @DoktorSAS
        
----------------------------------------

 × Requirements
 × How to setup the mapvote step by step
 × How to add custom maps to the mapvote list

----------------------------------------

 × Requirements

   1) The script works only on Plutonium client.

----------------------------------------

 × How to setup the mapvote step by step

 1) Compile the mod with the zonetool 
 2) Copy the Compiled mod.ff file in your Directory %localappdata%\Plutonium\storage\t5\mods\YOURMODNAME (Exemple: ..\mods\mp_mapvote, ..\mods\funserver)
 3) Create the .iwd file with .iwi images in the images folder and put in in your Directory %localappdata%\Plutonium\storage\iw5\mods\YOURMODNAME (Exemple: ..\mods\mp_mapvote, ..\mods\funserver)
 4) Copy the Content of the mapvote.cfg in your .cfg (Exemple: server.cfg, dedicated_mp.cfg, dedicated.cfg, etc ) file that manages the Server.
 5) Edit the Dvars to setup the Server, many Dvars are only for Aesthetic Parameters.
    set the Dvar mv_maps to decide the maps that will be shown in mapvote, Example:
        set mv_maps "mp_array mp_cracked mp_crisis mp_firingrange mp_duga mp_hanoi mp_cairo mp_havoc mp_cosmodrome mp_nuked mp_radiation mp_mountain mp_villa mp_russianbase"
    set the dvar mv_enable to 1 if you want have it active on your server.
    If you want random gametypes you have to set the dvar mv_gametypefiles specifying the gametype .cfg file name. Exemple:
        set mv_gametypefiles "mycustomd@mycustomtdm@SD_default@"
    to specify the gamemode name you need also to the fine the gamemode name by editing the dvar mv_gametypenames
        set mv_gametypenames "dm@tdm@sd@"
    mv_gametypefiles and mv_gametypes must have the same number of @ symbols. The elements on mv_gametypefiles 
    are linked to the element in mv_gametypes
 6) Copy the mapvote.gsc and put it %localappdata%\Plutonium\storage\t5\scripts\
 7) Run the Server and have fun. Done!

----------------------------------------

  × How to add custom maps to the mapvote list

  1) Create a new material file for the preview [Not mandatory]
  2) Add the preview iwi file in the mapvote.iwd [if you want use the custom preview is mandatory]
  3) Edit the case in the getmapname function in mapvote.gsc to add the conversion from mp_mapname to MAPNAME (Like mp_minecraft -> MINECRAFT)
  3) Rebuild the mod with the Black ops mod tool
  4) Put the mod.ff and the mp_mapvote.iwd in your mods/modfolder (Like mods/mp_mapvote) in your %localappdata%\Plutonium\storage\t5\mods\    
