from zdevents cimport *

cdef class Warden(object):
  cdef object _pred
  cdef object _action
  cdef object _priority
  cdef object _name

cdef class Commander(object):
  cdef object _trees
  cdef object _events
