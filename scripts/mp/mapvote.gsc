#include common_scripts\utility;
#include maps\mp\_utility;
#include scripts\mp\utils;

/*
    Plutonium T5 Mapvote
    Developed by DoktorSAS
    set mv_enable 1 // Enable/Disable the mapvote
    
    set mv_maps "mp_array mp_cracked mp_crisis mp_firingrange mp_duga mp_hanoi mp_cairo mp_havoc mp_cosmodrome mp_nuked mp_radiation mp_mountain mp_villa mp_russianbase" // Lits of maps that can be voted on the mapvote, leave empty for all maps
    set mv_time 20 // Time to vote
    set mv_randomgametypeenable 0 // Enable/Disable random gametypes
    set mv_gametypefiles "@@" // Gametypes cfg configuration filenames
    set mv_gametypes "dm@tdm@sd"  // Gametypes ui names
*/

init()
{	
    game["mapvote"] = "mapvote";
    preCacheMenu(game["mapvote"]);

    setDvarIfNotInizialized("mv_enable", 1);
    if(!getDvarInt("mv_enable"))
        return;
    print("Mapvote loaded...");
    print("Developed by @DoktorSAS");

    level.map_winner = "";

    SetDvarIfNotInizialized("votetime", "00:00");
    SetDvarIfNotInizialized("mv_time", "20");
    // NO DLC
    SetDvarIfNotInizialized("mv_maps", "mp_array mp_cracked mp_crisis mp_firingrange mp_duga mp_hanoi mp_cairo mp_havoc mp_cosmodrome mp_nuked mp_radiation mp_mountain mp_villa mp_russianbase");
    
    // DLC ONLY
    //SetDvarIfNotInizialized("mv_maps", "mp_berlinwall2 mp_discovery mp_kowloon mp_stadium mp_gridlock mp_hotel mp_outskirts mp_zoo mp_drivein mp_area51 mp_golfcourse mp_silo");
    
    SetDvarIfNotInizialized("mv_gametypefiles", "@@");
    SetDvarIfNotInizialized("mv_gametypes", "dm@sd@tdm");
    SetDvarIfNotInizialized("mv_randomgametypeenable", 1);

    SetDvarIfNotInizialized("map1", "none");
    SetDvarIfNotInizialized("map2", "none");
    SetDvarIfNotInizialized("map3", "none");
    SetDvarIfNotInizialized("map4", "none");
    SetDvarIfNotInizialized("map5", "none");
    SetDvarIfNotInizialized("map6", "none");

    SetDvarIfNotInizialized("mapgametype1", "unknown");
    SetDvarIfNotInizialized("mapgametype2", "unknown");
    SetDvarIfNotInizialized("mapgametype3", "unknown");
    SetDvarIfNotInizialized("mapgametype4", "unknown");
    SetDvarIfNotInizialized("mapgametype5", "unknown");
    SetDvarIfNotInizialized("mapgametype6", "unknown");

    SetDvarIfNotInizialized("mapname1", "none");
    SetDvarIfNotInizialized("mapname2", "none");
    SetDvarIfNotInizialized("mapname3", "none");
    SetDvarIfNotInizialized("mapname4", "none");
    SetDvarIfNotInizialized("mapname5", "none");
    SetDvarIfNotInizialized("mapname6", "none");

    SetDvarIfNotInizialized("mapvotes1", "0/18");
    SetDvarIfNotInizialized("mapvotes2", "0/18");
    SetDvarIfNotInizialized("mapvotes3", "0/18");
    SetDvarIfNotInizialized("mapvotes4", "0/18");
    SetDvarIfNotInizialized("mapvotes5", "0/18");
    SetDvarIfNotInizialized("mapvotes6", "0/18");

    SetDvarIfNotInizialized("ui_current", 1);
    
    level thread onPlayerConnect();
}

