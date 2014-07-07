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
  ctypedef float angle_t

cdef extern from "name.h":
  cppclass FName:
    FName(const char *text)
    int GetIndex()
    int SetName(const char *text, bool noCreate=false)
    bool IsValidName()

cdef extern from "dobjtype.h":
  cdef struct PClass:
    FName TypeName
    PClass *ParentClass
    bool bRuntimeClass
    bool IsAncestorOf(PClass *ti)
    bool IsDescendantOf(PClass *ti)

cdef extern from "dobjtype.h" namespace "PClass":
    const PClass *FindClass(char *name)
