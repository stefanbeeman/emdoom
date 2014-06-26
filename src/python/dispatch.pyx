import Queue
import console
import importlib
import os.path

actions = Queue.Queue()

def add(action):
  actions.put_nowait(action)

cdef public python_import(const char* name):
  fn = os.path.abspath(name)
  print "Importing module: " + fn
  try:
    importlib.import_module(fn)
  except:
    print "Unable to load module: " + fn

cdef public python_tick():
  print "I live!"
  # try:
  #   action = actions.get_nowait()
  #   fn = action[0]
  #   args = action[1]
  #   fn(*args)
  # except Queue.Empty:
  #   pass