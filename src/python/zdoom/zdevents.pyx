from zdtypes import *
from zdmap import *

import sys

from enum import Enum
from itertools import ifilter, imap

# Cython won't generate headers without at least one 'public' function ಠ_ಠ
cdef public void __fakeevents__(): pass

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
  def __init__(self, name, emitter, data={}):
    self._name = name
    self._emitter = emitter
    self._data = data
    self._type = EventType.of(emitter)

  def __repr__(self):
    cls = type(self).__name__
    return "<%s: '%s' %s>" % (cls, self.name, self.emitter)

  @property
  def name(self):
    return self._name

  @property
  def emitter(self):
    return self._emitter

  @property
  def data(self):
    return self._data

