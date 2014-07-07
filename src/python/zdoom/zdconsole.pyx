cdef extern from "c_console.h":
  int PrintString (int printlevel, const char *string)

cdef extern from "c_dispatch.h":
  void AddCommandString (char *text, int keynum)

cdef public void __gzconsole__():
  pass

def log(message):
  encoded = encode(message, 'log')
  PrintString(0, encoded)

def command(command):
  encoded = encode(command, 'command')
  AddCommandString(encoded, 0)

def encode(string, name):
  if not isinstance(string, unicode):
    raise ValueError("Command '%s' requires text input, got %s" % (name, type(string)))
  return string.encode('UTF-8')