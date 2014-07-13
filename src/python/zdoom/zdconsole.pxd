from zdtypes cimport *

cdef extern from "c_console.h":
  int PrintString (int printlevel, const char *string)

cdef extern from "c_dispatch.h":
  void AddCommandString (char *text, int keynum)