mapvote()
{
    // Choose random maps from the array
    maps = [];
    maps = strTok( getDvar("mv_maps"), " ");

    setUIDvar("votetime", "00:00");
    value = "0/" + int(num_of_bots()/2+1);
     
    for(i = 1; i <= 6;i++)
    {
        dvar = "map" + i;
        dvarname = "mapname" + i;
        index = randomIntRange(0, maps.size);
        map = maps[ index ];
        map_preview = "loadscreen_" + map;
        setUIDvar( dvar, map_preview );
        setUIDvar( dvarname, getmapname(map) );
        maps = ArrayRemoveIndex(maps, index);

        // Reset UI votes
        dvar = "mapvotes" + i;
        setUIDvar( dvar, value );
    }

    for(i = 0; i < level.players.size; i++)
    {
        if( !level.players[ i ] is_a_bot() )
        {
            level.players[ i ].vote = -1;
            level.players[ i ] thread onMenuResponse();
            level.players[ i ] openMenu("mapvote");
        }
    }

    thread managevotes(); // Manage votes of each map on screen 
    thread managetime(); // Manage timer on screen
    gametypes = [];
    gametypes = managegametypenames(); // Manage gametype on screen

    level waittill("mapvote_done", winner);

    execute = "";
    if( gametypes.size > 0)
    {
        gametypeslist = strTok(getDvar("mv_gametypes"), "@");
        gametypefiles = strTok(getDvar("mv_gametypefiles"), "@");
        index = gametypes[winner];
        setUIDvar("g_gametype", gametypeslist[index]);
        if(gametypefiles[index] != "")
            execute = "exec " + gametypefiles[index] + ".cfg";
    }
    setUIDvar("sv_maprotation", execute + "map " + mapimgtomapid( getDvar("map" + winner) ) );
    setUIDvar("sv_maprotationcurrent", execute + "map " + mapimgtomapid( getDvar("map" + winner) ) );
    if( !level.istimeexpired )
        wait 5;
}
setUIDvar(dvar, value)
{
    setDvar(dvar, value);
    for(i = 0; i < level.players.size; i++)
        if( !level.players[ i ] is_a_bot() )
            level.players[ i ] setClientDvar( dvar, value );
}

managegametypenames()
{
    level endon("game_ended");
    level endon("mapvote_done");
    if(getDvarInt("mv_randomgametypeenable") == 0)
        return [];

    gametypeslist = strTok(getDvar("mv_gametypes"), "@");

    gametypes = [];
    gametypes[0] = -1;

    gametypes[1] = randomIntRange(0, gametypeslist.size);
    setUIDvar("mapgametype1", gametypeToName( gametypeslist[ gametypes[1] ] ) );
    gametypes[2] = randomIntRange(0, gametypeslist.size);
    setUIDvar("mapgametype2", gametypeToName( gametypeslist[ gametypes[2] ] ) );
    gametypes[3] = randomIntRange(0, gametypeslist.size);
    setUIDvar("mapgametype3", gametypeToName( gametypeslist[ gametypes[3] ] ) );
    gametypes[4] = randomIntRange(0, gametypeslist.size);
    setUIDvar("mapgametype4", gametypeToName( gametypeslist[ gametypes[4] ] ) );
    gametypes[5] = randomIntRange(0, gametypeslist.size);
    setUIDvar("mapgametype5", gametypeToName( gametypeslist[ gametypes[5] ] ) );
    gametypes[6] = randomIntRange(0, gametypeslist.size);
    setUIDvar("mapgametype6", gametypeToName( gametypeslist[ gametypes[6] ] ) );

    return gametypes;

}
managetime()
{
    level endon("game_ended");
    level endon("mapvote_done");
    time = getDvarInt("mv_time");
    level.istimeexpired = 0;

    for(;;)
    {
        if(time < 0)
        {
            level.istimeexpired = 1;
            level notify("mapvote_done", getmostvotedmap()+1);
            return;
        }
        
        minutes = 0;
        strtime = "";
        if(time >= 60)
        {
            minutes = int(time/60);
            if(minutes < 10)
            {
                strtime = "0" + minutes;
            }
            else
            {
                strtime = "" + minutes;
            }
        }
        else
            strtime = "00";
        
        strtime = strtime + ":";

        seconds = time-(minutes*60);
        if(seconds < 10)
        {
            if(seconds <= 5)
            {
                for(i = 0; i < level.players.size; i++)
                    if(!level.players[ i ] is_a_bot())
                        level.players[ i ] playSound( "ui_mp_timer_countdown" );
            }
            strtime = strtime + "0" + seconds;
        }
        else
        {
            strtime = strtime + "" + seconds;
        }  
        
        setUIDvar("votetime", strtime);   
        
        wait 1;
        time--;
    }
}
managevotes()
{
    level endon("game_ended");

    for(;;)
    {
        for(i = 1; i <= 6;i++)
        {
            dvar = "mapvotes" + i;
            votes = 0;
            for(j = 0; j < level.players.size; j++)
            {
                if( !level.players[ j ] is_a_bot() && isDefined(level.players[ j ].vote) && level.players[ j ].vote == i-1 )
                    votes++;
            }
            value = votes + "/" + int(num_of_bots()/2+1);
            if( getDvar(dvar) != value )
                setUIDvar( dvar, value );
            
            if(votes >= int(num_of_bots()/2+1))
            {
                setUIDvar("votetime", "00:00");
                level notify("mapvote_done", getmostvotedmap()+1);
                return;
            }
        }
        wait 0.05; 
    }
}

