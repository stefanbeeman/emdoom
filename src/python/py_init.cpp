#include <cstdio>
#include <iostream>

#include <Python.h>

#include "python/pyx/gzconsole.h"

static PyMethodDef nomethods[] = {{NULL, NULL}};

void python_start() {
  //PyObject* package_gzconsole = PyImport_AddModule("gzconsole");
  //PyObject* gzdoom_package = Py_InitModule("gzdoom", nomethods);
  //PyObject* __path__ = PyList_New(1);
  //PyList_SetItem(__path__, 0, PyString_FromString("gzdoom"));
  //PyModule_AddObject(gzdoom_package, "__path__", __path__);
  PyImport_AppendInittab("gzconsole", initgzconsole);
  Py_Initialize();
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
}
