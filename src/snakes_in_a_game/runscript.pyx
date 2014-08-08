// call_class.c - A sample of python embedding 
// (calling python classes from C code)
//
#include <Python.h>

int main(int argc, char *argv[])
{
    PyObject *pName, *pModule, *pDict, 
                  *pClass, *pInstance, *pValue;
    int i, arg[2];

    if (argc < 4) 
    {
        printf(
          "Usage: exe_name python_fileclass_name function_name\n");
        return 1;
    }

    // some code omitted...
   
    // Build the name of a callable class 
    pClass = PyDict_GetItemString(pDict, argv[2]);

    // Create an instance of the class
    if (PyCallable_Check(pClass))
    {
        pInstance = PyObject_CallObject(pClass, NULL); 
    }

    // Build the parameter list
    if( argc > 4 )
    {
        for (i = 0; i < argc - 4; i++)
            {
                    arg[i] = atoi(argv[i + 4]);
            }
        // Call a method of the class with two parameters
        pValue = PyObject_CallMethod(pInstance, 
                    argv[3], "(ii)", arg[0], arg[1]);
    } else
    {
        // Call a method of the class with no parameters
        pValue = PyObject_CallMethod(pInstance, argv[3], NULL);
    }
    if (pValue != NULL) 
    {
        printf("Return of call : %d\n", PyInt_AsLong(pValue));
        Py_DECREF(pValue);
    }
    else 
    {
        PyErr_Print();
    }
   
    // some code omitted...
}