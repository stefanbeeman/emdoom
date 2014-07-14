from zdtypes cimport *
from zdactor cimport *
from zdplayer cimport *
from zdmap cimport *
from libcpp cimport bool

ctypedef fused eventable_t:
  AActor
  player_t
