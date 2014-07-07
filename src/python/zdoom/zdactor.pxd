cimport zdtypes
cimport zdflags

cdef extern from 'actor.h':
  enum replace_t:
    NO_REPLACE = 0
    ALLOW_REPLACE = 1
  cppclass FDecalBase:
    pass
  cppclass AInventory:
    pass
  AActor *GetDefaultByName(const char *name)
  AActor *GetDefaultByType(const PClass *type)
  enum:
    AMETA_BASE = 0x12000
    AMETA_Obituary     # string (player was killed by this actor)
    AMETA_HitObituary    # string (player was killed by this actor in melee)
    AMETA_DeathHeight    # fixed (height on normal death)
    AMETA_BurnHeight   # fixed (height on burning death)
    AMETA_StrifeName   # string (for named Strife objects)
    AMETA_BloodColor   # colorized blood
    AMETA_GibHealth    # negative health below which this monster dies an extreme death
    AMETA_WoundHealth    # health needed to enter wound state
    AMETA_FastSpeed    # Speed in fast mode
    AMETA_RDFactor     # Radius damage factor
    AMETA_CameraHeight   # Height of camera when used as such
    AMETA_HowlSound    # Sound being played when electrocuted or poisoned
    AMETA_BloodType    # Blood replacement type
    AMETA_BloodType2   # Bloodsplatter replacement type
    AMETA_BloodType3   # AxeBlood replacement type
  struct FDropItem:
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
    void SetFriendPlayer(player_t *player)
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
    FNameNoInit Species
    SWORD movecount
    SWORD strafecount