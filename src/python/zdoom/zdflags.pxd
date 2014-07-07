cdef extern from 'actor.h':
  enum:
    # --- mobj.flags ---
    MF_SPECIAL = 0x00000001 # call P_SpecialThing when touched
    MF_SOLID = 0x00000002
    MF_SHOOTABLE = 0x00000004
    MF_NOSECTOR = 0x00000008 # don't use the sector links (invisible but touchable)
    MF_NOBLOCKMAP = 0x00000010 # don't use the blocklinks (inert but displayable)
    MF_AMBUSH = 0x00000020 # not activated by sound; deaf monster
    MF_JUSTHIT = 0x00000040 # try to attack right back
    MF_JUSTATTACKED = 0x00000080 # take at least one step before attacking
    MF_SPAWNCEILING = 0x00000100 # hang from ceiling instead of floor
    MF_NOGRAVITY = 0x00000200 # don't apply gravity every tic
    # movement flags
    MF_DROPOFF = 0x00000400 # allow jumps from high places
    MF_PICKUP = 0x00000800 # for players to pick up items
    MF_NOCLIP = 0x00001000 # player cheat
    MF_INCHASE = 0x00002000 # [RH] used by A_Chase and A_Look to avoid recursion
    MF_FLOAT = 0x00004000 # allow moves to any height no gravity
    MF_TELEPORT = 0x00008000 # don't cross lines or look at heights
    MF_MISSILE = 0x00010000 # don't hit same species explode on block
    MF_DROPPED = 0x00020000 # dropped by a demon not level spawned
    MF_SHADOW = 0x00040000 # actor is hard for monsters to see
    MF_NOBLOOD = 0x00080000 # don't bleed when shot (use puff)
    MF_CORPSE = 0x00100000 # don't stop moving halfway off a step
    MF_INFLOAT = 0x00200000 # floating to a height for a move don't auto float to target's height
    MF_INBOUNCE = 0x00200000 # used by Heretic bouncing missiles 
    MF_COUNTKILL = 0x00400000 # count towards intermission kill total
    MF_COUNTITEM = 0x00800000 # count towards intermission item total
    MF_SKULLFLY = 0x01000000 # skull in flight
    MF_NOTDMATCH = 0x02000000 # don't spawn in death match (key cards)
    MF_SPAWNSOUNDSOURCE = 0x04000000 # Plays missile's see sound at spawning object.
    MF_FRIENDLY = 0x08000000 # [RH] Friendly monsters for Strife (and MBF)
    MF_UNMORPHED = 0x10000000 # [RH] Actor is the unmorphed version of something else
    MF_NOLIFTDROP = 0x20000000 # [RH] Used with MF_NOGRAVITY to avoid dropping with lifts
    MF_STEALTH = 0x40000000 # [RH] Andy Baker's stealth monsters
    MF_ICECORPSE = 0x80000000 # a frozen corpse (for blasting) [RH] was 0x800000

    # --- mobj.flags2 ---
    MF2_DONTREFLECT = 0x00000001 # this projectile cannot be reflected
    MF2_WINDTHRUST = 0x00000002 # gets pushed around by the wind specials
    MF2_DONTSEEKINVISIBLE =0x00000004 # For seeker missiles: Don't home in on invisible/shadow targets
    MF2_BLASTED = 0x00000008 # actor will temporarily take damage from impact
    MF2_FLY = 0x00000010 # fly mode is active
    MF2_FLOORCLIP = 0x00000020 # if feet are allowed to be clipped
    MF2_SPAWNFLOAT = 0x00000040 # spawn random float z
    MF2_NOTELEPORT = 0x00000080 # does not teleport
    MF2_RIP = 0x00000100 # missile rips through solid targets
    MF2_PUSHABLE = 0x00000200 # can be pushed by other moving actors
    MF2_SLIDE = 0x00000400 # slides against walls
    MF2_ONMOBJ = 0x00000800 # actor is resting on top of another actor
    MF2_PASSMOBJ = 0x00001000 # Enable z block checking. If on this flag will allow the actor to pass over/under other actors.
    MF2_CANNOTPUSH = 0x00002000 # cannot push other pushable mobjs
    MF2_THRUGHOST = 0x00004000 # missile will pass through ghosts [RH] was 8
    MF2_BOSS = 0x00008000 # mobj is a major boss
    MF2_DONTTRANSLATE = 0x00010000 # Don't apply palette translations
    MF2_NODMGTHRUST = 0x00020000 # does not thrust target when damaging
    MF2_TELESTOMP = 0x00040000 # mobj can stomp another
    MF2_FLOATBOB = 0x00080000 # use float bobbing z movement
    MF2_THRUACTORS = 0x00100000 # performs no actor<->actor collision checks
    MF2_IMPACT = 0x00200000   # an MF_MISSILE mobj can activate SPAC_IMPACT
    MF2_PUSHWALL = 0x00400000   # mobj can push walls
    MF2_MCROSS = 0x00800000 # can activate monster cross lines
    MF2_PCROSS = 0x01000000 # can activate projectile cross lines
    MF2_CANTLEAVEFLOORPIC =0x02000000 # stay within a certain floor type
    MF2_NONSHOOTABLE = 0x04000000 # mobj is totally non-shootable but still considered solid
    MF2_INVULNERABLE = 0x08000000 # mobj is invulnerable
    MF2_DORMANT = 0x10000000 # thing is dormant
    MF2_ARGSDEFINED = 0x20000000 # Internal flag used by DECORATE to signal that the args should not be taken from the mapthing definition
    MF2_SEEKERMISSILE = 0x40000000 # is a seeker (for reflection)
    MF2_REFLECTIVE = 0x80000000 # reflects missiles

    # --- mobj.flags3 ---
    MF3_FLOORHUGGER = 0x00000001 # Missile stays on floor
    MF3_CEILINGHUGGER = 0x00000002 # Missile stays on ceiling
    MF3_NORADIUSDMG = 0x00000004 # Actor does not take radius damage
    MF3_GHOST = 0x00000008 # Actor is a ghost
    MF3_ALWAYSPUFF = 0x00000010 # Puff always appears even when hit nothing
    MF3_SPECIALFLOORCLIP = 0x00000020 # Actor uses floorclip for special effect (e.g. Wraith)
    MF3_DONTSPLASH = 0x00000040 # Thing doesn't make a splash
    MF3_NOSIGHTCHECK = 0x00000080 # Go after first acceptable target without checking sight
    MF3_DONTOVERLAP = 0x00000100 # Don't pass over/under other things with this bit set
    MF3_DONTMORPH = 0x00000200 # Immune to arti_egg
    MF3_DONTSQUASH = 0x00000400 # Death ball can't squash this actor
    MF3_EXPLOCOUNT = 0x00000800 # Don't explode until special2 counts to special1
    MF3_FULLVOLACTIVE = 0x00001000 # Active sound is played at full volume
    MF3_ISMONSTER = 0x00002000 # Actor is a monster
    MF3_SKYEXPLODE = 0x00004000 # Explode missile when hitting sky
    MF3_STAYMORPHED = 0x00008000 # Monster cannot unmorph
    MF3_DONTBLAST = 0x00010000 # Actor cannot be pushed by blasting
    MF3_CANBLAST = 0x00020000 # Actor is not a monster but can be blasted
    MF3_NOTARGET = 0x00040000 # This actor not targetted when it hurts something else
    MF3_DONTGIB = 0x00080000 # Don't gib this corpse
    MF3_NOBLOCKMONST = 0x00100000 # Can cross ML_BLOCKMONSTERS lines
    MF3_CRASHED = 0x00200000 # Actor entered its crash state
    MF3_FULLVOLDEATH = 0x00400000 # DeathSound is played full volume (for missiles)
    MF3_AVOIDMELEE = 0x00800000 # Avoids melee attacks (same as MBF's monster_backing but must be explicitly set)
    MF3_SCREENSEEKER = 0x01000000 # Fails the IsOkayToAttack test if potential target is outside player FOV
    MF3_FOILINVUL = 0x02000000 # Actor can hurt MF2_INVULNERABLE things
    MF3_NOTELEOTHER = 0x04000000 # Monster is unaffected by teleport other artifact
    MF3_BLOODLESSIMPACT = 0x08000000 # Projectile does not leave blood
    MF3_NOEXPLODEFLOOR = 0x10000000 # Missile stops at floor instead of exploding
    MF3_WARNBOT = 0x20000000 # Missile warns bot
    MF3_PUFFONACTORS = 0x40000000 # Puff appears even when hit bleeding actors
    MF3_HUNTPLAYERS = 0x80000000 # Used with TIDtoHate means to hate players too

    # --- mobj.flags4 ---
    MF4_NOHATEPLAYERS = 0x00000001 # Ignore player attacks
    MF4_QUICKTORETALIATE = 0x00000002 # Always switch targets when hurt
    MF4_NOICEDEATH = 0x00000004 # Actor never enters an ice death not even the generic one
    MF4_BOSSDEATH = 0x00000008 # A_FreezeDeathChunks calls A_BossDeath
    MF4_RANDOMIZE = 0x00000010 # Missile has random initial tic count
    MF4_NOSKIN = 0x00000020 # Player cannot use skins
    MF4_FIXMAPTHINGPOS = 0x00000040 # Fix this actor's position when spawned as a map thing
    MF4_ACTLIKEBRIDGE = 0x00000080 # Pickups can "stand" on this actor / cannot be moved by any sector action.
    MF4_STRIFEDAMAGE = 0x00000100 # Strife projectiles only do up to 4x damage not 8x
    MF4_CANUSEWALLS = 0x00000200 # Can activate 'use' specials
    MF4_MISSILEMORE = 0x00000400 # increases the chance of a missile attack
    MF4_MISSILEEVENMORE = 0x00000800 # significantly increases the chance of a missile attack
    MF4_FORCERADIUSDMG = 0x00001000 # if put on an object it will override MF3_NORADIUSDMG
    MF4_DONTFALL = 0x00002000 # Doesn't have NOGRAVITY disabled when dying.
    MF4_SEESDAGGERS = 0x00004000 # This actor can see you striking with a dagger
    MF4_INCOMBAT = 0x00008000 # Don't alert others when attacked by a dagger
    MF4_LOOKALLAROUND = 0x00010000 # Monster has eyes in the back of its head
    MF4_STANDSTILL = 0x00020000 # Monster should not chase targets unless attacked?
    MF4_SPECTRAL = 0x00040000
    MF4_SCROLLMOVE = 0x00080000 # velocity has been applied by a scroller
    MF4_NOSPLASHALERT = 0x00100000 # Splashes don't alert this monster
    MF4_SYNCHRONIZED = 0x00200000 # For actors spawned at load-time only: Do not randomize tics
    MF4_NOTARGETSWITCH = 0x00400000 # monster never switches target until current one is dead
    MF4_VFRICTION = 0x00800000 # Internal flag used by A_PainAttack to push a monster down
    MF4_DONTHARMCLASS = 0x01000000 # Don't hurt one's own kind with explosions (hitscans too?)
    MF4_SHIELDREFLECT = 0x02000000
    MF4_DEFLECT = 0x04000000 # different projectile reflection styles
    MF4_ALLOWPARTICLES = 0x08000000 # this puff type can be replaced by particles
    MF4_NOEXTREMEDEATH = 0x10000000 # this projectile or weapon never gibs its victim
    MF4_EXTREMEDEATH = 0x20000000 # this projectile or weapon always gibs its victim
    MF4_FRIGHTENED = 0x40000000 # Monster runs away from player
    MF4_BOSSSPAWNED = 0x80000000 # Spawned by a boss spawn cube
    
    # --- mobj.flags5 ---
    MF5_DONTDRAIN = 0x00000001 # cannot be drained health from.
    MF5_NODROPOFF = 0x00000004 # cannot drop off under any circumstances.
    MF5_NOFORWARDFALL = 0x00000008 # Does not make any actor fall forward by being damaged by this
    MF5_COUNTSECRET = 0x00000010 # From Doom 64: actor acts like a secret
    MF5_AVOIDINGDROPOFF = 0x00000020 # Used to move monsters away from dropoffs
    MF5_NODAMAGE = 0x00000040 # Actor can be shot and reacts to being shot but takes no damage
    MF5_CHASEGOAL = 0x00000080 # Walks to goal instead of target if a valid goal is set.
    MF5_BLOODSPLATTER = 0x00000100 # Blood splatter like in Raven's games.
    MF5_OLDRADIUSDMG = 0x00000200 # Use old radius damage code (for barrels and boss brain)
    MF5_DEHEXPLOSION = 0x00000400 # Use the DEHACKED explosion options when this projectile explodes
    MF5_PIERCEARMOR = 0x00000800 # Armor doesn't protect against damage from this actor
    MF5_NOBLOODDECALS = 0x00001000 # Actor bleeds but doesn't spawn blood decals
    MF5_USESPECIAL = 0x00002000 # Actor executes its special when being 'used'.
    MF5_NOPAIN = 0x00004000 # If set the pain state won't be entered
    MF5_ALWAYSFAST = 0x00008000 # always uses 'fast' attacking logic
    MF5_NEVERFAST = 0x00010000 # never uses 'fast' attacking logic
    MF5_ALWAYSRESPAWN = 0x00020000 # always respawns regardless of skill setting
    MF5_NEVERRESPAWN = 0x00040000 # never respawns regardless of skill setting
    MF5_DONTRIP = 0x00080000 # Ripping projectiles explode when hitting this actor
    MF5_NOINFIGHTING = 0x00100000 # This actor doesn't switch target when it's hurt 
    MF5_NOINTERACTION = 0x00200000 # Thing is completely excluded from any gameplay related checks
    MF5_NOTIMEFREEZE = 0x00400000 # Actor is not affected by time freezer
    MF5_PUFFGETSOWNER = 0x00800000 # [BB] Sets the owner of the puff to the player who fired it
    MF5_SPECIALFIREDAMAGE =0x01000000 # Special treatment of PhoenixFX1 turned into a flag to remove  dependence of main engine code of specific actor types.
    MF5_SUMMONEDMONSTER = 0x02000000 # To mark the friendly Minotaur. Hopefully to be generalized later.
    MF5_NOVERTICALMELEERANGE =0x04000000# Does not check vertical distance for melee range
    MF5_BRIGHT = 0x08000000 # Actor is always rendered fullbright
    MF5_CANTSEEK = 0x10000000 # seeker missiles cannot home in on this actor
    MF5_INCONVERSATION = 0x20000000 # Actor is having a conversation
    MF5_PAINLESS = 0x40000000 # Actor always inflicts painless damage.
    MF5_MOVEWITHSECTOR = 0x80000000 # P_ChangeSector() will still process this actor if it has MF_NOBLOCKMAP

    # --- mobj.flags6 ---
    MF6_NOBOSSRIP = 0x00000001 # For rippermissiles: Don't rip through bosses.
    MF6_THRUSPECIES = 0x00000002 # Actors passes through other of the same species.
    MF6_MTHRUSPECIES = 0x00000004 # Missile passes through actors of its shooter's species.
    MF6_FORCEPAIN = 0x00000008 # forces target into painstate (unless it has the NOPAIN flag)
    MF6_NOFEAR = 0x00000010 # Not scared of frightening players
    MF6_BUMPSPECIAL = 0x00000020 # Actor executes its special when being collided (as the ST flag)
    MF6_DONTHARMSPECIES = 0x00000040 # Don't hurt one's own species with explosions (hitscans too?)
    MF6_STEPMISSILE = 0x00000080 # Missile can "walk" up steps
    MF6_NOTELEFRAG = 0x00000100 # [HW] Actor can't be telefragged
    MF6_TOUCHY = 0x00000200 # From MBF: killough 11/98: dies when solids touch it
    MF6_CANJUMP = 0x00000400 # From MBF: a dedicated flag instead of the BOUNCES+FLOAT+sentient combo
    MF6_JUMPDOWN = 0x00000800 # From MBF: generalization of dog behavior wrt. dropoffs.
    MF6_VULNERABLE = 0x00001000 # Actor can be damaged (even if not shootable).
    MF6_ARMED = 0x00002000 # From MBF: Object is armed (for MF6_TOUCHY objects)
    MF6_FALLING = 0x00004000 # From MBF: Object is falling (for pseudotorque simulation)
    MF6_LINEDONE = 0x00008000 # From MBF: Object has already run a line effect
    MF6_NOTRIGGER = 0x00010000 # actor cannot trigger any line actions
    MF6_SHATTERING = 0x00020000 # marks an ice corpse for forced shattering
    MF6_KILLED = 0x00040000 # Something that was killed (but not necessarily a corpse)
    MF6_BLOCKEDBYSOLIDACTORS = 0x00080000 # Blocked by solid actors even if not solid itself
    MF6_ADDITIVEPOISONDAMAGE = 0x00100000
    MF6_ADDITIVEPOISONDURATION = 0x00200000
    MF6_NOMENU = 0x00400000 # Player class should not appear in the class selection menu.
    MF6_BOSSCUBE = 0x00800000 # Actor spawned by A_BrainSpit flagged for timefreeze reasons.
    MF6_SEEINVISIBLE = 0x01000000 # Monsters can see invisible player.
    MF6_DONTCORPSE = 0x02000000 # [RC] Don't autoset MF_CORPSE upon death and don't force Crash state change.
    MF6_POISONALWAYS = 0x04000000 # Always apply poison even when target can't take the damage.
    MF6_DOHARMSPECIES = 0x08000000 # Do hurt one's own species with projectiles.
    MF6_INTRYMOVE = 0x10000000 # Executing P_TryMove
    MF6_NOTAUTOAIMED = 0x20000000 # Do not subject actor to player autoaim.
    MF6_NOTONAUTOMAP = 0x40000000 # will not be shown on automap with the 'scanner' powerup.
    MF6_RELATIVETOFLOOR = 0x80000000 # [RC] Make flying actors be affected by lifts.

    # --- mobj.flags7 ---
    MF7_NEVERTARGET = 0x00000001 # can not be targetted at all even if monster friendliness is considered.
    MF7_NOTELESTOMP = 0x00000002 # cannot telefrag under any circumstances (even when set by MAPINFO)
    MF7_ALWAYSTELEFRAG = 0x00000004 # will unconditionally be telefragged when in the way. Overrides all other settings.
    MF7_HANDLENODELAY = 0x00000008 # respect NoDelay state flag

    # --- mobj.renderflags ---
    RF_XFLIP = 0x0001 # Flip sprite horizontally
    RF_YFLIP = 0x0002 # Flip sprite vertically
    RF_ONESIDED = 0x0004 # Wall/floor sprite is visible from front only
    RF_FULLBRIGHT = 0x0010 # Sprite is drawn at full brightness
    RF_RELMASK = 0x0300 # ---Relative z-coord for bound actors (these obey texture pegging)
    RF_RELABSOLUTE = 0x0000 # Actor z is absolute
    RF_RELUPPER = 0x0100 # Actor z is relative to upper part of wall
    RF_RELLOWER = 0x0200 # Actor z is relative to lower part of wall
    RF_RELMID = 0x0300 # Actor z is relative to middle part of wall
    RF_CLIPMASK = 0x0c00 # ---Clipping for bound actors
    RF_CLIPFULL = 0x0000 # Clip sprite to full height of wall
    RF_CLIPUPPER = 0x0400 # Clip sprite to upper part of wall
    RF_CLIPMID = 0x0800 # Clip sprite to mid part of wall
    RF_CLIPLOWER = 0x0c00 # Clip sprite to lower part of wall
    RF_DECALMASK = RF_RELMASK|RF_CLIPMASK
    RF_SPRITETYPEMASK = 0x7000 # ---Different sprite types not all implemented
    RF_FACESPRITE = 0x0000 # Face sprite
    RF_WALLSPRITE = 0x1000 # Wall sprite
    RF_FLOORSPRITE = 0x2000 # Floor sprite
    RF_VOXELSPRITE = 0x3000 # Voxel object
    RF_INVISIBLE = 0x8000 # Don't bother drawing this actor
    RF_FORCEYBILLBOARD = 0x10000  # [BB] OpenGL only: draw with y axis billboard i.e. anchored to the floor (overrides gl_billboard_mode setting)
    RF_FORCEXYBILLBOARD = 0x20000  # [BB] OpenGL only: draw with xy axis billboard i.e. unanchored (overrides gl_billboard_mode setting)
    
    # --- dummies for unknown/unimplemented Strife flags ---
    MF_STRIFEx8000000 = 0 # seems related to MF_SHADOW
  
  enum EBounceFlags:
    BOUNCE_Walls = 1<<0    # bounces off of walls
    BOUNCE_Floors = 1<<1   # bounces off of floors
    BOUNCE_Ceilings = 1<<2   # bounces off of ceilings
    BOUNCE_Actors = 1<<3   # bounces off of some actors
    BOUNCE_AllActors = 1<<4  # bounces off of all actors (requires BOUNCE_Actors to be set too)
    BOUNCE_AutoOff = 1<<5    # when bouncing off a sector plane if the new Z velocity is below 3.0 disable further bouncing
    BOUNCE_HereticType = 1<<6  # goes into Death state when bouncing on floors or ceilings
    BOUNCE_UseSeeSound = 1<<7  # compatibility fallback. This will only be set by the compatibility handlers for the old bounce flags.
    BOUNCE_NoWallSound = 1<<8  # don't make noise when bouncing off a wall
    BOUNCE_Quiet = 1<<9    # Strife's grenades don't make a bouncing sound
    BOUNCE_ExplodeOnWater = 1<<10  # explodes when hitting a water surface
    BOUNCE_CanBounceWater = 1<<11  # can bounce on water
    BOUNCE_MBF = 1<<12     # This in itself is not a valid mode but replaces MBF's MF_BOUNCE flag.
    BOUNCE_AutoOffFloorOnly = 1<<13    # like BOUNCE_AutoOff but only on floors
    BOUNCE_UseBounceState = 1<<14  # Use Bounce[.*] states
    BOUNCE_TypeMask = BOUNCE_Walls | BOUNCE_Floors | BOUNCE_Ceilings | BOUNCE_Actors | BOUNCE_AutoOff | BOUNCE_HereticType | BOUNCE_MBF
    BOUNCE_None = 0
    BOUNCE_Heretic = BOUNCE_Floors | BOUNCE_Ceilings | BOUNCE_HereticType
    BOUNCE_Doom = BOUNCE_Walls | BOUNCE_Floors | BOUNCE_Ceilings | BOUNCE_Actors | BOUNCE_AutoOff
    BOUNCE_Hexen = BOUNCE_Walls | BOUNCE_Floors | BOUNCE_Ceilings | BOUNCE_Actors
    BOUNCE_Grenade = BOUNCE_MBF | BOUNCE_Doom    # Bounces on walls and flats like ZDoom bounce.
    BOUNCE_Classic = BOUNCE_MBF | BOUNCE_Floors | BOUNCE_Ceilings  # Bounces on flats only but does not die when bouncing.
    BOUNCE_DoomCompat = BOUNCE_Doom | BOUNCE_UseSeeSound
    BOUNCE_HereticCompat = BOUNCE_Heretic | BOUNCE_UseSeeSound
    BOUNCE_HexenCompat = BOUNCE_Hexen | BOUNCE_UseSeeSound
    # The distinction between BOUNCE_Actors and BOUNCE_AllActors: A missile with
    # BOUNCE_Actors set will bounce off of reflective and "non-sentient" actors.
    # A missile that also has BOUNCE_AllActors set will bounce off of any actor.
    # For compatibility reasons when BOUNCE_Actors was implied by the bounce type
    # being "Doom" or "Hexen" and BOUNCE_AllActors was the separate
    # MF5_BOUNCEONACTORS you must set BOUNCE_Actors for BOUNCE_AllActors to have
    # an effect.

enum EThingSpecialActivationType:
  THINGSPEC_Default = 0    # Normal behavior: a player must be the trigger and is the activator
  THINGSPEC_ThingActs = 1    # The thing itself is the activator of the special
  THINGSPEC_ThingTargets = 1<<1   # The thing changes its target to the trigger
  THINGSPEC_TriggerTargets = 1<<2   # The trigger changes its target to the thing
  THINGSPEC_MonsterTrigger = 1<<3   # The thing can be triggered by a monster
  THINGSPEC_MissileTrigger = 1<<4   # The thing can be triggered by a projectile
  THINGSPEC_ClearSpecial = 1<<5   # Clears special after successful activation
  THINGSPEC_NoDeathSpecial = 1<<6   # Don't activate special on death
  THINGSPEC_TriggerActs = 1<<7   # The trigger is the activator of the special (overrides LEVEL_ACTOWNSPECIAL Hexen hack)
  THINGSPEC_Activate = 1<<8   # The thing is activated when triggered
  THINGSPEC_Deactivate = 1<<9   # The thing is deactivated when triggered
  THINGSPEC_Switch = 1<<10  # The thing is alternatively activated and deactivated when triggered