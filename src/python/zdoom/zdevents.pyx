from zdtypes import *
from zdmap import *

import sys

from enum import Enum
from itertools import ifilter, imap
from Queue import Queue

events = Queue()


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

    classes = imap(lambda x: x.value, cls.__members__.itervalues())
    instance = lambda x: isinstance(value, x)
    result = next(ifilter(instance, classes), None)
    if result is None:
      raise ValueError('Type %s does not subclass any of %s' % (type(value), members.keys()))

    return result


class Event(object):
  def __init__(self, event, activator, target=None):
    self._event = event
    self._activator = activator
    self._target = target
    self._type = EventType.of(target)
    self._on_self = (target is None) or (activator.same_as(target))

  def __repr__(self):
    cls = type(self).__name__

    if self.on_self:
      return "<%s: '%s' %s>" % (cls, self.event, self.activator)
    else:
      return "<%s: %s '%s' %s>" % (cls, self.activator, self.event, self.target)

  @property
  def event(self):
    return self._event

  @property
  def activator(self):
    return self._activator

  @property
  def target(self):
    return self._target

  @property
  def on_self(self):
    return self._on_self


######################
# Internal C helpers #
######################

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

  cdef object event = Event(event_str, activator, target)
  events.put(event)


#########
# C API #
#########

cdef public bool python_actor_event(char* c_event, AActor* c_activator, AActor* c_target):
  return init_event[AActor](c_event, c_activator, c_target)

cdef public bool python_player_event(char* c_event, AActor* c_activator, player_t* c_target):
  return init_event[player_t](c_event, c_activator, c_target)

cdef public void python_execute_events():
  while events.qsize() > 0:
    try:
      event = events.get_nowait()
      print event
    except Empty:
      break

