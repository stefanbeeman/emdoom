#ifndef __PYX_HAVE__dispatch
#define __PYX_HAVE__dispatch


#ifndef __PYX_HAVE_API__dispatch

#ifndef __PYX_EXTERN_C
  #ifdef __cplusplus
    #define __PYX_EXTERN_C extern "C"
  #else
    #define __PYX_EXTERN_C extern
  #endif
#endif

__PYX_EXTERN_C DL_IMPORT(PyObject) *python_import(char const *);
__PYX_EXTERN_C DL_IMPORT(PyObject) *python_tick(void);

#endif /* !__PYX_HAVE_API__dispatch */

#if PY_MAJOR_VERSION < 3
PyMODINIT_FUNC initdispatch(void);
#else
PyMODINIT_FUNC PyInit_dispatch(void);
#endif

#endif /* !__PYX_HAVE__dispatch */
