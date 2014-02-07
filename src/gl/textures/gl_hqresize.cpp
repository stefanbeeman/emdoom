/*
** gl_hqresize.cpp
** Contains high quality upsampling functions.
** So far Scale2x/3x/4x as described in http://scale2x.sourceforge.net/
** are implemented.
**
**---------------------------------------------------------------------------
** Copyright 2008 Benjamin Berkels
** All rights reserved.
**
** Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions
** are met:
**
** 1. Redistributions of source code must retain the above copyright
**    notice, this list of conditions and the following disclaimer.
** 2. Redistributions in binary form must reproduce the above copyright
**    notice, this list of conditions and the following disclaimer in the
**    documentation and/or other materials provided with the distribution.
** 3. The name of the author may not be used to endorse or promote products
**    derived from this software without specific prior written permission.
**
** THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
** IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
** OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
** IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
** INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
** NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
** THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**---------------------------------------------------------------------------
**
*/

#include "gl/system/gl_system.h"
#include "gl/system/gl_interface.h"
#include "gl/renderer/gl_renderer.h"
#include "gl/textures/gl_texture.h"
#include "c_cvars.h"
#include "cmdlib.h"
#include "m_misc.h"
#include "md5.h"
#include "gl/hqnx/hqnx.h"
#include "gl/xbr/xbrz.h"

extern "C"
{ 
#include <unqlite.h>
}

// Uncomment to enable profiling output
//#define GZ_TEXTURE_SCALE_PROFILE
//#define GZ_TEXTURE_CACHE_FETCH_PROFILE

#if defined GZ_TEXTURE_SCALE_PROFILE || defined GZ_TEXTURE_CACHE_STORE_PROFILE
#include "stats.h"
#include "v_text.h"
#endif // GZ_TEXTURE_SCALE_PROFILE

CUSTOM_CVAR(Int, gl_texture_hqresize, 0, CVAR_ARCHIVE | CVAR_GLOBALCONFIG | CVAR_NOINITCALL)
{
	if (self < 0 || self > 10)
		self = 0;
	GLRenderer->FlushTextures();
}

CUSTOM_CVAR(Int, gl_texture_hqresize_maxinputsize, 512, CVAR_ARCHIVE | CVAR_GLOBALCONFIG | CVAR_NOINITCALL)
{
	if (self > 1024) self = 1024;
	GLRenderer->FlushTextures();
}

CUSTOM_CVAR(Int, gl_texture_hqresize_targets, 7, CVAR_ARCHIVE | CVAR_GLOBALCONFIG | CVAR_NOINITCALL)
{
	GLRenderer->FlushTextures();
}

CVAR (Flag, gl_texture_hqresize_textures, gl_texture_hqresize_targets, 1);
CVAR (Flag, gl_texture_hqresize_sprites, gl_texture_hqresize_targets, 2);
CVAR (Flag, gl_texture_hqresize_fonts, gl_texture_hqresize_targets, 4);


static void scale2x(uint32* const input, uint32* const output, const size_t width, const size_t height)
{
	const size_t scaledWidth = 2 * width;

	for (size_t i = 0; i < width; ++i)
	{
		const size_t iMinus = (i > 0        ) ? (i - 1) : 0;
		const size_t iPlus  = (i < width - 1) ? (i + 1) : i;

		for (size_t j = 0; j < height; ++j)
		{
			const size_t jMinus = (j > 0         ) ? (j - 1) : 0;
			const size_t jPlus  = (j < height - 1) ? (j + 1) : j;

			const uint32 A = input[iMinus + width * jMinus];
			const uint32 B = input[iMinus + width * j     ];
			const uint32 C = input[iMinus + width * jPlus ];
			const uint32 D = input[i      + width * jMinus];
			const uint32 E = input[i      + width * j     ];
			const uint32 F = input[i      + width * jPlus ];
			const uint32 G = input[iPlus  + width * jMinus];
			const uint32 H = input[iPlus  + width * j     ];
			const uint32 I = input[iPlus  + width * jPlus ];

			if (B != H && D != F)
			{
				output[2 * i     + scaledWidth *  2 * j     ] = D == B ? D : E;
				output[2 * i     + scaledWidth * (2 * j + 1)] = B == F ? F : E;
				output[2 * i + 1 + scaledWidth *  2 * j     ] = D == H ? D : E;
				output[2 * i + 1 + scaledWidth * (2 * j + 1)] = H == F ? F : E;
			}
			else
			{
				output[2 * i     + scaledWidth *  2 * j     ] = E;
				output[2 * i     + scaledWidth * (2 * j + 1)] = E;
				output[2 * i + 1 + scaledWidth *  2 * j     ] = E;
				output[2 * i + 1 + scaledWidth * (2 * j + 1)] = E;
			}
		}
	}
}

