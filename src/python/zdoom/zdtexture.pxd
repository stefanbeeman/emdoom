from zdtypes cimport *

cdef extern from 'textures.h':
    cppclass FTextureID:
        FTextureID()
        bool isNull()
        bool isValid()
        bool Exists()

    # struct FAnimDef:
    #   FTextureID BasePic
    #   WORD NumFrames
    #   WORD CurFrame
    #   BYTE AnimType
    #   DWORD SwitchTime

    # struct FSwitchDef:
    #   FTextureID PreTexture # texture to switch from
    #   FSwitchDef *PairDef # switch def to use to return to PreTexture
    #   WORD NumFrames # number of animation frames
    #   bool QuestPanel # Special texture for Strife mission
    #   int Sound # sound to play at start of animation. Changed to int to avoiud having to include s_sound here.

    # struct FDoorAnimation
    #   FTextureID BaseTexture
    #   FTextureID *TextureFrames
    #   int NumTextureFrame
    #   FName OpenSound
    #   FName CloseSound

    # cppclass FTexture:
