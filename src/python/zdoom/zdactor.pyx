from zdtypes import *

actors = []

cdef extern from "Python.h":
  pass

cdef class Actor:
  cdef AActor* ptr

  def __cinit__(self):
    pass # Just a wrapper for now
  def __dealloc__(self):
    pass # For now, we don't want to screw around with ZDoom's memory...

  property x:
    def __get__(self): return from_fixed(self.ptr.x)
    def __set__(self, x): self.ptr.x = to_fixed(x)
  property y:
    def __get__(self): return from_fixed(self.ptr.y)
    def __set__(self, y): self.ptr.y = to_fixed(y)
  property z:
    def __get__(self): return from_fixed(self.ptr.z)
    def __set__(self, z): self.ptr.z = to_fixed(z)

  property vx:
    def __get__(self): return from_fixed(self.ptr.velx)
    def __set__(self, vx): self.ptr.velx = to_fixed(vx)
  property vy:
    def __get__(self): return from_fixed(self.ptr.vely)
    def __set__(self, vy): self.ptr.vely = to_fixed(vy)
  property vz:
    def __get__(self): return from_fixed(self.ptr.velz)
    def __set__(self, vz): self.ptr.velz = to_fixed(vz)

  property radius:
    def __get__(self): return from_fixed(self.ptr.radius)
    def __set__(self, radius): self.ptr.radius = to_fixed(radius)
  property height:
    def __get__(self): return from_fixed(self.ptr.height)
    def __set__(self, height): self.ptr.height = to_fixed(height)

  property angle:
    def __get__(self): return from_fixed_angle(self.ptr.angle)
    def __set__(self, angle): self.ptr.angle = to_fixed_angle(angle)
  property pitch:
    def __get__(self): return from_fixed_angle(-self.ptr.pitch)
    def __set__(self, pitch): self.ptr.pitch = to_fixed_angle(-pitch)
  # property roll:
  #   def __get__(self): return from_fixed_angle(self.ptr.roll)
  #   def __set__(self, pitch): self.ptr.roll = to_fixed_angle(roll)



cdef public python_init_actor(AActor* ptr):
  actor = Actor()
  actor.ptr = ptr
  actors.append(actor)
  return actor