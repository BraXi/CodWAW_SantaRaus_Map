#include common_scripts\utility;
#include maps\_utility;

vector_scale( vec, scale )
{
	vec = (vec[0]*scale,vec[1]*scale,vec[2]*scale);
}

init_effects()
{
/*	setDvar( "developer_script", 1 );
	setDvar( "developer_script", 1 );
	setDvar( "g_logfile", 1 );*/

	if( !isDefined( level.FX_Objects ) )
		level.FX_Objects = [];

//	level.FX_Types = strTok( "loopfx;oneshotfx;soundfx;exploder", ";" );
	level.FX_Types = strTok( "loopfx;oneshotfx;soundfx", ";" );

//	/#
	precacheModel( "axis" );
	thread DeveloperLogic();
//	#/

	thread Run_Effects();
}

Run_Effects()
{
	wait 0.1;

	for( i = 0; i < level.FX_Objects.size; i++ )
	{
		ent = level.FX_Objects[i];
		level.FX_Objects[i].id = i;
		TriggerEffect( ent );
	}
}

createEffect( type )
{
	if( !isDefined( level.FX_Objects ) )
		level.FX_Objects = [];

	ent = spawnStruct();
	level.FX_Objects[level.FX_Objects.size] = ent;

	ent.v = [];

	ent.v["type"] = type;
	ent.v["angles"] = ( 0,0,0 );
	ent.v["origin"] = ( 0,0,0 );
	ent.v["fxid"] = "No FX";

	ent.playing = false;
	ent.id = level.FX_Objects.size-1;

	if( type == "loopfx" )
	{
		ent.v["repeatDelay"] = 1;
		ent.v["cullDistance"] = 1500;
	}
	else if( type == "soundfx" )
	{
		ent.v["soundalias"] = "null";
	}

	return ent;
}



TriggerEffect( ent )
{
	ent.playing = !ent.playing;
	if( isDefined( ent.effect ) )
	{
		ent.effect delete();
		return;
	}

	ent set_vectors();

	/#
	ent thread DrawDebugInfo();
	#/

	switch( ent.v["type"] )
	{
	case "loopfx":
		ent scr_PlayLoopedFX();
		break;
	case "oneshotfx":
		ent scr_PlayFX();
		break;
	case "soundfx":
		ent scr_LoopSoundFX();
		break;
	case "exploder":
		println( "TriggerEffect() ent.v[\"type\"] == exploder not implemented!" );
		break;
	}
	
}


set_vectors()
{
	self.v["up"] = anglesToUp( self.v["angles"] );
	self.v["forward"] = anglesToForward( self.v["angles"] );
	self.v["right"] = anglesToRight( self.v["angles"] );
}


scr_PlayLoopedFX()
{
	if( self.v["fxid"] == "No FX" )
		return;
	//PlayLoopedFX( <effect id>, <repeat delay>, <position>, <cull distance>, <forward>, <up> )
	self.effect = playLoopedFX( level._effect[ self.v[ "fxid" ] ], self.v["repeatDelay"], self.v[ "origin" ], self.v["cullDistance"], self.v[ "forward" ], self.v[ "up" ] );
}

scr_PlayFX()
{
	if( self.v["fxid"] == "No FX" )
		return;
	//PlayFX( <effect id>, <position of effect>, <forward vector>, <up vector> )
	//self.effect = playFX( level._effect[ self.v[ "fxid" ] ], self.v[ "origin" ], self.v[ "forward" ], self.v[ "up" ] );

	//SpawnFx( <effect id>, <position>, <forward>, <up> )
	self.effect = SpawnFx( level._effect[ self.v[ "fxid" ] ], self.v[ "origin" ], self.v[ "forward" ], self.v[ "up" ] );
	TriggerFX( self.effect, -5 );
}

scr_LoopSoundFX()
{
	if( self.v["soundalias"] == "null" || !soundExists( self.v["soundalias"] ) )
		return;
	self.effect = spawn( "script_model", self.v["origin"] );
	self.effect playLoopSound( self.v["soundalias"] );
}