static void scale3x(uint32* const input, uint32* const output, const size_t width, const size_t height)
{
	const size_t scaledWidth = 3 * width;

	for (size_t i = 0; i < width; ++i)
	{
		const int iMinus = (i > 0        ) ? (i - 1) : 0;
		const int iPlus  = (i < width - 1) ? (i + 1) : i;

		for (size_t j = 0; j < height; ++j)
		{
			const size_t jMinus = (j > 0          ) ? (j - 1) : 0;
			const size_t jPlus  = (j < height - 1 ) ? (j + 1) : j;

			const uint32 A = input[iMinus + width * jMinus];
			const uint32 B = input[iMinus + width * j     ];
			const uint32 C = input[iMinus + width * jPlus ];
			const uint32 D = input[i      + width * jMinus];
			const uint32 E = input[i      + width * j     ];
			const uint32 F = input[i      + width * jPlus ];
			const uint32 G = input[iPlus  + width * jMinus];
			const uint32 H = input[iPlus  + width * j     ];
			const uint32 I = input[iPlus  + width * jPlus ];

			if (B != H && D != F)
			{
				output[3 * i     + scaledWidth *  3 * j     ] = D == B ? D : E;
				output[3 * i     + scaledWidth * (3 * j + 1)] = (D == B && E != C) || (B == F && E != A) ? B : E;
				output[3 * i     + scaledWidth * (3 * j + 2)] = B == F ? F : E;
				output[3 * i + 1 + scaledWidth *  3 * j     ] = (D == B && E != G) || (D == H && E != A) ? D : E;
				output[3 * i + 1 + scaledWidth * (3 * j + 1)] = E;
				output[3 * i + 1 + scaledWidth * (3 * j + 2)] = (B == F && E != I) || (H == F && E != C) ? F : E;
				output[3 * i + 2 + scaledWidth *  3 * j     ] = D == H ? D : E;
				output[3 * i + 2 + scaledWidth * (3 * j + 1)] = (D == H && E != I) || (H == F && E != G) ? H : E;
				output[3 * i + 2 + scaledWidth * (3 * j + 2)] = H == F ? F : E;
			}                                       
			else
			{
				output[3 * i     + scaledWidth *  3 * j     ] = E;
				output[3 * i     + scaledWidth * (3 * j + 1)] = E;
				output[3 * i     + scaledWidth * (3 * j + 2)] = E;
				output[3 * i + 1 + scaledWidth *  3 * j     ] = E;
				output[3 * i + 1 + scaledWidth * (3 * j + 1)] = E;
				output[3 * i + 1 + scaledWidth * (3 * j + 2)] = E;
				output[3 * i + 2 + scaledWidth *  3 * j     ] = E;
				output[3 * i + 2 + scaledWidth * (3 * j + 1)] = E;
				output[3 * i + 2 + scaledWidth * (3 * j + 2)] = E;
			}
		}
	}
}

static void scale4x(uint32* const input, uint32* const output, const size_t width, const size_t height)
{
	const size_t  width2x = 2 * width;
	const size_t height2x = 2 * height;

	uint32* const buffer2x = new uint32[width2x * height2x];

	scale2x(input,    buffer2x, width,   height  );
	scale2x(buffer2x, output,   width2x, height2x);

	delete[] buffer2x;
}


static const size_t BYTES_PER_PIXEL = 4;

typedef void (*HqNxFunction)(int*, unsigned char*, int, int, int);

template <HqNxFunction func, size_t scale>
static void hqNx(uint32* const input, uint32* const output, const size_t width, const size_t height)
{
	func(reinterpret_cast<int*>(input), reinterpret_cast<unsigned char*>(output),
		static_cast<int>(width), static_cast<int>(height), static_cast<int>(width * scale * BYTES_PER_PIXEL));
}

