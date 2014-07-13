from zdtypes cimport *

cdef extern from 'doomtype.h':
  cppclass PalEntry:
    PalEntry()
    PalEntry(uint32 argb)
    PalEntry InverseColor()
    uint32 d

cdef extern from 'r_data/colormaps.h':
  cppclass FDynamicColormap:
    void ChangeFade(PalEntry fadecolor)
    void ChangeColor(PalEntry lightcolor, int desaturate)
    void ChangeColorFade(PalEntry lightcolor, PalEntry fadecolor)
    BYTE *Maps
    PalEntry Color
    PalEntry Fade
    int Desaturate