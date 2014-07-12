from zdtypes import *
cdef extern from 'Python.h': pass

cdef extern from 'p_acs.h':
  cppclass DLevelScript:
    static int Random(int min, int max)
    static int ThingCount (int type, int stringid, int tid, int tag)
    static void ChangeFlat (int tag, int name, bool floorOrCeiling)
    static int CountPlayers ()
    static void SetLineTexture (int lineid, int side, int position, int name)
    static void ReplaceTextures (int fromname, int toname, int flags)
    static int DoSpawn (int type, fixed_t x, fixed_t y, fixed_t z, int tid, int angle, bool force)
    static bool DoCheckActorTexture(int tid, AActor *activator, int string, bool floor)
    int DoSpawnSpot (int type, int spot, int tid, int angle, bool forced)
    int DoSpawnSpotFacing (int type, int spot, int tid, bool forced)
    int DoClassifyActor (int tid)
    int CallFunction(int argCount, int funcIndex, SDWORD *args, const SDWORD *stack, int stackdepth)
    void DoFadeTo (int r, int g, int b, int a, fixed_t time)
    void DoFadeRange (int r1, int g1, int b1, int a1, int r2, int g2, int b2, int a2, fixed_t time)
    void DoSetFont (int fontnum)
    void SetActorProperty (int tid, int property, int value)
    void DoSetActorProperty (AActor *actor, int property, int value)
    int GetActorProperty (int tid, int property, const SDWORD *stack, int stackdepth)
    int CheckActorProperty (int tid, int property, int value)
    int GetPlayerInput (int playernum, int inputnum)
    int LineFromID(int id)
    int SideFromID(int id, int side)