template <size_t scale>
static void xbrzNx(uint32* const input, uint32* const output, const size_t width, const size_t height)
{
	xbrz::scale(scale, input, output, static_cast<int>(width), static_cast<int>(height));
}


typedef void (*ScaleFunction)(uint32* const input, uint32* const output, const size_t width, const size_t height);

static unsigned char *scaleNxHelper(ScaleFunction scaleNxFunction,
	const size_t scale, unsigned char* const input, const size_t width, const size_t height)
{
	unsigned char* const output = new unsigned char[scale * width * scale * height * BYTES_PER_PIXEL];
	scaleNxFunction(reinterpret_cast<uint32*>(input), reinterpret_cast<uint32*>(output), width, height);

	return output;
}

static unsigned char *hqNxHelper(ScaleFunction hqNxFunction,
	const size_t scale, unsigned char* const input, const size_t width, const size_t height)
{
	static bool isInitialized = false;

	if (!isInitialized)
	{
		InitLUTs();
		isInitialized = true;
	}

	CImage image;
	image.SetImage(input, width, height, 32);
	image.Convert32To17();

	unsigned char* const output = new unsigned char[scale * width * scale * height * BYTES_PER_PIXEL];
	hqNxFunction(reinterpret_cast<uint32*>(image.m_pBitmap), reinterpret_cast<uint32*>(output), width, height);

	return output;
}


namespace
{

class ScaledTextureCache
{
public:
    ScaledTextureCache();
    ~ScaledTextureCache();

    bool init();
    bool shutdown();

    unsigned char* fetch(const          char* const algorithm,
                         const unsigned char* const original, const size_t originalSize, 
                                                              const size_t scaledSize);
    bool store(const          char* const algorithm,
               const unsigned char* const original, const size_t originalSize,
               const unsigned char* const scaled,   const size_t scaledSize);

private:
    FString  m_path;
    unqlite* m_database;

    static const int KEY_SIZE = 16;

    void GenerateKey(const          char* const algorithm,
                     const unsigned char* const data, const size_t size,
                     BYTE key[KEY_SIZE]);
};

ScaledTextureCache s_textureCache;

} // unnamed namespace


CUSTOM_CVAR(Bool, gl_texture_hqcache, false, CVAR_ARCHIVE | CVAR_GLOBALCONFIG)
{
    if (self)
    {
        s_textureCache.init();
    }
    else
    {
        s_textureCache.shutdown();
    }
}


