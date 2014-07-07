cdef extern from "c_console.h":
  int PrintString (int printlevel, const char *string)

cdef extern from "c_dispatch.h":
  void AddCommandString (char *text, int keynum)

def log(message):
  encoded = <char*>message
  PrintString(0, encoded)

def command(command):
  encoded = <char*>command
  AddCommandString(encoded, 0)
