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
  def __init__(self, event, emitter, data={}):
    self._event = event
    self._emitter = emitter
    self._data = data
    self._type = EventType.of(emitter)

  def __repr__(self):
    cls = type(self).__name__
    return "<%s: '%s' %s>" % (cls, self.event, self.emitter)

  @property
  def event(self):
    return self._event

  @property
  def emitter(self):
    return self._emitter

  @property
  def data(self):
    return self._data

######################
# Internal C helpers #
######################

cdef object python_init_eventable_t(eventable_t* val):
  if eventable_t is AActor:
    return python_init_actor(val)

  if eventable_t is player_t:
    return python_init_player(val)

  #raise ValueError('Value given is not an eventable_t')

cdef bool init_event(char* c_event, eventable_t* c_emitter, object data):
  event_str = str(c_event)
  emitter = python_init_eventable_t(c_emitter)
  cdef object event = Event(event_str, emitter, data)
  events.put(event)

#########
# C API #
#########

cdef public bool python_actor_event(char* c_event, AActor* c_emitter, object data):
  return init_event[AActor](c_event, c_emitter, data)

cdef public bool python_player_event(char* c_event, player_t* c_emitter, object data):
  return init_event[player_t](c_event, c_emitter, data)

cdef public void python_execute_events():
  while events.qsize() > 0:
    try:
      event = events.get_nowait()
      print event
    except Empty:
      break