namespace
{

ScaledTextureCache::ScaledTextureCache()
: m_database(NULL)
{

}

ScaledTextureCache::~ScaledTextureCache()
{
    shutdown();
}


bool ScaledTextureCache::init()
{
    if (NULL != m_database)
    {
        return false;
    }

    const FString cachePath = M_GetCachePath(true);
    CreatePath(cachePath);

    m_path = cachePath + "/texcache.db";

    if (UNQLITE_OK != unqlite_open(&m_database, m_path.GetChars(), UNQLITE_OPEN_CREATE))
    {
        DPrintf("Error while opening scaled texture cache database from %s", m_path.GetChars());
        return false;
    }

    return true;
}

bool ScaledTextureCache::shutdown()
{
    if (NULL == m_database)
    {
        return false;
    }

    return UNQLITE_OK == unqlite_close(m_database);
}


unsigned char* ScaledTextureCache::fetch(const          char* const algorithm,
                                         const unsigned char* const original, const size_t originalSize, 
                                                                              const size_t scaledSize)
{
    assert(NULL != original);

    if (NULL == m_database)
    {
        return false;
    }

#ifdef GZ_TEXTURE_CACHE_FETCH_PROFILE
    cycle_t perf;
    perf.Reset();
    perf.Clock();
#endif // GZ_TEXTURE_CACHE_FETCH_PROFILE

    BYTE key[KEY_SIZE];
    GenerateKey(algorithm, original, originalSize, key);

#ifdef GZ_TEXTURE_CACHE_FETCH_PROFILE
    perf.Unclock();
    Printf(" -> Generated key in %f ms\n", perf.TimeMS());
    perf.Reset();
    perf.Clock();
#endif // GZ_TEXTURE_CACHE_FETCH_PROFILE

    unqlite_int64 valueSize = 0;

    if (UNQLITE_OK != unqlite_kv_fetch(m_database, key, KEY_SIZE, NULL, &valueSize))
    {
        return NULL;
    }

#ifdef GZ_TEXTURE_CACHE_FETCH_PROFILE
    perf.Unclock();
    Printf(" -> Looked up for data in %f ms\n", perf.TimeMS());
#endif // GZ_TEXTURE_CACHE_FETCH_PROFILE

    if (unqlite_int64(scaledSize) != valueSize)
    {
        DPrintf("Scaled texture size mismatch, cache data discarded");
        return NULL;
    }

    unsigned char* const result = new unsigned char[scaledSize];

#ifdef GZ_TEXTURE_CACHE_FETCH_PROFILE
    perf.Reset();
    perf.Clock();
#endif // GZ_TEXTURE_CACHE_FETCH_PROFILE

    if (UNQLITE_OK != unqlite_kv_fetch(m_database, key, KEY_SIZE, result, &valueSize))
    {
        delete[] result;

        DPrintf("Error while fetching scaled texture data from cache");
        return NULL;
    }

#ifdef GZ_TEXTURE_CACHE_FETCH_PROFILE
    perf.Unclock();
    Printf(" -> Fetched data in %f ms\n", perf.TimeMS());
#endif // GZ_TEXTURE_CACHE_FETCH_PROFILE

    return result;
}

bool ScaledTextureCache::store(const          char* const algorithm,
                               const unsigned char* const original, const size_t originalSize,
                               const unsigned char* const scaled,   const size_t scaledSize)
{
    assert(NULL != original);
    assert(NULL != scaled);

    if (NULL == m_database)
    {
        return false;
    }

    BYTE key[KEY_SIZE];
    GenerateKey(algorithm, original, originalSize, key);

    if (UNQLITE_OK != unqlite_kv_store(m_database, key, KEY_SIZE, scaled, unqlite_int64(scaledSize)))
    {
        DPrintf("Error while storing scaled texture data to cache");
        return false;
    }

    return true;
}

void ScaledTextureCache::GenerateKey(const          char* const algorithm,
                                     const unsigned char* const data, const size_t size,
                                     BYTE key[16])
{
    MD5Context hashContext;
    hashContext.Update(reinterpret_cast<const BYTE*>(algorithm), static_cast<unsigned int>(strlen(algorithm)));
    hashContext.Update(reinterpret_cast<const BYTE*>(data),      static_cast<unsigned int>(size));
    hashContext.Final(key);
}

} // unnamed namespace

