#include "i_system.h"
#include "pythinker.h"

PyThinker::PyThinker() : DThinker(STAT_SCRIPTS) {}

PyThinker::~PyThinker() {}

void PyThinker::Serialize(FArchive &arc) {}

void PyThinker::Tick() {
  python_tick();
}