onPlayerConnect()
{
    level endon("game_ended");
    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();
    }
}

onPlayerSpawned()
{
    self endon("disconnect");
    level endon("game_ended");

    for (;;)
    {
        self waittill("spawned_player");
    }
}

onMenuResponse()
{
    self endon("disconnect");
    level endon("game_ended");
    level endon("mapvote_done");

    for(;;)
    {
        self waittill("menuresponse", menu, response);
        if( menu == "mapvote")
        {
            self.vote = indextoint( response );
        }
    }
}

main()
{
    setDvarIfNotInizialized("mv_enable", 1);
    if(!getDvarInt("mv_enable"))
        return;
    replaceFunc(maps\mp\gametypes\_globallogic::endgame, ::mapvoteEndGame);
}

mapvoteEndGame( winner, endReasonText )
{   
    if ( game["state"] == "postgame" || level.gameEnded )
        return;
    if ( isDefined( level.onEndGame ) )
        [[level.onEndGame]]( winner );

    
    
    if ( !level.wagerMatch )
        setMatchFlag( "enable_popups", 0 );
    if ( !isdefined( level.disableOutroVisionSet ) || level.disableOutroVisionSet == false ) 
        visionSetNaked( "mpOutro", 2.0 );
    
    setmatchflag( "cg_drawSpectatorMessages", 0 );
    
    game["state"] = "postgame";
    level.gameEndTime = getTime();
    level.gameEnded = true;
    setUIDvar( "g_gameEnded", 1 );
    level.inGracePeriod = false;
    level notify ( "game_ended" );
    level.allowBattleChatter = false;
    
    game["roundsplayed"]++;
    game["roundwinner"][game["roundsplayed"]] = winner;
    
    
    if( level.teambased )
    {
        game["roundswon"][winner]++;    
    }
    
    setGameEndTime( 0 ); 
    
    maps\mp\gametypes\_globallogic::updatePlacement();
    maps\mp\gametypes\_globallogic::updateRankedMatch( winner );
    
    
    players = level.players;
    
    newTime = getTime();
    
    
    SetMatchTalkFlag( "EveryoneHearsEveryone", 1 );
    for ( index = 0; index < players.size; index++ )
    {
        player = players[index];
        player maps\mp\gametypes\_globallogic_player::freezePlayerForRoundEnd();
        player thread maps\mp\gametypes\_globallogic::roundEndDoF( 4.0 );
        player maps\mp\gametypes\_globallogic_ui::freeGameplayHudElems();
        
        
        player maps\mp\gametypes\_weapons::updateWeaponTimings( newTime );
        
        if( isPregame() )
            continue;
        if( ( level.rankedMatch || level.wagerMatch ) && !player IsSplitscreen() )
        {
            if ( isDefined( player.setPromotion ) )
                player setClientDvar( "ui_lobbypopup", "promotion" );
            else
                player setClientDvar( "ui_lobbypopup", "summary" );
        }
    }
    
    maps\mp\_music::setmusicstate( "SILENT" );
    if ( !level.inFinalKillcam )
    {
    }
    maps\mp\_gamerep::gameRepUpdateInformationForRound();
    maps\mp\gametypes\_wager::finalizeWagerRound();
    maps\mp\gametypes\_gametype_variants::onRoundEnd();
    thread maps\mp\_challenges::roundEnd( winner );
    if ( maps\mp\gametypes\_globallogic::startNextRound( winner, endReasonText ) )
    {
        return;
    }
    
    if ( !isOneRound() )
    {
        if ( isDefined( level.onRoundEndGame ) )
            winner = [[level.onRoundEndGame]]( winner );
        endReasonText = maps\mp\gametypes\_globallogic::getEndReasonText();
    }

    maps\mp\gametypes\_globallogic::setTopPlayerStats();
    thread maps\mp\_challenges::gameEnd( winner );
    thread maps\mp\gametypes\_missions::roundEnd( winner );
    if ( !isDefined( level.skipGameEnd ) || !level.skipGameEnd )
        maps\mp\gametypes\_globallogic::displayGameEnd( winner, endReasonText );
    
    if ( isOneRound() )
    {
        maps\mp\gametypes\_globallogic_utils::executePostRoundEvents();
    }
        
    level.intermission = true;
    maps\mp\_gamerep::gameRepAnalyzeAndReport();
    
    if( !isPregame() )
        thread maps\mp\gametypes\_globallogic::sendAfterActionReport();
    maps\mp\gametypes\_wager::finalizeWagerGame();
    
    SetMatchTalkFlag( "EveryoneHearsEveryone", 1 );
    
    mapvote();
    
    players = level.players;
    for ( index = 0; index < players.size; index++ )
    {
        player = players[index];
        
        player closeMenu();
        player closeInGameMenu();
        player notify ( "reset_outcome" );
        player thread [[level.spawnIntermission]]();
        player setClientUIVisibilityFlag( "hud_visible", 1 );
        if( !level.console )
        {
            if( !IsDefined( level.killserver ) || !level.killserver )
                player setclientdvar( "g_scriptMainMenu", game["menu_eog_main"] );
            else
                player setclientdvar( "g_scriptMainMenu", "" );         
        }
    }
    
    logString( "game ended" );
    
    if( level.console )
    {
        if ( !isDefined( level.skipGameEnd ) || !level.skipGameEnd )
            wait 5.0;
    
        exitLevel( 0 );
        return;
    }
    StopDemoRecording();
    
    if( IsDefined( level.killserver ) && level.killserver )
    {
        wait 5;
        killserver();
        return;
    }
    
    if( IsGlobalStatsServer() )
    {   
        thread maps\mp\_pc::pcserver();     
    }
    wait GetDvarFloat( "scr_show_unlock_wait" );
    
    thread maps\mp\gametypes\_globallogic::timeLimitClock_Intermission( GetDvarFloat( "scr_intermission_time" ) );
    wait GetDvarFloat( "scr_intermission_time" );
    
    players = level.players;
    for ( index = 0; index < players.size; index++ )
    {
        player = players[index];
        player closeMenu();
        player closeInGameMenu();
    }
    
    exitLevel( 0 );
}
