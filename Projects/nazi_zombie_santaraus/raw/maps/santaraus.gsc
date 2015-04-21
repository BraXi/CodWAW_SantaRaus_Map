#include common_scripts\utility; 
#include maps\_utility;

//#include maps\_zombiemode_utility; 
//#include maps\_zombiemode_zone_manager; 
//#include maps\_music;
//#include maps\dlc3_code;
//#include maps\dlc3_teleporter;

main()
{

	maps\nazi_zombie_santaraus_fx::main();

	level thread maps\_callbacksetup::SetupCallbacks();
	maps\_load::main();


	include_weapons();
	include_powerups();

	maps\_zombiemode::main();

	
	level thread maps\_zombie_capsule::init();
	
	array_thread( getEntArray( "door_vertical", "targetname" ), ::door_vertical_think );
	array_thread( getEntArray( "vision_changer", "targetname" ), ::vision_changer_think );
	array_thread( getEntArray( "radio", "targetname" ), ::radio_think );

	/*--------------------
	 LEVEL VARIABLES
	----------------------*/	
	
	level.modderHelpText = [];
	level.DLC3.introString = "Santa Raus";
	
	level.DLC3.weapons = maps\dlc3_code::include_weapons;
	
	level.DLC3.powerUps =  maps\dlc3_code::include_powerups;
	
	level.DLC3.perk_altMeleeDamage = 1000; 
	

	level.DLC3.barrierSearchOverride = 400;
	level.DLC3.powerUpDropMax = 3;
	level.DLC3.useCoopHeroes = true;
	
	// Bridge Feature
	level.DLC3.useBridge = false;
	
	// Hell Hounds
	level.DLC3.useHellHounds = true;
	
	// Mixed Rounds
	level.DLC3.useMixedRounds = true;
	
	// Magic Boxes -- The Script_Noteworthy Value Names On Purchase Trigger In Radiant
	boxArray = [];
	boxArray[ boxArray.size ] = "start_chest";
	boxArray[ boxArray.size ] = "chest1";
	boxArray[ boxArray.size ] = "chest2";
	boxArray[ boxArray.size ] = "chest3";
	boxArray[ boxArray.size ] = "chest4";
	boxArray[ boxArray.size ] = "chest5";
	level.DLC3.PandoraBoxes = boxArray;
	
	// Initial Zone(s) -- Zone(s) You Want Activated At Map Start
	zones = [];
	zones[ zones.size ] = "start_zone";
	zones[ zones.size ] = "zone2";
	zones[ zones.size ] = "underground";
	level.DLC3.initialZones = zones;
	
	// Electricity Switch -- If False Map Will Start With Power On
	level.DLC3.useElectricSwitch = false;
	
	// Electric Traps
	level.DLC3.useElectricTraps = false;
	
	// _zombiemode_weapons Variables
	level.DLC3.usePandoraBoxLight = true;
	level.DLC3.useChestPulls = true;
	level.DLC3.useChestMoves = true;
	level.DLC3.useWeaponSpawn = true;
	level.DLC3.useGiveWeapon = true;
	
	// _zombiemode_spawner Varibles
	level.DLC3.riserZombiesGoToDoorsFirst = true;
	level.DLC3.riserZombiesInActiveZonesOnly = true;
	level.DLC3.assureNodes = true;
	
	// _zombiemode_perks Variables
	level.DLC3.perksNeedPowerOn = true;
	
	// _zombiemode_devgui Variables
	level.DLC3.powerSwitch = false;
	
	// Snow Feature
	level.DLC3.useSnow = false;
	
	/*--------------------
	 FUNCTION CALLS - PRE _Load
	----------------------*/
	level thread DLC3_threadCalls();	
	
	/*--------------------
	thread player_snow2();
	thread maps\_ray_slide::main();
	thread maps\_ray_walking::main();
	thread armory();
	
	/*--------------------
	 FUNCTION CALLS - POST _Load
	----------------------*/
	players = GetPlayers();
	players[0] maps\_zombiemode_score::add_to_player_score(5000000);


	level.zone_manager_init_func = ::dlc3_zone_init;
}




