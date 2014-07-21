from zdevents import Event, events

from bintrees import FastRBTree
from collections import defaultdict
from itertools import imap
from Queue import Queue, Empty

# Cython won't generate headers without at least one 'public' function ಠ_ಠ
cdef public void __fakewardens__(): pass


class Warden:
  def __init__(self, pred, action, priority=None, name=None):
    self._pred = pred
    self._action = action
    self._priority = priority
    self._name = name

  def __eq__(self, other):
    return self.priority == other.priority \
       and self._pred == other._pred \
       and self._action == other._action

  def __cmp__(self, other):
    """
    NOTE: this comparator is a "reverse" comparator, in that it returns 1 if
    self < other and -1 if self > other.
    """
    return -cmp(self.priority, other.priority)

  @property
  def priority(self):
    return self._priority

  @property
  def name(self):
    return self._name

  def pred(self, event=None):
    if event is None:
      return self._pred
    else:
      return self._pred(event)

  def action(self, event=None):
    if event is None:
      return self._action
    else:
      return self._action(event)

  def handle(self, event):
    """
    Given an event object, check if we actually want to handle it, and if so run
    our handler.

    Returns True if we ran the handler, False otherwise.

    Raises ValueError if event is null or is not an instance of Event.
    """

    if event is None or not isinstance(event, Event):
      raise ValueError("Object '%s' is not an instance of Event." % event)

    if self.pred(event):
      self.action(event)
      return True

    return False


class Commander:
  def __init__(self):
    self._trees = defaultdict(FastRBTree)
    self._events = Queue()

  def clear(self):
    self._trees.clear()
    self._events.clear()

  def add_warden(self, event_name, warden):
    """ Add a Warden to the list of handlers for a given event name. """
    tree = self._trees[event_name]
    tree[warden.priority] = warden

  def dispatch(self, event):
    """ Dispatch the given event """
    def handle(item):
      (priority, watcher) = item
      return watcher.handle(event)

    values = imap(handle, self._trees[event.name].items())
    return sum(values)

  def push(self, event):
    self._events.put(event)

  def execute(self):
    dispatched = []
    while events.qsize() > 0:
      try:
        event = events.get_nowait()
        print "dispatching %s" % event
        dispatched.append(self.dispatch(event))
      except Empty:
        break

    return dispatched

