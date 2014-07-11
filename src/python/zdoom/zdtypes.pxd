from libcpp cimport bool

cdef extern from "basictypes.h":
  ctypedef int SBYTE
  ctypedef unsigned int BYTE
  ctypedef int SWORD
  ctypedef unsigned int WORD
  ctypedef int SDWORD
  ctypedef unsigned int DWORD
  ctypedef unsigned int uint32
  ctypedef int SQWORD
  ctypedef unsigned int QWORD
  ctypedef int BITFIELD
  ctypedef bool INTBOOL
  ctypedef int fixed_t
  ctypedef int dsfixed_t

cdef extern from "tables.h":
  ctypedef int angle_t

cdef extern from 'zstring.h':
  cppclass FString:
    FString()
    FString(const char *copyStr)
    const char *GetChars()

cdef extern from "name.h":
  cppclass FName:
    FName()
    FName(const char *text)
    char *GetChars()
  cppclass FNameNoInit:
    FName(const char *text)
    char *GetChars()

cdef extern from "dobject.h":
  cppclass TObjPtr[T]:
    pass

cdef extern from "dobjtype.h":
  cppclass PClass:
    FName TypeName
    PClass *ParentClass
    bool bRuntimeClass
    bool IsAncestorOf(PClass *ti)
    bool IsDescendantOf(PClass *ti)
  PClass *FindClass "PClass::FindClass"(FName zaname)

cdef extern from "dobjtype.h" namespace "PClass":
    const PClass *FindClass(char *name)