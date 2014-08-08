from Queue import Queue
from zdevents import *
from zdwardens import *

cdef Commander commander

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
  event = Event(event_str, emitter, data)
  global commander
  commander.push(event)

#########
# C API #
#########

cdef public bool python_actor_event(char* c_event, AActor* c_emitter, object data):
  return init_event[AActor](c_event, c_emitter, data)

cdef public bool python_player_event(char* c_event, player_t* c_emitter, object data):
  return init_event[player_t](c_event, c_emitter, data)

cdef public void python_init_dispatch():
  global commander
  if not commander:
    commander = Commander()
  commander.clear()

cdef public int python_dispatch_events():
  global commander
  cdef int length = <int?>len(commander.execute())
  return length
