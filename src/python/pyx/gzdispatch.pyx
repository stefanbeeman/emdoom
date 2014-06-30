import Queue
import console
import os.path

actions = Queue.Queue()

def add(action):
  actions.put_nowait(action)

def inner_read(name):
  try:
    print "reading %s" % name
    path = os.path.abspath(name)
    print "from %s" % path
    with open(path) as fp:
      print "opened %s" % fp
      print fp.read()
  except:
    print 'Shit broke yo.'

cdef public int python_tick():
  return 1

cdef public void python_import(const char* name):
  try:
    inner_read(name)
  except:
    print 'Shit broke yo.'
  # print "Importing module: " + fn
  # try:
  #   importlib.import_module(fn)
  # except:
  #   print "Unable to load module: " + fn