//===========================================================================
// 
// [BB] Upsamples the texture in input, frees input and returns
//  the upsampled buffer.
//
//===========================================================================
unsigned char *gl_CreateUpsampledTextureBuffer ( const FTexture *inputTexture, unsigned char *inputBuffer, const int inWidth, const int inHeight, int &outWidth, int &outHeight, bool hasAlpha )
{
	// [BB] Make sure that outWidth and outHeight denote the size of
	// the returned buffer even if we don't upsample the input buffer.
	outWidth = inWidth;
	outHeight = inHeight;

	// [BB] Don't resample if the width or height of the input texture is bigger than gl_texture_hqresize_maxinputsize.
	if ( ( inWidth > gl_texture_hqresize_maxinputsize ) || ( inHeight > gl_texture_hqresize_maxinputsize ) )
		return inputBuffer;

	// [BB] Don't try to upsample textures based off FCanvasTexture.
	if ( inputTexture->bHasCanvas )
		return inputBuffer;

	// [BB] Don't upsample non-shader handled warped textures. Needs too much memory and time
	if (gl.shadermodel == 2 || (gl.shadermodel == 3 && inputTexture->bWarped))
		return inputBuffer;

	switch (inputTexture->UseType)
	{
	case FTexture::TEX_Sprite:
	case FTexture::TEX_SkinSprite:
		if (!(gl_texture_hqresize_targets & 2)) return inputBuffer;
		break;

	case FTexture::TEX_FontChar:
		if (!(gl_texture_hqresize_targets & 4)) return inputBuffer;
		break;

	default:
		if (!(gl_texture_hqresize_targets & 1)) return inputBuffer;
		break;
	}

	if (inputBuffer)
	{
		outWidth = inWidth;
		outHeight = inHeight;
		int type = gl_texture_hqresize;
		// hqNx does not preserve the alpha channel so fall back to ScaleNx for such textures
		if (hasAlpha && type > 3 && type < 7)
		{
			type -= 3;
		}

		typedef unsigned char* (*ScaleHelper)(const ScaleFunction func,
			const size_t scale, unsigned char* input, const size_t width, const size_t height);

		struct Scaler
		{
            const char*   algorithm;
			size_t        factor;
			ScaleFunction function;
			ScaleHelper   helper;
		};

		static const Scaler SCALERS[] =
		{
			{ NULL,      0, NULL,             NULL          },

			{ "scale2x", 2, scale2x,          scaleNxHelper },
			{ "scale3x", 3, scale3x,          scaleNxHelper },
			{ "scale4x", 4, scale4x,          scaleNxHelper },

			{ "hq2x",    2, hqNx<hq2x_32, 2>, hqNxHelper    },
			{ "hq3x",    3, hqNx<hq3x_32, 3>, hqNxHelper    },
			{ "hq4x",    4, hqNx<hq4x_32, 4>, hqNxHelper    },
			
            { "xbrz2x",  2, xbrzNx<2>,        scaleNxHelper },
			{ "xbrz3x",  3, xbrzNx<3>,        scaleNxHelper },
			{ "xbrz4x",  4, xbrzNx<4>,        scaleNxHelper },
			{ "xbrz5x",  5, xbrzNx<5>,        scaleNxHelper },
		};

		if (type > 0)
		{
			const Scaler&  scaler = SCALERS[type];

            outWidth  = static_cast<int>(scaler.factor * inWidth );
            outHeight = static_cast<int>(scaler.factor * inHeight);

            const size_t  inSize = size_t( inWidth *  inHeight * BYTES_PER_PIXEL);
            const size_t outSize = size_t(outWidth * outHeight * BYTES_PER_PIXEL);

#ifdef GZ_TEXTURE_SCALE_PROFILE
            cycle_t perf;
            perf.Reset();
            perf.Clock();
#endif // GZ_TEXTURE_SCALE_PROFILE

            unsigned char* result = s_textureCache.fetch(scaler.algorithm, inputBuffer, inSize, outSize);

#ifdef GZ_TEXTURE_SCALE_PROFILE
            perf.Unclock();

            if (NULL != result)
            {
                Printf(TEXTCOLOR_GOLD "[%ix%i] Fetched in %f ms\n", inWidth, inHeight, perf.TimeMS());
            }
#endif // GZ_TEXTURE_SCALE_PROFILE

            if (NULL == result)
            {
#ifdef GZ_TEXTURE_SCALE_PROFILE
                perf.Reset();
                perf.Clock();
#endif // GZ_TEXTURE_SCALE_PROFILE

                result = scaler.helper(scaler.function, 
                    scaler.factor, inputBuffer, size_t(inWidth), size_t(inHeight));

#ifdef GZ_TEXTURE_SCALE_PROFILE
                perf.Unclock();
                Printf(TEXTCOLOR_GREEN "[%ix%i] Scaled in %f ms\n", inWidth, inHeight, perf.TimeMS());
                perf.Reset();
                perf.Clock();
#endif // GZ_TEXTURE_SCALE_PROFILE

#ifdef GZ_TEXTURE_SCALE_PROFILE
                const bool isStored = 
#endif // GZ_TEXTURE_SCALE_PROFILE
                s_textureCache.store(scaler.algorithm, inputBuffer, inSize, result, outSize);

#ifdef GZ_TEXTURE_SCALE_PROFILE
                perf.Unclock();

                if (isStored)
                {
                    Printf(TEXTCOLOR_RED "[%ix%i] Stored in %f ms\n", inWidth, inHeight, perf.TimeMS());
                }
#endif // GZ_TEXTURE_SCALE_PROFILE
            }

            delete[] inputBuffer;

			return result;
		}
	}
	return inputBuffer;
}
