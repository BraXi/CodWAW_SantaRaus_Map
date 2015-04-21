#include common_scripts\utility;
#include maps\_utility;
//#include maps\_anim;

/*
rawfile,maps/_zombie_capsule.gsc
xmodel,char_ger_honorgd_body1_1

xanim,ai_zombie_attack_v1
xanim,ai_zombie_attack_v2
xanim,ai_zombie_attack_v4
xanim,ai_zombie_attack_v6

Coded by BraXi 2014-12-05. 
*/

#using_animtree ("generic_human");

init()
{
	anims = [];
	anims[anims.size] = %ai_zombie_attack_v1; 
	anims[anims.size] = %ai_zombie_attack_v2;	
	anims[anims.size] = %ai_zombie_attack_v4;
	anims[anims.size] = %ai_zombie_attack_v6;
	
	mdls = [];
	mdls[mdls.size] = "char_ger_honorgd_body1_1";
	
	precacheModel( mdls[0] );

	level._capsule_anims = anims;
	level._capsule_mdls = mdls;

	level.v_capsuleZombies = [];


	waittillframeend;

	wait 3;
//	getEntArray( "zombie_capsule", "targetname" )[0] thread spawn_zombie();

	array_thread( getEntArray( "zombie_capsule", "targetname" ), ::spawn_zombie );
}


spawn_zombie()
{
	zom = spawn( "script_model", self.origin );

	// give him a random angle
	rand = randomInt( 45 );
	if( randomInt(2) == 0 )
		rand = !rand;

	zom.angles = self.angles + (0,rand,0);

	zom setModel( level._capsule_mdls[ randomInt(level._capsule_mdls.size) ] );

	zom thread zombie_think();

//	level.v_capsuleZombies[ level.v_capsuleZombies.size ] = zom;
}

zombie_think()
{
	if( !isDefined( self )
	{
		iprintln( "zombie_think(): SOMETHING WENT TERRIBLY WRONG!" );
		return;
	}

	id = randomint(level._capsule_anims.size);
	starttime = RandomFloatRange( 0, 1.0 );

	wait RandomFloat( 6.0 );

	time = GetAnimLength( level._capsule_anims[id] );
	self UseAnimTree( #animtree );
	self SetAnim( level._capsule_anims[id], 1, 0.1, 1 );
	self SetAnimTime( level._capsule_anims[id], starttime );

//	self setCanDamage(true);

	while( isDefined( self ) )
	{
		//self waittill( "damage" );
		self SetAnimRestart( level._capsule_anims[id], 1, 0.1, 1 );
		
//		self waittill( "animdone" );
//		self playsound( "zomb_fuck_you" );
		wait 2;
	}
}
