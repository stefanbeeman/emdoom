#include <iostream>

#include "python/py_thinker.h"
#include "python/zdoom/zdevents.h"
#include "python/zdoom/zdwardens.h"
#include "python/zdoom/zddispatch.h"

PyThinker::PyThinker() : DThinker(STAT_SCRIPTS) {
    initzdevents();
    initzdwardens();
    initzddispatch();
    python_init_dispatch();

    std::cout << "Initialized PyThinker" << std::endl;
}

PyThinker::~PyThinker() {}

void PyThinker::Serialize(FArchive &arc) {}

void PyThinker::Tick() {
    python_dispatch_events();
}
