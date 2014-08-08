// Headers are nice
#ifndef CALL_PYTHON_H_
#define CALL_PYTHON_H_

int gzpy_initialize(const char *python_module_root);
int gzpy_cleanup();
int gzpy_runscript(int argc, char *filename, char *method);

#endif