// Include the weapons that are only inr your level so that the cost/hints are accurate
// Also adds these weapons to the random treasure chest.
include_weapons()
{
	include_weapon( "zombie_colt" );
	include_weapon( "zombie_colt_upgraded", false );
	include_weapon( "zombie_sw_357" );
	include_weapon( "zombie_sw_357_upgraded", false );

	// Bolt Action
	include_weapon( "zombie_kar98k" );
	include_weapon( "zombie_kar98k_upgraded", false );
//	include_weapon( "springfield");		
//	include_weapon( "zombie_type99_rifle" );
//	include_weapon( "zombie_type99_rifle_upgraded", false );

	// Semi Auto
	include_weapon( "zombie_m1carbine" );
	include_weapon( "zombie_m1carbine_upgraded", false );
	include_weapon( "zombie_m1garand" );
	include_weapon( "zombie_m1garand_upgraded", false );
	include_weapon( "zombie_gewehr43" );
	include_weapon( "zombie_gewehr43_upgraded", false );

	// Full Auto
	include_weapon( "zombie_stg44" );
	include_weapon( "zombie_stg44_upgraded", false );
	include_weapon( "zombie_thompson" );
	include_weapon( "zombie_thompson_upgraded", false );
	include_weapon( "zombie_mp40" );
	include_weapon( "zombie_mp40_upgraded", false );
	include_weapon( "zombie_type100_smg" );
	include_weapon( "zombie_type100_smg_upgraded", false );

	// Scoped
	include_weapon( "ptrs41_zombie" );
	include_weapon( "ptrs41_zombie_upgraded", false );
//	include_weapon( "kar98k_scoped_zombie" );	// replaced with type99_rifle_scoped
//	include_weapon( "type99_rifle_scoped_zombie" );	//

	// Grenade
	include_weapon( "molotov" );
	include_weapon( "stielhandgranate" );

	// Grenade Launcher	
	include_weapon( "m1garand_gl_zombie" );
	include_weapon( "m1garand_gl_zombie_upgraded", false );
	include_weapon( "m7_launcher_zombie" );
	include_weapon( "m7_launcher_zombie_upgraded", false );

	// Flamethrower
	include_weapon( "m2_flamethrower_zombie" );
	include_weapon( "m2_flamethrower_zombie_upgraded", false );

	// Shotgun
	include_weapon( "zombie_doublebarrel" );
	include_weapon( "zombie_doublebarrel_upgraded", false );
	//include_weapon( "zombie_doublebarrel_sawed" );
	include_weapon( "zombie_shotgun" );
	include_weapon( "zombie_shotgun_upgraded", false );

	// Heavy MG
	include_weapon( "zombie_bar" );
	include_weapon( "zombie_bar_upgraded", false );
	include_weapon( "zombie_fg42" );
	include_weapon( "zombie_fg42_upgraded", false );

	include_weapon( "zombie_30cal" );
	include_weapon( "zombie_30cal_upgraded", false );
	include_weapon( "zombie_mg42" );
	include_weapon( "zombie_mg42_upgraded", false );
	include_weapon( "zombie_ppsh" );
	include_weapon( "zombie_ppsh_upgraded", false );

	// Rocket Launcher
	include_weapon( "panzerschrek_zombie" );
	include_weapon( "panzerschrek_zombie_upgraded", false );

	// Special
	include_weapon( "ray_gun", true, ::factory_ray_gun_weighting_func );
	include_weapon( "ray_gun_upgraded", false );
	include_weapon( "tesla_gun", true );
	include_weapon( "tesla_gun_upgraded", false );
	include_weapon( "zombie_cymbal_monkey", true, ::factory_cymbal_monkey_weighting_func );


	//bouncing betties
	include_weapon("mine_bouncing_betty", false);

	// limited weapons
	maps\_zombiemode_weapons::add_limited_weapon( "zombie_colt", 0 );
	//maps\_zombiemode_weapons::add_limited_weapon( "zombie_type99_rifle", 0 );
	maps\_zombiemode_weapons::add_limited_weapon( "zombie_gewehr43", 0 );
	maps\_zombiemode_weapons::add_limited_weapon( "zombie_m1garand", 0 );
}




armory()
{
	door = getEnt( "armory_door", "targetname" );
	trig = getEnt( door.target, "targetname" );

	trig setHintString( "Open armory for ^34000^7 points" );
//	door disconnectPaths();
	while( true )
	{
		trig waittill( "trigger", user );
		
		if( !isPlayer( user ) || user.score < 4000 )
			continue;

		trig delete();

		user maps\_zombiemode_score::minus_to_player_score( 4000 );
		door rotateYaw( 90, 2, 0.5, 0.2 );

		wait 1.5;
		door connectPaths();

		break;
	}
}

