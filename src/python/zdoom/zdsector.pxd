from zdtypes cimport *
from zdline cimport *
cdef extern from "Python.h":
  pass

cdef extern from 'r_defs.h':
  cppclass sector_t:
    fixed_t FindLowestFloorSurrounding (vertex_t **v)
    fixed_t FindHighestFloorSurrounding (vertex_t **v)
    fixed_t FindNextHighestFloor (vertex_t **v)
    fixed_t FindNextLowestFloor (vertex_t **v)
    fixed_t FindLowestCeilingSurrounding(vertex_t **v)
    fixed_t FindHighestCeilingSurrounding(vertex_t **v)
    fixed_t FindNextLowestCeiling(vertex_t **v)
    fixed_t FindNextHighestCeiling(vertex_t **v)
    fixed_t FindShortestTextureAround()
    fixed_t FindShortestUpperAround()
    sector_t *FindModelFloorSector(fixed_t floordestheight)
    sector_t *FindModelCeilingSector(fixed_t floordestheight)
    int FindMinSurroundingLight (int max)
    fixed_t FindLowestCeilingPoint(vertex_t **v)
    fixed_t FindHighestFloorPoint(vertex_t **v)
    void SetColor(int r, int g, int b, int desat)
    void SetFade(int r, int g, int b)
    void ClosestPoint(fixed_t x, fixed_t y, fixed_t &ox, fixed_t &oy)
    int GetFloorLight()
    int GetCeilingLight()
    sector_t *GetHeightSec()
    #DInterpolation *SetInterpolation(int position, bool attach
    void StopInterpolation(int position)
    void SetXOffset(int pos, fixed_t o)
    void AddXOffset(int pos, fixed_t o)
    fixed_t GetXOffset(int pos)
    void SetYOffset(int pos, fixed_t o)
    void AddYOffset(int pos, fixed_t o)
    fixed_t GetYOffset(int pos, bool addbase = true)
    void SetXScale(int pos, fixed_t o)
    fixed_t GetXScale(int pos)
    void SetYScale(int pos, fixed_t o)
    fixed_t GetYScale(int pos)
    void SetAngle(int pos, angle_t o)
    angle_t GetAngle(int pos, bool addbase = true)
    void SetBase(int pos, fixed_t y, angle_t o)
    void SetAlpha(int pos, fixed_t o)
    fixed_t GetAlpha(int pos)
    int GetFlags(int pos)
    void ChangeFlags(int pos, int And, int Or)
    int GetPlaneLight(int pos)
    void SetPlaneLight(int pos, int level)
    #FTextureID GetTexture(int pos)
    #void SetTexture(int pos, FTextureID tex, bool floorclip = true)
    fixed_t GetPlaneTexZ(int pos)
    void SetPlaneTexZ(int pos, fixed_t val)
    void ChangePlaneTexZ(int pos, fixed_t val)
    static inline short ClampLight(int level)
    void ChangeLightLevel(int newval)
    void SetLightLevel(int newval)
    int GetLightLevel()
    bool PlaneMoving(int pos)
    fixed_t CenterFloor()
    fixed_t CenterCeiling()
    secplane_t floorplane, ceilingplane
    #FDynamicColormap *ColorMap
    short special
    short tag
    short lightlevel
    int sky
    FNameNoInit SeqName
    fixed_t soundorg[2]
    AActor* thinglist
    fixed_t friction
    fixed_t movefactor
    short linecount
    line_t **lines
    sector_t *heightsec
    float gravity
    short damage
    short mod
    WORD ZoneNumber
    DWORD Flags
    short secretsector
    int sectornum
    bool transdoor
    fixed_t transdoorheight  # for transparent door hacks

  struct secplane_t:
    pass