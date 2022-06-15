#include common_scripts\utility;
#include maps\mp\_utility;

SetDvarIfNotInizialized(dvar, value)
{
	if (!IsInizialized(dvar))
		setDvar(dvar, value);
}
IsInizialized(dvar)
{
	result = getDvar(dvar);
	return !isDefined(result) || result != "";
}

ArrayRemoveIndex(array, index)
{
    new_array = [];
    for(i = 0; i < array.size ;i++)
    {
        if(i != index)
            new_array[new_array.size] = array[i];
    }
    return new_array;
}
is_a_bot()
{
    assert( isDefined( self ) );
    assert( isPlayer( self ) );

    return ( ( isDefined( self.pers["isBot"] ) && self.pers["isBot"] ) || ( isDefined( self.pers["isBotWarfare"] ) && self.pers["isBotWarfare"] ) || isSubStr( self getguid() + "", "bot" ) );
}
num_of_bots()
{
    num = 0;
    for(i = 0; i < level.players.size; i++)
    {
        if(!level.players[ i ] is_a_bot())
            num++;
    }
    return num;
}
getmapname(map) {
    switch(map) {
    
    // Default ones
    case "mp_array": return "ARRAY";
    case "mp_cracked": return "CRACKED";
    case "mp_crisis": return "CRISIS";
    case "mp_firingrange": return "FIRINGRANGE";
    case "mp_duga": return "GRID";
    case "mp_hanoi": return "HANOI";
    case "mp_havoc": return "JUNGLE";
    case "mp_cairo": return "HAVANA";
    case "mp_cosmodrome": return "LAUNCH";
    case "mp_nuked": return "NUKETOWN";
    case "mp_radiation": return "RADIATION";
    case "mp_mountain": return "SUMMIT";
    case "mp_villa": return "VILLA";
    case "mp_russianbase": return "WMD";
    
    // DLC 1
    case "mp_berlinwall2": return "BERLIN WALL";
    case "mp_discovery": return "DISCOVERY";
    case "mp_kowloon": return "KOWLOON";
    case "mp_stadium": return "STADIUM";
    
    // DLC 2
    case "mp_gridlock": return "GRIDLOCK";
    case "mp_hotel": return "HOTEL";
    case "mp_outskirts": return "OUTSKIRTS";
    case "mp_zoo": return "ZOO";
    
    // DLC 3
    case "mp_drivein": return "DRIVE-IN";
    case "mp_area51": return "HANGER 18";
    case "mp_golfcourse": return "HAZARD";
    case "mp_silo": return "SILO";
    
    /*
        How to add a new map name translation:
        1) Add 1 case like
            case "mp_mapname": return "MAPNAME";
            like
            case "mp_minecraft": return "MINECRAFT":
    */
    default: return "UNKNOWN";
    }
}
mapimgtoname(img)
{
    array = strTok( img , "_");
    str = "";
    for(i = 1; i < array.size; i++)
    {
        if(str == "")
            str = array[ i ];
        else
            str = str + "_" + array[ i ];
    }
    return getmapname( str );
}
mapimgtomapid(img)
{
    array = strTok( img , "_");
    str = "";
    for(i = 1; i < array.size; i++)
    {
        if(str == "")
            str = array[ i ];
        else
            str = str + "_" + array[ i ];
    }
    return str;
}
indextoint( str )
{
    a = strTok("1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19", ",");
    for(i = 0; i < 18; i++)
        if(str == a[i])
            return i;
    return 0;
}
getmostvotedmap()
{
    votes = [];
    votes[0] = 0;
    votes[1] = 0;
    votes[2] = 0;
    votes[3] = 0;
    votes[4] = 0;
    votes[5] = 0;
    votes[6] = 0;
    for(i = 0; i < level.players.size; i++)
    {
        if( !level.players[ i ] is_a_bot() && int(level.players[ i ].vote) > 0 )
        {
            votes[ int(level.players[ i ].vote) ]++;
        }
    }
    winner = 0;
    for(i = 0; i < votes.size; i++)
    {
        if(votes[i] > votes[winner])
        {
            winner = i;
        }
    }
    return winner;
}
gametypeToName(gametype)
{
	switch (tolower(gametype))
	{
	case "dm":
		return "Free for all";

	case "tdm":
		return "Team Deathmatch";

	case "sd":
		return "Search & Destroy";

	case "ctf":
		return "Capture the Flag";

	case "dom":
		return "Domination";

	case "dem":
		return "Demolition";

	case "gun":
		return "Gun Game";

	case "koth":
		return "Headquaters";

	case "oic":
		return "One in the chamber";

	case "sas":
		return "Sticks & Stones";

	case "shrp":
		return "Sharpshooter";

	}
	return "invalid";
}