player_snow2()
{
	self endon("death");
	self endon("disconnect");

	while( 1 /*isDefined( self )*/ )
	{
		// hotfix
		while( isDefined( self.visionname ) && self.visionname != "nazi_zombie_santaraus" )
			wait 0.5;

		playfx ( level._effect["snow_thick"], self.origin );
		wait 0.6;
	}
}
// trigger_multiple -[.target]-> script_brushmodel -[.script_noteworthy]->num units to move vertically to open or close the door
// lets just hope it's idiot-proof
door_vertical_think()
{
	if( !isDefined( self.target ) )
		return;

	self.door = getEnt( self.target, "targetname" );

	self.door ConnectPaths();

	self.door.closed = true;

	while( isDefined( self ) && isDefined( self.door ) ) 
	{
		user = undefined;
		self waittill( "trigger", user ); // we dont need to know who..

		self.door door_action_toggle( 0.8 );

		wait 3.8; // a slight delay

		while( isDefined( user ) && user isTouching( self ) )
			wait 0.1; //lets not close the door when user is nearby

		self.door door_action_toggle( 0.8 );
		wait 1;
	}
}


door_action_toggle( moveTime )
{
	if( self.closed )
	{
		self moveZ( 80, 0.8, 0.1, 0.1 );
//		self playSound( "sr_door_open" );
	}
	else
	{
		self moveZ( -80, 0.8, 0.1, 0.1 );
//		self playSound( "sr_door_close" );
	}
	self.closed = !self.closed;
}




vision_changer_think()
{
	// script_noteworthy is our vision file
	while( isDefined( self ) )
	{
		self waittill( "trigger", user );

		if( !isPlayer( user ) || !isDefined( self.script_noteworthy ) )
			continue;

		if( isDefined( user.visionname ) && user.visionname == self.script_noteworthy )
			continue;

			user visionSetNaked( self.script_noteworthy, 1 ); 
			user.visionname = self.script_noteworthy;
	}
}



add_radio_song( name, alias, length )
{
	if( !isDefined( level.songs ) )
		level.songs = [];

	s = spawnStruct();
	s.name = name;
	s.alias = alias;
	s.length = length;

	level.songs[level.songs.size] = s;
}

radio_think()
{
	if( !isDefined( self.target ) )
		return;
	self.trigger = getEnt( self.target, "targetname" );

	add_radio_song( "Jingle Bells", "KFh_JBells", 222 );
	add_radio_song( "SNacht", "KFh_SNacht", 90 );
	add_radio_song( "Trepak", "KFh_Trepak", 220 );
	add_radio_song( "Organ Grinder", "KFh2_OrganGrinder", 90 );
	add_radio_song( "OTBaum", "KFh3_OTbaum", 91 );

	self.nextsong = 0;
	self.trigger setHintString( "Play ^3" + level.songs[self.nextsong].name + " ^7for ^31000 ^7points" );

	while( isDefined( self ) )
	{
		self.trigger waittill( "trigger", user );

		if( !isPlayer( user ) || user.score < 1000 )
			continue;
		user maps\_zombiemode_score::minus_to_player_score( 1000 );

		self thread radio_play( self.nextsong );

		self.nextsong ++;
		if( self.nextsong >= level.songs.size )
			level.nextsong = 0;

		self.trigger setHintString( "Play ^3" + level.songs[self.nextsong].name + " ^7for ^31000 ^7points" );
		wait 1;
	}

}

radio_play( id )
{
	self endon( "song_changed" );
	self notify( "song_changed" );

	song = level.songs[ id ];

	self stopLoopSound();
	self playLoopSound( song.alias );

	wait song.length;

	self stopLoopSound();
}


dlc3_zone_init()
{
	/*
	=============
	///ScriptDocBegin
	"Name: add_adjacent_zone( <zone_1>, <zone_2>, <flag>, <one_way> )"
	"Summary: Sets up adjacent zones."
	"MandatoryArg: <zone_1>: Name of first Info_Volume"
	"MandatoryArg: <zone_2>: Name of second Info_Volume"
	"MandatoryArg: <flag>: Flag to be set to initiate zones"
	"OptionalArg: <one_way>: Make <zone_1> adjacent to <zone_2>. Defaults to false."
	"Example: add_adjacent_zone( "receiver_zone",		"outside_east_zone",	"enter_outside_east" );"
	///ScriptDocEnd
	=============
	*/

	// Outside East Door
	//add_adjacent_zone( "receiver_zone",		"outside_east_zone",	"enter_outside_east" );
}

preCacheMyFX()
{
	// LEVEL SPECIFIC - FEEL FREE TO REMOVE/EDIT
	
	level._effect["snow_thick"]			= LoadFx ( "env/weather/fx_snow_blizzard_intense" );
}
