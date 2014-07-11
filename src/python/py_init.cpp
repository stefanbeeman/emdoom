#include <cstdio>
#include <iostream>

#include <Python.h>

#include "python/zdoom/zdtypes.h"
#include "python/zdoom/zdmap.h"
#include "python/zdoom/zdactor.h"
#include "python/zdoom/zdconsole.h"

using std::cout;
using std::cerr;
using std::endl;

void python_start() {
  cout << "[Python] Starting interpreter..." << endl;

  //PyObject* package_gzconsole = PyImport_AddModule("gzconsole");
  //PyObject* gzdoom_package = Py_InitModule("gzdoom", nomethods);
  //PyObject* __path__ = PyList_New(1);
  //PyList_SetItem(__path__, 0, PyString_FromString("gzdoom"));
  PyImport_AppendInittab("zdtypes", initzdtypes);
  PyImport_AppendInittab("zdconsole", initzdconsole);
  PyImport_AppendInittab("zdmap", initzdmap);
  PyImport_AppendInittab("zdactor", initzdactor);
  Py_Initialize();
  initzdtypes();
  initzdconsole();
  initzdmap();
  initzdactor();

  cout << "[Python] Interpreter started." << endl;
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
