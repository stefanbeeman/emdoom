from zdtypes cimport *
cdef extern from "Python.h":
  pass

cdef extern from 'r_defs.h':
  struct vertex_t:
    fixed_t x
    fixed_t y
    float fx, fy # Floating point coordinates of this vertex (excluding polyoblect translation!)
    int numheights
    int numsectors
    sector_t ** sectors
    float * heightlist

  cppclass side_t:
    sector_t* sector
    line_t *linedef
    SWORD Light
    BYTE Flags
    int GetLightLevel(bool foggy, int baselight, bool noabsolute=false, int *pfakecontrast_usedbygzdoom=NULL)
    void SetLight(SWORD l)
    #FTextureID GetTexture(int which)
    #void SetTexture(int which, FTextureID tex)
    void SetTextureXOffset(int which, fixed_t offset)
    void SetTextureXOffset(fixed_t offset)
    fixed_t GetTextureXOffset(int which)
    void AddTextureXOffset(int which, fixed_t delta)
    void SetTextureYOffset(int which, fixed_t offset)
    void SetTextureYOffset(fixed_t offset)
    fixed_t GetTextureYOffset(int which)
    void AddTextureYOffset(int which, fixed_t delta)
    void SetTextureXScale(int which, fixed_t scale)
    void SetTextureXScale(fixed_t scale)
    fixed_t GetTextureXScale(int which)
    void MultiplyTextureXScale(int which, fixed_t delta)
    void SetTextureYScale(int which, fixed_t scale)
    void SetTextureYScale(fixed_t scale)
    fixed_t GetTextureYScale(int which)
    void MultiplyTextureYScale(int which, fixed_t delta)
    #DInterpolation *SetInterpolation(int position)
    void StopInterpolation(int position)
    seg_t **segs
    int numsegs

  struct line_t:
    vertex_t *v1
    vertex_t *v2 # vertices, from v1 to v2
    fixed_t dx, dy # precalculated v2 - v1 for side checking
    DWORD flags
    DWORD activation # activation type
    int special
    fixed_t Alpha # <--- translucency (0=invisibile, FRACUNIT=opaque)
    int id # <--- same as tag or set with Line_SetIdentification
    int args[5] # <--- hexen-style arguments (expanded to ZDoom's full width)
    side_t *sidedef[2]
    slopetype_t slopetype # To aid move clipping.
    sector_t *frontsector
    sector_t *backsector