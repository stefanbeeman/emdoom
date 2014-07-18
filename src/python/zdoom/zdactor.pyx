from zdtypes import *

# Cython won't generate headers without at least one 'public' function ಠ_ಠ
cdef public void __fakeactor__(): pass

cdef const PClass *find_class(name):
  encoded = unicode(name)
  cdef FName class_name = FName(encoded)
  return FindClass(class_name)

cdef class Actor:
  def __cinit__(self): pass # Just a wrapper for now
  def __dealloc__(self): pass # For now, we don't want to screw around with ZDoom's memory...

  def species(self):
    return str(self.ptr.GetSpecies().GetChars())

  def __repr__(self):
    cls = type(self).__name__
    return "<%s[%s]: %d>" % (cls, self.species(), self.tid)

  property x:
    def __get__(self): return from_fixed(self.ptr.x)
    def __set__(self, x): self.ptr.x = to_fixed(x)
  property y:
    def __get__(self): return from_fixed(self.ptr.y)
    def __set__(self, y): self.ptr.y = to_fixed(y)
  property z:
    def __get__(self): return from_fixed(self.ptr.z)
    def __set__(self, z): self.ptr.z = to_fixed(z)
  property position:
    def __get__(self): return (self.x, self.y, self.z)
    def __set__(self, position): self.x, self.y, self.z = position

  property vx:
    def __get__(self): return from_fixed(self.ptr.velx)
    def __set__(self, vx): self.ptr.velx = to_fixed(vx)
  property vy:
    def __get__(self): return from_fixed(self.ptr.vely)
    def __set__(self, vy): self.ptr.vely = to_fixed(vy)
  property vz:
    def __get__(self): return from_fixed(self.ptr.velz)
    def __set__(self, vz): self.ptr.velz = to_fixed(vz)
  property velocity:
    def __get__(self): return (self.vx, self.vy, self.vz)
    def __set__(self, velocity): self.vx, self.vy, self.vz = velocity

  property scale_x:
    def __get__(self): return from_fixed(self.ptr.scaleX)
    def __set__(self, scale_x): self.ptr.scaleX = to_fixed(scale_x)
  property scale_y:
    def __get__(self): return from_fixed(self.ptr.scaleY)
    def __set__(self, scale_y): self.ptr.scaleY = to_fixed(scale_y)
  property scale:
    def __get__(self): return (self.scale_x, self.scale_y)
    def __set__(self, scale): self.scale_x, self.scale_y = scale
  property alpha:
    def __get__(self): return from_fixed(self.ptr.alpha)
    def __set__(self, alpha): self.ptr.alpha = to_fixed(alpha)

  property radius:
    def __get__(self): return from_fixed(self.ptr.radius)
    def __set__(self, radius): self.ptr.radius = to_fixed(radius)
  property height:
    def __get__(self): return from_fixed(self.ptr.height)
    def __set__(self, height): self.ptr.height = to_fixed(height)
  property gravity:
    def __get__(self): return from_fixed(self.ptr.gravity)
    def __set__(self, gravity): self.ptr.gravity = to_fixed(gravity)
  property speed:
    def __get__(self): return from_fixed(self.ptr.Speed)
    def __set__(self, speed): self.ptr.Speed = to_fixed(speed)
  property float_speed:
    def __get__(self): return from_fixed(self.ptr.FloatSpeed)
    def __set__(self, float_speed): self.ptr.FloatSpeed = to_fixed(float_speed)
  property dropoff_height:
    def __get__(self): return from_fixed(self.ptr.MaxDropOffHeight)
    def __set__(self, dropoff_height): self.ptr.MaxDropOffHeight = to_fixed(dropoff_height)
  property step_height:
    def __get__(self): return from_fixed(self.ptr.MaxStepHeight)
    def __set__(self, step_height): self.ptr.MaxStepHeight = to_fixed(step_height)
  property mass:
    def __get__(self): return self.ptr.Mass
    def __set__(self, mass): self.ptr.Mass = mass
  property pain_threshold:
    def __get__(self): return self.ptr.PainThreshold
    def __set__(self, pain_threshold): self.ptr.PainThreshold = pain_threshold

  property angle:
    def __get__(self): return from_fixed_angle(self.ptr.angle)
    def __set__(self, angle): self.ptr.angle = to_fixed_angle(angle)
  property pitch:
    def __get__(self): return from_fixed_angle(-self.ptr.pitch)
    def __set__(self, pitch): self.ptr.pitch = to_fixed_angle(-pitch)
  # property roll:
  #   def __get__(self): return from_fixed_angle(self.ptr.roll)
  #   def __set__(self, pitch): self.ptr.roll = to_fixed_angle(roll)

  property health:
    def __get__(self): return self.ptr.health
    def __set__(self, health): self.ptr.health = health
  property damage:
    def __get__(self): return self.ptr.Damage
    def __set__(self, damage): self.ptr.Damage = damage
  property tid:
    def __get__(self): return self.ptr.tid
    def __set__(self, tid): self.ptr.tid = tid
  property hates:
    def __get__(self): return self.ptr.TIDtoHate
    def __set__(self, hates): self.ptr.TIDtoHate = hates
  property accuracy:
    def __get__(self): return self.ptr.accuracy
    def __set__(self, accuracy): self.ptr.accuracy = accuracy
  property stamina:
    def __get__(self): return self.ptr.stamina
    def __set__(self, stamina): self.ptr.stamina = stamina
  property score:
    def __get__(self): return self.ptr.Score
    def __set__(self, stamina): self.ptr.Score = score

cdef Actor python_init_actor(AActor* ptr):
  actor = Actor()
  actor.ptr = ptr
  return actor
