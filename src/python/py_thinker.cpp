#include "python/py_thinker.h"
#include "python/zdoom/zdevents.h"

PyThinker::PyThinker() : DThinker(STAT_SCRIPTS) {
  initzdevents();
}

PyThinker::~PyThinker() {}

void PyThinker::Serialize(FArchive &arc) {}

void PyThinker::Tick() {
  python_execute_events();
}
