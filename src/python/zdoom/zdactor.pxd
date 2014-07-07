cimport zdtypes
cimport zdflags

cdef extern from "actor.h":
  enum replace_t:
    NO_REPLACE = 0
    ALLOW_REPLACE = 1
  cppclass AInventory:
    pass
  cppclass AActor:
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
    void CopyFriendliness(AActor *other, bool changeTarget, bool resetHealth=true)
    void ObtainInventory(AActor *other)
    bool Massacre()
    bool Grind(bool items)
    bool IsTeammate(AActor *other)
    bool IsFriend(AActor *other)
    bool IsHostile(AActor *other)
    FName GetSpecies()
    int SpawnHealth()
    int GibHealth()
    bool isMissile(bool precise=true)
    bool CountsAsKill()
    bool intersects(AActor *other)
    void SetPitch(int p, bool interpolate)
    void SetAngle(angle_t ang, bool interpolate)
    PClass *GetBloodType(int type = 0)
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
    int health
    int StartHealth