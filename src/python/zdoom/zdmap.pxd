from zdtypes cimport *
cdef extern from "Python.h":
  pass

cdef extern from 'g_level.h':
  struct level_info_t:
    FString MapName
    FString NextMap
    FString NextSecretMap
    FString PName
    FString SkyPic1
    FString SkyPic2
    FString FadeTable
    FString F1Pic
    FString BorderTexture
    FString MapBackground
    int cluster
    int partime
    int sucktime
    DWORD flags
    DWORD flags2
    FString Music
    FString LevelName
    SBYTE WallVertLight
    SBYTE WallHorizLight
    int musicorder
    float skyspeed1
    float skyspeed2
    DWORD fadeto
    DWORD outsidefog
    int cdtrack
    unsigned int cdid
    float gravity
    float aircontrol
    int WarpTrans
    int airsupply
    FName Intermission
    FName deathsequence
    FName slideshow
    FName RedirectType
    FString RedirectMapName
    FString EnterPic
    FString ExitPic
    # level_info_t *CheckLevelRedirect()

  struct FLevelLocals:
    # void Tick()
    int time # time in the hub
    int maptime # time in the map
    int totaltime # time in the game
    int starttime
    int partime
    int sucktime
    level_info_t *info
    int cluster
    int clusterflags
    int levelnum
    int lumpnum
    FString LevelName
    FString MapName      # the lump name (E1M1, MAP01, etc)
    FString NextMap      # go here when using the regular exit
    FString NextSecretMap    # map to go to when used secret exit
    #EMapType maptype
    DWORD flags
    DWORD flags2
    DWORD fadeto         # The color the palette fades to (usually black)
    DWORD outsidefog       # The fog for sectors with sky ceilings
    FString Music
    int musicorder
    int cdtrack
    unsigned int cdid
    int nextmusic        # For MUSINFO purposes
    #FTextureID skytexture1
    #FTextureID skytexture2
    float skyspeed1        # Scrolling speed of sky textures, in pixels per ms
    float skyspeed2
    int total_secrets
    int found_secrets
    int total_items
    int found_items
    int total_monsters
    int killed_monsters
    float gravity
    fixed_t aircontrol
    fixed_t airfriction
    int airsupply
    int DefaultEnvironment   # Default sound environment.
    #TObjPtr<class ASkyViewpoint> DefaultSkybox
    # FSectorScrollValues *Scrolls   # NULL if no DScrollers in this level
    SBYTE WallVertLight      # Light diffs for vert/horiz walls
    SBYTE WallHorizLight
    bool FromSnapshot     # The current map was restored from a snapshot
    float teamdamage
    # bool IsJumpingAllowed()
    # bool IsCrouchingAllowed()
    # bool IsFreelookAllowed()

  struct cluster_info_t:
    int cluster
    FString FinaleFlat
    FString ExitText
    FString EnterText
    FString MessageMusic
    int musicorder
    int flags
    int cdtrack
    FString ClusterName
    unsigned int cdid
    # void Reset()