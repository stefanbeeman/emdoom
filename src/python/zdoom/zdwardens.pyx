from bintrees import FastRBTree
from collections import defaultdict
from itertools import imap
from Queue import Queue, Empty

# Cython won't generate headers without at least one 'public' function ಠ_ಠ
cdef public void __fakewardens__(): pass

cdef class Warden(object):
  def __init__(self, pred, action, priority=None, name=None):
    self._pred = pred
    self._action = action
    self._priority = priority
    self._name = name

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


cdef class Commander(object):
  def __init__(self):
    self._trees = defaultdict()
    self._events = Queue()
    print "Started commander"

  def clear(self):
    self._trees.clear()
    self._events.clear()

  def add_warden(self, event_name, warden):
    """ Add a Warden to the list of handlers for a given event name. """
    tree = self._trees[event_name]
    wardens = tree.setdefault(warden.priority, [])
    wardens.append(warden)

  def dispatch(self, event):
    """ Dispatch the given event. """

    def handle(leaf):
      (priority, watchers) = leaf
      return sum(imap(lambda w: w.handle(event), watchers))

    # We want to do a reverse inorder traversal of the tree, as we want to
    # evaluate the highest-priority elements first.
    if event.name in self._trees:
      leaves = self._trees[event.name].items(reverse=True)
      return sum(imap(handle, leaves))
    else:
      return 0

  def push(self, event):
    self._events.put(event)

  def execute(self):
    dispatched = []
    while self._events.qsize() > 0:
      try:
        event = self._events.get_nowait()
        print "dispatching %s" % event
        dispatched.append(self.dispatch(event))
      except Empty:
        break

    return dispatched
