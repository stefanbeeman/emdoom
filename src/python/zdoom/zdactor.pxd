from zdtypes cimport *

cdef extern from 'actor.h':
  cppclass FDecalBase:
    pass

  cppclass AInventory:
    pass

  cdef enum replace_t:
    pass

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
    FDropItem * Next
  cppclass AActor:
    void Destroy()
    AActor *StaticSpawn(const PClass *type, fixed_t x, fixed_t y, fixed_t z, replace_t allowreplacement, bool SpawningMapThing = false)
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
    int StartHealth
    BYTE WeaveIndexXY
    BYTE WeaveIndexZ
    int tid
    int special
    int args[5]
    int TIDtoHate
    int accuracy, stamina
    #FNameNoInit Species
    SWORD movecount
    SWORD strafecount
