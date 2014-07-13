from zdtypes cimport *

# Cython won't generate headers without at least one 'public' function ಠ_ಠ
cdef public void __fakeconsole__(): pass

def log(message):
  if message[-1] != '\n':
    message += '\n'

  encoded = <char*>message
  PrintString(0, encoded)

def command(command):
  encoded = <char*>command
  AddCommandString(encoded, 0)
