actors = []

cdef class Actor:
  cdef AActor* ptr

  def __cinit__(self):
    pass # Just a wrapper for now

  def __dealloc__(self):
    pass # For now, we don't want to screw around with ZDoom's memory...

cdef public Actor_Init(AActor* ptr):
  actor = Actor()
  actor.ptr = ptr
  actors.append(actor)
  return actor