DrawDebugInfo()
{
	ent = self;

	if( isDefined( ent.debug ) )
		return;

	ent.debug = true;

	color = ( 1,0.8,0 );
	
	ent.axis = spawn( "script_model", self.v["origin"] );
	ent.axis setModel( "axis" );
	ent.angles = self.v["angles"];

	while( 1 )
	{
		str = ent.v["fxid"];
		if( ent.v["type"] == "soundfx" )
			str = ent.v["soundalias"];

		if( ent.playing )
			str = str + " (playing)";
		else
			str = str + " (stopped)";

		//Print3d( <origin>, <text>, <color>, <alpha>, <scale>, <duration> )
		print3d( self.v["origin"] + (0,0,8), ("#" + ent.id + " " + ent.v["type"] + " : " + str), (1.0,0.7,0), 1.0, 0.3, 1 );
		print3d( self.v["origin"] + (0,0,4), "angles " + self.v["angles"], (0,0.8,0), 1.0, 0.3, 1 );
		print3d( self.v["origin"], "" + self.v["origin"], (0,0.5,0), 1.0, 0.3, 1 );

		center = self.v["origin"] - (0,0,8);

		forward = vector_scale( anglestoForward( (0,0,0) ), 8 );
		right = vector_scale( anglestoright( (0,0,0) ), 8 );

		a = center + forward - right;
		b = center + forward + right;
		c = center - forward + right;
		d = center - forward - right;
			
		//line(start, end, color, depthTest)
		line( a, b, color, 1 );
		line( b, c, color, 1 );
		line( c, d, color, 1 );
		line( d, a, color, 1 );

		line( a, a + (0, 0, 16), color, 1 );
		line( b, b + (0, 0, 16), color, 1 );
		line( c, c + (0, 0, 16), color, 1 );
		line( d, d + (0, 0, 16), color, 1 );
		
		a = a + (0, 0, 16);
		b = b + (0, 0, 16);
		c = c + (0, 0, 16);
		d = d + (0, 0, 16);
			
		line( a, b, color, 1 );
		line( b, c, color, 1 );
		line( c, d, color, 1 );
		line( d, a, color, 1 );
		wait 0.05;
	}
}


DevCmd( name, argc, func_ptr )
{
	cmd = spawnStruct();
	level.fxDevCmds[level.fxDevCmds.size] = cmd;
	cmd.v = [];
	cmd.v["name"] = name;
	cmd.v["argc"] = argc;
	cmd.v["func_ptr"] = func_ptr;
}

log_println( str )
{
	println( str + "\n" );
}

devmode_save( args )
{
	iPrintlnBold( "SAVING EFFECTS TO LOGFILE" );
	iPrintlnBold( "COPY THESE LINES TO ", level.script, "_fx.gsc" );

	tab = "    ";

	log_println( "// CoD4 In-Game Effects Manipulation Tool by BraXi 1.0 (2013-11-14)"  );
	log_println( "// Entities places: " + level.FX_Objects.size );

	log_println( "main()" );
	log_println( "{" );

	for( i = 0; i < level.FX_Objects.size; i++ )
	{
		e = level.FX_Objects[i];

		log_println( tab + "// Effect #" + i );
		log_println( tab + "ent = braxi\\_fxutil::CreateEffect( \"" + e.v["type"] + "\" );" );
		log_println( tab + "ent.v[ \"origin\" ] = ( " + e.v["origin"][0] + ", " + e.v["origin"][1] + ", " + e.v["origin"][2] + " );" );
		log_println( tab + "ent.v[ \"angles\" ] = ( " + e.v["angles"][0] + ", " + e.v["angles"][1] + ", " + e.v["angles"][2] + " );" );
		
		if( e.v["type"] == "soundfx" )
			log_println( tab + "ent.v[ \"soundalias\" ] = \"" + e.v[ "soundalias" ] +"\";" );
		else
			log_println( tab + "ent.v[ \"fxid\" ] = \"" + e.v[ "fxid" ] +"\";" );

		if( e.v["type"] == "loopfx" )
			log_println( tab + "ent.v[ \"repeatDelay\" ] = " + e.v["repeatDelay"] + ";" );
		log_println( "" );
	}

	log_println( tab + "braxi\\_fxutil::init_effects();" );
	log_println( "}" );
}


devmode_selectFX( args )
{
	id = int(args[1]);
	if( id >= level.FX_Objects.size || id < 0 )
		return;
	level.selectedEffect = id;
	iPrintln( "Selected effect #" + level.FX_Objects[id].id );	
}

devmode_triggerFX( args )
{
	id = level.selectedEffect;
	if( id >= level.FX_Objects.size || id < 0 )
		return;

	TriggerEffect( level.FX_Objects[id] );

	iPrintln( "Triggered effect #" + level.FX_Objects[id].id );	
}

