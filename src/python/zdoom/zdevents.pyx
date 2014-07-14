from zdtypes import *
from zdmap import *

from enum import Enum
from itertools import ifilter
from Queue import Queue

events = Queue()


cdef object python_init_eventable_t(eventable_t* val):
  if eventable_t is AActor:
    return python_init_actor(val)

  if eventable_t is player_t:
    return python_init_player(val)

  #raise ValueError('Value given is not an eventable_t')

cdef bool init_event(char* c_event, AActor* c_activator, eventable_t* c_target):
  event_str = str(c_event)
  cdef Actor activator = python_init_actor(c_activator)

  target = None
  if c_target != NULL:
    target = python_init_eventable_t(c_target)

  events.put(Event(event_str, activator, target))


cdef public bool python_actor_event(char* c_event, AActor* c_activator, AActor* c_target):
  return init_event[AActor](c_event, c_activator, c_target)

cdef public bool python_player_event(char* c_event, AActor* c_activator, player_t* c_target):
  return init_event[player_t](c_event, c_activator, c_target)


cdef public void python_execute_events():
  while events.qsize() > 0:
    event = events.get()
    print event


class EventType(Enum):
  player = Player
  actor = Actor
  map = Map
  # TODO:
  #line = Line
  #sector = Sector

  @classmethod
  def of(cls, value):
    if value is None:
      return cls.player

    members = cls.__members__
    instance = lambda x: isinstance(x, value)
    result = next(ifilter(instance, members.iterkeys()), None)
    if result is None:
      raise ValueError('Type %s does not subclass any of %s' % (type(value), members.keys()))

    return result


class Event(object):
  def __init__(self, event, activator, target=None):
    self._event = event
    self._activator = activator
    self._target = target
    self._type = EventType.of(target)

  # TODO(apaine)
  # def __str__(self):

  @property
  def event(self):
    return self._event

  @property
  def activator(self):
    return self._activator

  @property
  def target(self):
    return self._target
