from zdtypes import *
from zdactor cimport *
from Queue import Queue

events = Queue()

cdef public void python_push_event(char* c_event, AActor* c_activator, AActor* c_target):
  event = str(c_event)
  cdef Actor activator = python_init_actor(c_activator)
  events.put((event, activator))

cdef public void python_execute_events():
  while events.qsize() > 0:
    event, activator, target = events.get()
    print event
