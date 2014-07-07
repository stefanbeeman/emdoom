cimport zdtypes
cimport zdflags

actors = []

class Actor:
  def __init__(*AActor cActor):
    print cActor
    self.__pointer__ = cActor

cdef public create_actor(*AActor cActor):
  pyActor = Actor(cActor)
  actors.append(pyActor)