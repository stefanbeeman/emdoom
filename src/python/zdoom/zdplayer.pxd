from zdtypes cimport *
from zdactor cimport *
from zdcolor cimport *

cdef extern from 'd_player.h':
  cppclass APlayerPawn:
    void AddInventory(AInventory *item)
    void RemoveInventory(AInventory *item)
    void RemoveInventory(AInventory *item)
    void PlayIdle()
    void PlayRunning()
    void TweakSpeeds(int &forwardmove, int &sidemove)
    #AWeapon *PickNewWeapon (const PClass *ammotype)
    #AWeapon *BestWeapon(const PClass *ammotype)
    void CheckWeaponSwitch(const PClass *ammotype)
    void PlayAttacking()
    void PlayAttacking2()
    void Die(AActor *source, AActor *inflictor, int dmgflags)
    int crouchsprite
    int MaxHealth
    int MugShotMaxHealth
    int RunHealth
    int PlayerFlags
    fixed_t	JumpZ
    fixed_t	GruntSpeed
    fixed_t	FallingScreamMinSpeed, FallingScreamMaxSpeed
    fixed_t	ViewHeight
    fixed_t	ForwardMove1, ForwardMove2
    fixed_t	SideMove1, SideMove2
    fixed_t	AttackZOffset
    fixed_t	UseRange
    fixed_t	AirCapacity
    PalEntry DamageFade
    bool UpdateWaterLevel(fixed_t oldz, bool splash)
    bool ResetAirSupply(bool playgasp = true)
    int GetMaxHealth()

  cppclass FPlayerClass:
    FPlayerClass()
    bool CheckSkin(int skin)
    const PClass *Type
    DWORD Flags

  cppclass userinfo_t:
    int GetAimDist()
    const char *GetName()
    int GetTeam()
    int GetColorSet()
    uint32 GetColor()
    bool GetNeverSwitch()
    fixed_t GetMoveBob()
    fixed_t GetStillBob()
    const PClass *GetPlayerClassType()
    int GetSkin()
    int GetGender()

  cppclass player_t:
    player_t()
    APlayerPawn	*mo
    BYTE playerstate
    userinfo_t userinfo
    const PClass *cls
    float	DesiredFOV
    float	FOV
    fixed_t	viewz
    fixed_t	viewheight
    fixed_t	deltaviewheight
    fixed_t bob
    bool attackdown
    bool usedown
    int	health
    bool backpack
    int	cheats					# bit flags
    int timefreezer			# Player has an active time freezer
    short refire					# refired shots are less accurate
    short inconsistant
    bool waiting
    int killcount, itemcount, secretcount		# for intermission
    int	damagecount, bonuscount# for screen flashing
    int	hazardcount			# for delayed Strife damage
    int	poisoncount			# screen flash for poison damage
    FName poisontype				# type of poison damage to apply
    FName poisonpaintype			# type of Pain state to enter for poison damage
    #TObjPtr<AActor> poisoner		# NULL for non-player actors
    #TObjPtr<AActor> attacker		# who did damage (NULL for floors)
    int extralight # so gun flashes light up areas
    short fixedcolormap			# can be set to REDCOLORMAP, etc.
    short fixedlightlevel
    #pspdef_t psprites[NUMPSPRITES]	# view sprites (gun, etc)
    int morphTics				# player is a chicken/pig if > 0
    const PClass *MorphedPlayerClass		# [MH] (for SBARINFO) class # for this player instance when morphed
    int MorphStyle				# which effects to apply for this player instance when morphed
    const PClass *MorphExitFlash		# flash to apply when demorphing (cache of value given to P_MorphPlayer)
    #TObjPtr<AWeapon>	PremorphWeapon		# ready weapon before morphing
    int chickenPeck			# chicken peck countdown
    int	jumpTics				# delay the next jump for a moment
    bool onground				# Identifies if this player is on the ground or other object
    int	respawn_time			# [RH] delay respawning until this tic
    #TObjPtr<AActor>		camera			# [RH] Whose eyes this player sees through
    int air_finished			# [RH] Time when you start drowning
    FName	LastDamageType			# [RH] For damage-specific pain and death sounds
    #Added by MC:
    angle_t	savedyaw
    int	savedpitch
    angle_t	angle		# The wanted angle that the bot try to get every tic.
                    #  (used to get a smoth (;_;) view movement)
    #TObjPtr<AActor>		dest		# Move Destination.
    #TObjPtr<AActor>		prev		# Previous move destination.
    #TObjPtr<AActor>		enemy		# The dead meat.
    #TObjPtr<AActor>		missile	# A threatening missile that needs to be avoided.
    #TObjPtr<AActor>		mate		# Friend (used for grouping in teamplay or coop).
    #TObjPtr<AActor>		last_mate	# If bots mate disappeared (not if died) that mate is
                # pointed to by this. Allows bot to roam to it if
                # necessary.
    bool settings_controller	# Player can control game settings.
    #Skills
    #struct botskill_t	skill

    #Tickers
    int	t_active	# Open door, lower lift stuff, door must open and
                # lift must go down before bot does anything
                # radical like try a stuckmove
    int	t_respawn
    int	t_strafe
    int	t_react
    int	t_fight
    int	t_roam
    int	t_rocket

    #Misc booleans
    bool isbot
    bool first_shot	# Used for reaction skill.
    bool sleft		# If false, strafe is right.
    bool allround

    float	BlendR		# [RH] Final blending values
    float	BlendG
    float	BlendB
    float	BlendA
    FString	LogText	# [RH] Log for Strife

    int	MinPitch	# Viewpitch limits (negative is up, positive is down)
    int	MaxPitch

    SBYTE	crouching
    SBYTE	crouchdir
    fixed_t crouchfactor
    fixed_t crouchoffset
    fixed_t crouchviewdelta

    #FWeaponSlots weapons

    # [CW] I moved these here for multiplayer conversation support.
    #TObjPtr<AActor> ConversationNPC, ConversationPC
    angle_t ConversationNPCAngle
    bool ConversationFaceTalker

    fixed_t GetDeltaViewHeight()
    void Uncrouch()
    bool CanCrouch()
    int GetSpawnClass()


cdef class Player:
  cdef player_t* ptr

cdef Player python_init_player(player_t* ptr)
