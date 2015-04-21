#include common_scripts\utility; 
#include maps\_utility;

main()
{
	include_weapons();
	include_powerups();
	
	maps\nazi_zombie_santaraus_fx::main();
	maps\_zombiemode::main();
	maps\_load::main();
	
	maps\_zombie_capsule::init();

	init_sounds();

	wait 1;
	players = get_players();
	array_thread( players, ::player_snow );

	array_thread( getEntArray( "door_vertical", "targetname" ), ::door_vertical_think );
	array_thread( getEntArray( "vision_changer", "targetname" ), ::vision_changer_think );
}


init_sounds()
{
	maps\_zombiemode_utility::add_sound( "break_stone", "break_stone" );
}

// Include the weapons that are only in your level so that the cost/hints are accurate
// Also adds these weapons to the random treasure chest.
include_weapons()
{
	// Pistols
	include_weapon( "colt" );
	
	// Semi Auto
	include_weapon( "m1carbine" );
	include_weapon( "m1garand" );
	include_weapon( "gewehr43" );

	// Full Auto
	include_weapon( "stg44" );
	include_weapon( "thompson" );
	include_weapon( "mp40" );
	
	// Flamethrower
	include_weapon( "m2_flamethrower_zombie" );
}

include_powerups()
{
	include_powerup( "nuke" );
	include_powerup( "insta_kill" );
	include_powerup( "double_points" );
	include_powerup( "full_ammo" );
}

include_weapon( weapon_name )
{
	maps\_zombiemode_weapons::include_zombie_weapon( weapon_name );
}

include_powerup( powerup_name )
{
	maps\_zombiemode_powerups::include_zombie_powerup( powerup_name );
}



player_snow()
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
