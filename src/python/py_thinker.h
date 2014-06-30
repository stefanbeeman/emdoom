#include "Python.h"
#include "dobject.h"
#include "dthinker.h"
#include "doomtype.h"

class PyThinker : public DThinker {
  public:
    PyThinker();
    ~PyThinker();
    void Serialize(FArchive &arc);
    void Tick();
};