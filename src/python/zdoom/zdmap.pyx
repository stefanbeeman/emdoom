from zdtypes import *

cdef class Map:
  cdef FLevelLocals* ptr

  # We are not yet worthy of these functions.
  def __cinit__(self): pass
  def __dealloc__(self): pass

  property air_control:
    def __get__(self):
      return from_fixed(this.ptr.aircontrol)
    def __set__(self, value):
      this.ptr.aircontrol = to_fixed(value)
  property gravity:
    def __get__(self):
      return this.ptr.gravity
    def __set__(self, value):
      this.ptr.gravity = value

cdef Map current

cdef public python_init_map(FLevelLocals* data):
  pass
  #current = Map()
  #current.ptr = data