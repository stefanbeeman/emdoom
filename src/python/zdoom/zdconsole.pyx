from zdtypes cimport *
cdef public void __fakeconsole__(): pass

def log(message):
  encoded = <char*>message
  PrintString(0, encoded)

def command(command):
  encoded = <char*>command
  AddCommandString(encoded, 0)
