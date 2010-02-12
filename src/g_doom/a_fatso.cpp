/*
#include "actor.h"
#include "info.h"
#include "m_random.h"
#include "s_sound.h"
#include "p_local.h"
#include "p_enemy.h"
#include "gstrings.h"
#include "a_action.h"
#include "thingdef/thingdef.h"
*/

//
// Mancubus attack,
// firing three missiles in three different directions?
// Doesn't look like it.
//
#define FATSPREAD (ANG90/8)

DEFINE_ACTION_FUNCTION(AActor, A_FatRaise)
{
	PARAM_ACTION_PROLOGUE;

	A_FaceTarget (self);
	S_Sound (self, CHAN_WEAPON, "fatso/raiseguns", 1, ATTN_NORM);
	return 0;
}

DEFINE_ACTION_FUNCTION_PARAMS(AActor, A_FatAttack1)
{
	PARAM_ACTION_PROLOGUE;
	PARAM_CLASS_OPT(spawntype, AActor)	{ spawntype = NULL; }

	AActor *missile;
	angle_t an;

	if (!self->target)
		return 0;

	if (spawntype == NULL) spawntype = PClass::FindClass("FatShot");

	A_FaceTarget (self);
	// Change direction  to ...
	self->angle += FATSPREAD;
	P_SpawnMissile (self, self->target, spawntype);

	missile = P_SpawnMissile (self, self->target, spawntype);
	if (missile != NULL)
	{
		missile->angle += FATSPREAD;
		an = missile->angle >> ANGLETOFINESHIFT;
		missile->velx = FixedMul (missile->Speed, finecosine[an]);
		missile->vely = FixedMul (missile->Speed, finesine[an]);
	}
	return 0;
}

DEFINE_ACTION_FUNCTION_PARAMS(AActor, A_FatAttack2)
{
	PARAM_ACTION_PROLOGUE;
	PARAM_CLASS_OPT(spawntype, AActor)	{ spawntype = NULL; }

	AActor *missile;
	angle_t an;

	if (!self->target)
		return 0;

	if (spawntype == NULL) spawntype = PClass::FindClass("FatShot");

	A_FaceTarget (self);
	// Now here choose opposite deviation.
	self->angle -= FATSPREAD;
	P_SpawnMissile (self, self->target, spawntype);

	missile = P_SpawnMissile (self, self->target, spawntype);
	if (missile != NULL)
	{
		missile->angle -= FATSPREAD*2;
		an = missile->angle >> ANGLETOFINESHIFT;
		missile->velx = FixedMul (missile->Speed, finecosine[an]);
		missile->vely = FixedMul (missile->Speed, finesine[an]);
	}
	return 0;
}

DEFINE_ACTION_FUNCTION_PARAMS(AActor, A_FatAttack3)
{
	PARAM_ACTION_PROLOGUE;
	PARAM_CLASS_OPT(spawntype, AActor)	{ spawntype = NULL; }

	AActor *missile;
	angle_t an;

	if (!self->target)
		return 0;

	if (spawntype == NULL) spawntype = PClass::FindClass("FatShot");

	A_FaceTarget (self);
	
	missile = P_SpawnMissile (self, self->target, spawntype);
	if (missile != NULL)
	{
		missile->angle -= FATSPREAD/2;
		an = missile->angle >> ANGLETOFINESHIFT;
		missile->velx = FixedMul (missile->Speed, finecosine[an]);
		missile->vely = FixedMul (missile->Speed, finesine[an]);
	}

	missile = P_SpawnMissile (self, self->target, spawntype);
	if (missile != NULL)
	{
		missile->angle += FATSPREAD/2;
		an = missile->angle >> ANGLETOFINESHIFT;
		missile->velx = FixedMul (missile->Speed, finecosine[an]);
		missile->vely = FixedMul (missile->Speed, finesine[an]);
	}
	return 0;
}

//
// killough 9/98: a mushroom explosion effect, sorta :)
// Original idea: Linguica
//

AActor * P_OldSpawnMissile(AActor * source, AActor * dest, const PClass *type);

DEFINE_ACTION_FUNCTION_PARAMS(AActor, A_Mushroom)
{
	PARAM_ACTION_PROLOGUE;
	PARAM_CLASS_OPT	(spawntype, AActor)		{ spawntype = NULL; }
	PARAM_INT_OPT	(n)						{ n = 0; }
	PARAM_INT_OPT	(flags)					{ flags = 0; }
	PARAM_FIXED_OPT	(vrange)				{ vrange = 4*FRACUNIT; }
	PARAM_FIXED_OPT	(hrange)				{ hrange = FRACUNIT/2; }

	int i, j;

	if (n == 0) n = self->Damage; // GetMissileDamage (0, 1);
	if (spawntype == NULL) spawntype = PClass::FindClass("FatShot");

	P_RadiusAttack (self, self->target, 128, 128, self->DamageType, true);
	if (self->z <= self->floorz + (128<<FRACBITS))
	{
		P_HitFloor (self);
	}

	// Now launch mushroom cloud
	AActor *target = Spawn("Mapspot", 0, 0, 0, NO_REPLACE);	// We need something to aim at.
	target->height = self->height;
 	for (i = -n; i <= n; i += 8)
	{
 		for (j = -n; j <= n; j += 8)
		{
			AActor *mo;
			target->x = self->x + (i << FRACBITS);    // Aim in many directions from source
			target->y = self->y + (j << FRACBITS);
			target->z = self->z + (P_AproxDistance(i,j) * vrange); // Aim up fairly high
			if (flags == 0 && (!(self->state->DefineFlags & SDF_DEHACKED) || !(i_compatflags & COMPATF_MUSHROOM)))
			{
				mo = P_SpawnMissile (self, target, spawntype); // Launch fireball
			}
			else
			{
				mo = P_OldSpawnMissile (self, target, spawntype); // Launch fireball
			}
			if (mo != NULL)
			{	// Slow it down a bit
				mo->velx = FixedMul(mo->velx, hrange);
				mo->vely = FixedMul(mo->vely, hrange);
				mo->velz = FixedMul(mo->velz, hrange);
				mo->flags &= ~MF_NOGRAVITY;   // Make debris fall under gravity
			}
		}
	}
	target->Destroy();
	return 0;
}
