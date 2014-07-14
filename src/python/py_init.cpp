#include <cstdio>
#include <iostream>

#include <Python.h>

#include "python/zdoom/zdtypes.h"
#include "python/zdoom/zdconsole.h"
#include "python/zdoom/zdmap.h"
#include "python/zdoom/zdactor.h"
#include "python/zdoom/zdplayer.h"
#include "python/zdoom/zdsector.h"
#include "python/zdoom/zdevents.h"

using std::cout;
using std::cerr;
using std::endl;

void python_start() {
  cout << "[Python] Starting interpreter..." << endl;
  PyImport_AppendInittab("zdtypes", initzdtypes);
  PyImport_AppendInittab("zdconsole", initzdconsole);
  PyImport_AppendInittab("zdmap", initzdmap);
  PyImport_AppendInittab("zdactor", initzdactor);
  PyImport_AppendInittab("zdplayer", initzdplayer);
  PyImport_AppendInittab("zdsector", initzdsector);
  PyImport_AppendInittab("zdevents", initzdevents);
  Py_Initialize();
  initzdtypes();
  initzdconsole();
  initzdmap();
  initzdactor();
  initzdplayer();
  initzdsector();
  initzdevents();
  cout << "[Python] Interpreter started, available modules: " << endl;
}

void python_run_string(const char *command) {
  PyRun_SimpleString(command);
}

void python_run_file(FILE *fp, const char *filename) {
  PyRun_SimpleFile(fp, filename);
}

void python_import(const char *name) {
  PyImport_ImportModule(name);
}

void python_stop() {
  Py_Finalize();
  cout << "[Python] Shut down interpreter." << endl;
}
