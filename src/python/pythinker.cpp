#include "Python.h"
#include "i_system.h"
#include "pythinker.h"
#include "python/dispatch.h"
#include "python/console.h"

PyThinker::PyThinker() : DThinker(STAT_SCRIPTS) {
  Printf("I live!");
  Py_Initialize();
  initdispatch();
  initconsole();
}

PyThinker::~PyThinker() {
  Printf("I die!");
  Py_Finalize();
}

void PyThinker::Serialize(FArchive &arc) {}

void PyThinker::Tick() {
  python_tick();
}