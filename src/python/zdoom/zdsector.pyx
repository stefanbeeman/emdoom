from zdtypes import *
from zdactor import *

cdef class Sector:
  cdef sector_t *ptr

  def __cinit__(self): pass
  def __dealloc__(self): pass

  property floor:
    def __get__(self):
      return from_fixed(self.ptr.floorplane.Zat0())
    def __set__(self, value):
      cdef fixed_t delta = to_fixed(value) - self.ptr.floorplane.Zat0()
      self.ptr.floorplane.ChangeHeight(delta)
  property ceiling:
    def __get__(self):
      return from_fixed(self.ptr.ceilingplane.Zat0())
    def __set__(self, value):
      cdef fixed_t delta = to_fixed(value) - self.ptr.ceilingplane.Zat0()
      self.ptr.ceilingplane.ChangeHeight(delta)
  property light:
    def __get__(self):
      return int(self.ptr.lightlevel)
    def __set__(self, value):
      self.ptr.lightlevel = <short>value
