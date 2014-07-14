from zdtypes import *

# Cython won't generate headers without at least one 'public' function ಠ_ಠ
cdef public void __fakeplayer__(): pass

cdef class Player:
  def __cinit__(self): pass # Just a wrapper for now
  def __dealloc__(self): pass # For now, we don't want to screw around with ZDoom's memory...


cdef Player python_init_player(player_t* ptr):
  player = Player()
  player.ptr = ptr
  return player
