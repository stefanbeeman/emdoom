#include "Python.h"

void pyStartInterpreter();
void pyStopInterpreter();
void pyRunFile(FILE *fp, const char *filename);
void pyRunString(const char *command);