from zdtypes cimport *

cdef extern from 'info.h':
  struct FState:
    FState *NextState
    WORD sprite
    SWORD Tics
    WORD TicRange
    BYTE Frame
    BYTE Fullbright
    BYTE Fast
    BYTE NoDelay
    BYTE CanRaise
    BYTE Slow

cdef extern from 'actor.h':
  cppclass FDecalBase:
    pass

  cppclass AInventory:
    pass

  cdef enum replace_t:
    NO_REPLACE = 0
    ALLOW_REPLACE = 1

  cdef enum EBounceFlags:
    pass

  cdef enum EThingSpecialActivationType:
    pass

  AActor *GetDefaultByName(const char *name)
  AActor *GetDefaultByType(const PClass *type)
  cdef struct FDropItem:
    FName Name
    int probability
    int amount
  cppclass AActor:
    void Destroy()
    AActor *GetDefault()
    FDropItem *GetDropItems()
    bool SuggestMissileAttack(fixed_t dist)
    bool AdjustReflectionAngle(AActor *thing, angle_t &angle)
    bool CheckMeleeRange()
    void Activate()
    void Deactivate()
    void Tick()
    void Die(AActor *source, AActor *inflictor, int dmgflags = 0)
    int DoSpecialDamage(AActor *target, int damage, FName damagetype)
    int TakeSpecialDamage(AActor *inflictor, AActor *source, int damage, FName damagetype)
    void PlayActiveSound()
    bool OkayToSwitchTarget(AActor *other)
    void AddInventory(AInventory *item)
    void RemoveInventory(AInventory *item)
    bool UseInventory(AInventory *item)
    AInventory *DropInventory(AInventory *item)
    bool CheckLocalView(int playernum)
    AInventory *FindInventory(const PClass *type, bool subclass = false)
    AInventory *FindInventory(FName type)
    AInventory *GiveInventoryType(const PClass *type)
    bool GiveAmmo(const PClass *type, int amount)
    void DestroyAllInventory()
    void SetShade(int r, int g, int b)
    void ConversationAnimation(int animnum)
    void CopyFriendliness(AActor *other, bool changeTarget, bool resetHealth)
    void ObtainInventory(AActor *other)
    bool Massacre()
    bool Grind(bool items)
    bool IsTeammate(AActor *other)
    bool IsFriend(AActor *other)
    bool IsHostile(AActor *other)
    FName GetSpecies()
    int SpawnHealth()
    int GibHealth()
    bool isMissile(bool precise)
    bool CountsAsKill()
    bool intersects(AActor *other)
    void SetPitch(int p, bool interpolate)
    void SetAngle(angle_t ang, bool interpolate)
    PClass *GetBloodType(int type)
    #void SetFriendPlayer(player_t *player)
    bool IsVisibleToPlayer()
    int GetMissileDamage(int mask, int add)
    bool CanSeek(AActor *target)
    fixed_t GetGravity()
    bool IsSentient()
    fixed_t x, y, z
    angle_t angle
    fixed_t scaleX, scaleY
    fixed_t alpha
    fixed_t pitch, roll
    fixed_t floorz, ceilingz
    fixed_t dropoffz
    fixed_t radius, height
    fixed_t velx, vely, velz
    SDWORD Damage
    int projectileKickback
    DWORD flags
    DWORD flags2
    DWORD flags3
    DWORD flags4
    DWORD flags5
    DWORD flags6
    DWORD flags7
    DWORD VisibleToTeam
    int special1
    int special2
    int health
    BYTE movedir
    SBYTE visdir
    SWORD movecount
    SWORD strafecount
    TObjPtr[AActor] target
    TObjPtr[AActor] lastenemy
    TObjPtr[AActor] LastHeard
    int StartHealth
    BYTE WeaveIndexXY
    BYTE WeaveIndexZ
    int TIDtoHate
    SWORD movecount
    SWORD strafecount
    SDWORD reactiontime
    TObjPtr[AActor] LastLookActor
    int StartHealth
    FNameNoInit Species
    TObjPtr[AActor] tracer
    TObjPtr[AActor] master
    int tid
    int special
    int args[5]
    int accuracy, stamina
    TObjPtr[AActor] goal
    int waterlevel
    BYTE boomwaterlevel
    BYTE MinMissileChance
    fixed_t meleerange
    fixed_t meleethreshold
    fixed_t maxtargetrange
    fixed_t bouncefactor
    fixed_t wallbouncefactor
    fixed_t gravity
    int Score
    int DesignatedTeam
    int PoisonDamage
    FNameNoInit PoisonDamageType
    int PoisonDuration
    int PoisonPeriod
    TObjPtr[AActor] Poisoner
    TObjPtr[AInventory] Inventory
    DWORD InventoryID
    SDWORD id
    fixed_t Speed
    fixed_t FloatSpeed
    fixed_t MaxDropOffHeight, MaxStepHeight
    SDWORD Mass
    SWORD PainChance
    int PainThreshold
    FNameNoInit DamageType
    FNameNoInit DamageTypeReceived
    fixed_t DamageFactor
    FNameNoInit PainType
    FNameNoInit DeathType
    FState *SpawnState
    FState *SeeState
    FState *MeleeState
    FState *MissileState
    FDecalBase *DecalGenerator
    void AdjustFloorClip()
    void SetOrigin(fixed_t x, fixed_t y, fixed_t z)
    bool InStateSequence(FState * newstate, FState * basestate)
    int GetTics(FState * newstate)
    bool SetState(FState *newstate, bool nofunction=false)
    bool UpdateWaterLevel(fixed_t oldz, bool splash=true)
    bool isFast()
    bool isSlow()
    void SetIdle()
    void ClearCounters()
    FState *GetRaiseState()
    void Revive()
  AActor *Spawn(const char *type, fixed_t x, fixed_t y, fixed_t z, replace_t allowreplacement)