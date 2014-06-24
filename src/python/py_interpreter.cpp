#include "Python.h"

void pyStartInterpreter() {
  Py_Initialize();
}

void pyStopInterpreter() {
  Py_Finalize();
}

void pyRunFile(FILE *fp, const char *filename) {
  PyRun_AnyFileEx(fp, filename, 1);
}

void pyRunString(const char *command) {
  PyRun_SimpleString(command);
}