devmode_move( args )
{
	id = level.selectedEffect;
	v = args[1];
	val = int(args[2]);

	if( id >= level.FX_Objects.size || id < 0 )
		return;

	ent = level.FX_Objects[id];

	switch( v )
	{
	case "x":
		ent.v["origin"] = ( val, ent.v["origin"][1], ent.v["origin"][2] );
		break;
	case "y":
		ent.v["origin"] = ( ent.v["origin"][0], val, ent.v["origin"][2] );
		break;
	case "z":
		ent.v["origin"] = ( ent.v["origin"][0], ent.v["origin"][1], val );
		break;
	}

	if( isDefined( ent.effect ) )
		ent.effect.origin = ent.v["origin"];

	iPrintln( "Translated effect #" + ent.id + " to " + ent.v["origin"] );

	TriggerEffect( level.FX_Objects[id] );
	TriggerEffect( level.FX_Objects[id] );	
}

devmode_rotate( args )
{
	id = level.selectedEffect;
	v = args[1];
	val = int(args[2]);

	if( id >= level.FX_Objects.size || id < 0 )
		return;

	ent = level.FX_Objects[id];

	switch( v )
	{
	case "x":
		ent.v["angles"] = ( val, ent.v["angles"][1], ent.v["angles"][2] );
		break;
	case "y":
		ent.v["angles"] = ( ent.v["angles"][0], val, ent.v["angles"][2] );
		break;
	case "z":
		ent.v["angles"] = ( ent.v["angles"][0], ent.v["angles"][1], val );
		break;
	}

	if( isDefined( ent.effect ) )
		ent.effect.origin = ent.v["origin"];

	iPrintln( "Rotated effect #" + ent.id + " to " + ent.v["angles"] );

	TriggerEffect( level.FX_Objects[id] );
	TriggerEffect( level.FX_Objects[id] );
}

devmode_create( args )
{
	type = args[1];
	
	if( type != "loopfx" && type != "oneshotfx" && type != "soundfx" )
	{
		iPrintln( "devmode_create wrong type: " + type );
		return;
	}

	ent = createEffect( type );
	ent.v["origin"] = getEntArray("player","classname")[0].origin;
	level.selectedEffect = ent.id;

	TriggerEffect( ent );

	iPrintln( "Created and selected new effect #" + ent.id );
}


devmode_moveToPlayerPos( args )
{
	id = level.selectedEffect;
	if( id >= level.FX_Objects.size || id < 0 )
		return;

	ent = level.FX_Objects[id];
	ent.v["origin"] = getEntArray("player","classname")[0].origin;

	if( isDefined( ent.effect ) )
		ent.effect.origin = ent.v["origin"];

	TriggerEffect( level.FX_Objects[id] );
	TriggerEffect( level.FX_Objects[id] );

	iPrintln( "Moved effect #" + level.FX_Objects[id].id + " to player's position" );	
}

devmode_set( args )
{
	id = level.selectedEffect;
	if( id >= level.FX_Objects.size || id < 0 )
		return;

	ent = level.FX_Objects[id];

	if( args[1] == "fxid" || args[1] == "soundalias" )
		ent.v[ args[1] ] = args[2];
	else if( args[1] == "repeatDelay" )
		ent.v[ args[1] ] = int( args[2] );
	else
	{
		iPrintln( args[1] + " is an incorrect keyword" );
		return;
	}

	TriggerEffect( level.FX_Objects[id] );
	TriggerEffect( level.FX_Objects[id] );

	iPrintln( "devmode_set #" + level.FX_Objects[id].id + "ent.v[\"" + args[1] + "\"] changed to: " + args[2] );	
}

DeveloperLogic()
{
	level.selectedEffect = -1;

	level.fxDevCmds = [];
	DevCmd( "select", 2, ::devmode_selectFX );
	DevCmd( "trigger", 1, ::devmode_triggerFX );
	DevCmd( "move", 3, ::devmode_move );
	DevCmd( "rotate", 3, ::devmode_rotate );
	DevCmd( "save", 1, ::devmode_save );
	DevCmd( "create", 2, ::devmode_create );
	DevCmd( "toplayer", 1, ::devmode_moveToPlayerPos );
	DevCmd( "set", 3, ::devmode_set );

	setDvar( "cfx", "" );
	while( 1 )
	{
		dvarValue = getDvar( "cfx" );
		if( dvarValue != "" )
		{
			args = strTok( dvarValue, ":" );
			if( args.size )
			{
				for( i = 0; i < level.fxDevCmds.size; i++ )
				{
					cmd = level.fxDevCmds[i];
					if( cmd.v["name"] == args[0] && args.size >= cmd.v["argc"] )
					{
						thread [[ cmd.v["func_ptr"] ]]( args );
						break;
					}
				}
			}
			setDvar( "cfx", "" );
		}
		wait 0.1;
	}

}