// CoD4 In-Game Effects Manipulation Tool by BraXi 1.0 (2013-11-14)
// Entities places: 7
main()
{
	precache();
	maps\createart\nazi_zombie_santaraus_art::main();

	// Effect #0
	ent = braxi\_fxutil::CreateEffect( "oneshotfx" );
	ent.v[ "origin" ] = ( -4177, -264, -231 );
	ent.v[ "angles" ] = ( 270, 90, 0 );
	ent.v[ "fxid" ] = "fire_med";

	// Effect #1
	ent = braxi\_fxutil::CreateEffect( "oneshotfx" );
	ent.v[ "origin" ] = ( -4023, 69, -261 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "fire_med";

	// Effect #2
	ent = braxi\_fxutil::CreateEffect( "oneshotfx" );
	ent.v[ "origin" ] = ( -4207, 81, -245 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "fire_med";

	// Effect #3
	ent = braxi\_fxutil::CreateEffect( "oneshotfx" );
	ent.v[ "origin" ] = ( -2840, -928, -236 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "smoke_med";

	// Effect #4
	ent = braxi\_fxutil::CreateEffect( "oneshotfx" );
	ent.v[ "origin" ] = ( -2744, -1064, -236 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "fire_med";

	// Effect #5
	ent = braxi\_fxutil::CreateEffect( "oneshotfx" );
	ent.v[ "origin" ] = ( -2464, -1296, 80 );
	ent.v[ "angles" ] = ( 270, 90, 0 );
	ent.v[ "fxid" ] = "fire_med";

	// Effect #6
	ent = braxi\_fxutil::CreateEffect( "oneshotfx" );
	ent.v[ "origin" ] = ( -1468, -520, 656 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "smoke_med";


	// Effect #7
	ent = braxi\_fxutil::CreateEffect( "soundfx" );
	ent.v[ "origin" ] = ( -4177, -264, -231 );
	ent.v[ "angles" ] = ( 0, 0, 0 );
	ent.v[ "soundalias" ] = "small_fire";

	// Effect #8
	ent = braxi\_fxutil::CreateEffect( "soundfx" );
	ent.v[ "origin" ] = ( -4023, 69, -261 );
	ent.v[ "angles" ] = ( 0, 0, 0 );
	ent.v[ "soundalias" ] = "small_fire";

	// Effect #9
	ent = braxi\_fxutil::CreateEffect( "soundfx" );
	ent.v[ "origin" ] = ( -4207, 81, -245 );
	ent.v[ "angles" ] = ( 0, 0, 0 );
	ent.v[ "soundalias" ] = "small_fire";

	// Effect #10
	ent = braxi\_fxutil::CreateEffect( "soundfx" );
	ent.v[ "origin" ] = ( -2744, -1064, -236 );
	ent.v[ "angles" ] = ( 0, 0, 0 );
	ent.v[ "soundalias" ] = "small_fire";

	// Effect #11
	ent = braxi\_fxutil::CreateEffect( "soundfx" );
	ent.v[ "origin" ] = ( -2464, -1296, 80 );
	ent.v[ "angles" ] = ( 0, 0, 0 );
	ent.v[ "soundalias" ] = "small_fire";

	thread braxi\_fxutil::init_effects();
	thread spotlight();
}


//#include maps\_utility; 
//#include common_scripts\utility;

precache()
{
//	footsteps(); 
	level._effect["snow_thick"]			= loadFX( "env/weather/fx_snow_blizzard_intense" );	
	level._effect["search_light_fx"]	= LoadFX( "misc/fx_spotlight_large" );
	level._effect["fire_med"]			= loadFX( "env/fire/fx_fire_blown_md_light_blk_smk2" );
	level._effect["smoke_med"]			= loadFX( "env/smoke/fx_smoke_window_md_gry" );
}


spotlight()
{
	spotlight = getEnt( "lighthouse_spotlight", "targetname" );

	wait 1;

	while( 1 )
	{
		spotlight rotateYaw( 360, 6 );
		playfxontag( level._effect["search_light_fx"], spotlight, "tag_flash" );
		playfxontag( level._effect["search_light_fx"], spotlight, "tag_flash" );
		playfxontag( level._effect["search_light_fx"], spotlight, "tag_flash" );
		wait 6;
	}
}
