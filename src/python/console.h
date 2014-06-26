#ifndef __PYX_HAVE__console
#define __PYX_HAVE__console


#ifndef __PYX_HAVE_API__console

#ifndef __PYX_EXTERN_C
  #ifdef __cplusplus
    #define __PYX_EXTERN_C extern "C"
  #else
    #define __PYX_EXTERN_C extern
  #endif
#endif

__PYX_EXTERN_C DL_IMPORT(void) RunPython(char const *);

#endif /* !__PYX_HAVE_API__console */

#if PY_MAJOR_VERSION < 3
PyMODINIT_FUNC initconsole(void);
#else
PyMODINIT_FUNC PyInit_console(void);
#endif

#endif /* !__PYX_HAVE__console */
