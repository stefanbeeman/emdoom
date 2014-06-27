#include "Python.h"
#include "python/pyx/console.h"
#include "python/pyx/dispatch.h"

void python_start() {
  Py_Initialize();
  initconsole();
  initdispatch();
}

void python_stop() {
  Py_Finalize();
}