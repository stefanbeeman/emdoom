#include "python/py_thinker.h"
#include "python/zdoom/zddispatch.h"

PyThinker::PyThinker() : DThinker(STAT_SCRIPTS) {
  initzddispatch();
  python_init_dispatch();
}

PyThinker::~PyThinker() {}

void PyThinker::Serialize(FArchive &arc) {}

void PyThinker::Tick() {
  python_dispatch_events();
}
