// Implementations are nice too... Sometimes.

#include "call_python.h"
#include <Python.h>

int gzpy_initialize(const char *python_module_root)
{
    // Let everyone know this is Doom's Python
    Py_SetProgramName("PyZDoom");

    // Initialize the Python Interpreter
    Py_Initialize();
    printf("\nPython initialized!\n\n");

    // Add current dir to the path
    PyObject* sysPath = PySys_GetObject((char*)"path");
    PyList_Append(sysPath, PyString_FromString(python_module_root));

    printf("\n\n");

    return 0;
}

int gzpy_cleanup()
{
    // Finish the Python Interpreter
    Py_Finalize();

    return 0;
}

int gzpy_runscript(int argc, char *filename, char *method)
{
    PyObject *pName, *pModule, *pDict, *pFunc;

    // Build the name object
    pName = PyString_FromString(filename);

    // Load the module object
    pModule = PyImport_Import(pName);

    // pDict is a borrowed reference
    pDict = PyModule_GetDict(pModule);

    // pFunc is also a borrowed reference
    pFunc = PyDict_GetItemString(pDict, method);

    if (PyCallable_Check(pFunc))
    {
        PyObject_CallObject(pFunc, NULL);
    }
    else
    {
        printf("did something... but not well");

        PyObject *repr = PyObject_Repr(pDict);
        const char* s = PyString_AsString(repr);
        printf(s);
        PyErr_Print();
    }

    // Clean up
    Py_DECREF(pModule);
    Py_DECREF(pName);

    return 0;
}