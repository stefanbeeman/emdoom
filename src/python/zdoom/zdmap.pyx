from zdtypes import *
from zdactor import *

cdef class Map:
  cdef FLevelLocals* ptr

  # We are not yet worthy of these functions.
  def __cinit__(self): pass
  def __dealloc__(self): pass

  def __init__(self):
    self.actors = []
    self.sectors = []
    self.lines = []

#  property level_name:
#    def __get__(self):
#      cdef object result = from_fstring(self.ptr.LevelName)
#      return result
#    def __set__(self, value):
#      cdef FString result = to_fstring(value)
#      self.ptr.LevelName = result

  property air_control:
    def __get__(self):
      return from_fixed(self.ptr.aircontrol)
    def __set__(self, value):
      self.ptr.aircontrol = to_fixed(value)

  property gravity:
    def __get__(self):
      return self.ptr.gravity
    def __set__(self, value):
      self.ptr.gravity = value

  def spawn(self, archtype, position, angle=0.0, tid=None):
    x, y, z = position
    cdef AActor* ptr = Spawn(<char*>archtype, to_fixed(x), to_fixed(y), to_fixed(z), ALLOW_REPLACE)
    actor = python_init_actor(ptr)
    self.actors.append(actor)
    actor.angle = angle
    return actor

current = Map()

cdef public python_init_map(FLevelLocals* data):
  cdef Map cur = current
  cur.ptr = data
