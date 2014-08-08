from zdtypes cimport *
from zddispatch cimport *

cdef class Event(object):
  cdef object _name
  cdef object _emitter
  cdef object _data
  cdef object _type
