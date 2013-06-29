/*
** celtexture.cpp
**
** Texture class for Chasm: The Rift CEL texture
**
** This format is also called OPIC (old PIC)
** and it is produced by Autodesk Animator Pro
**
** See http://www.animatorpro.org/ 
** and https://github.com/AnimatorPro/Animator-Pro
**
**---------------------------------------------------------------------------
** Copyright 2013 Alexey Lysiuk
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

#include "textures/textures.h"

#include "bitmap.h"
#include "colormatcher.h"
#include "files.h"
#include "w_wad.h"

//==========================================================================

namespace
{
#pragma pack(1)

	struct CELHeader
	{
		WORD magic;

		WORD width;
		WORD height;

		SWORD x;
		SWORD y;

		BYTE depth;
		BYTE compress;

		DWORD size;

		BYTE reserved[16];
	};

#pragma pack()

	typedef BYTE CELPalette[3 * 256];

	bool LoadCELHeader(FileReader& file, CELHeader& header)
	{
		if (sizeof header != file.Read(&header, sizeof header))
		{
			return false;
		}

		header.magic  = LittleShort(header.magic);
		header.width  = LittleShort(header.width);
		header.height = LittleShort(header.height);
		header.x      = LittleShort(header.x);
		header.y      = LittleShort(header.y);
		header.size   = LittleLong (header.size);

		if (0x9119 != header.magic
			|| 0 == header.width
			|| 0 == header.height
			|| 0 == header.size
			|| header.width * header.height != header.size
			|| 8 != header.depth
			|| 0 != header.compress)
		{
			return false;
		}

		return true;
	}

	bool LoadCELLump(const int lumpnum, CELPalette& palette, BYTE*& pixels)
	{
		FWadLump lump = Wads.OpenLumpNum(lumpnum);

		// Read header

		CELHeader header;

		if (!LoadCELHeader(lump, header))
		{
			return false;
		}

		// Read palette
		// and convert from its resolution from 0..63 to 0..255

		if (sizeof palette != lump.Read(&palette, sizeof palette))
		{
			return false;
		}

		for (size_t i = 0; i < 256; ++i)
		{
			BYTE* color = &palette[3 * i];
			color[0] *= 4;
			color[1] *= 4;
			color[2] *= 4;
		}

		// Read pixels

		pixels = new BYTE[header.size];

		if (header.size != lump.Read(pixels, header.size))
		{
			delete[] pixels;
			return false;
		}

		return true;
	}

}

//==========================================================================

class FCELTexture : public FTexture
{
	friend class FTexture;

public:
	explicit FCELTexture(int lumpnum, const CELHeader& header);
	~FCELTexture();

	virtual const BYTE* GetColumn(unsigned int column, const Span** spans);
	virtual const BYTE* GetPixels();

	virtual void Unload();

	virtual FTextureFormat GetFormat()
	{
		return TEX_RGB;
	}

	virtual int CopyTrueColorPixels(FBitmap* bitmap, int x, int y, int rotate, FCopyInfo* info = NULL);

	virtual bool UseBasePalette()
	{
		return false;
	}

private:
	BYTE*  m_pixels;
	Span** m_spans;

	void MakeTexture();

};

//==========================================================================

FTexture* CELTexture_TryCreate(FileReader& file, int lumpnum)
{
	file.Seek(0, SEEK_SET);

	CELHeader header;

	if (!LoadCELHeader(file, header))
	{
		return NULL;
	}

	return new FCELTexture(lumpnum, header);
}

//==========================================================================

FCELTexture::FCELTexture(int lumpnum, const CELHeader& header)
: FTexture(NULL, lumpnum)
, m_pixels(NULL)
, m_spans(NULL)
{
	Width  = header.width;
	Height = header.height;

	bMasked = true; // TODO: need to read pixel data to set correct value

	CalcBitSize();
}

//==========================================================================

FCELTexture::~FCELTexture()
{
	Unload();

	if (NULL != m_spans)
	{
		FreeSpans(m_spans);
	}
}

//==========================================================================

void FCELTexture::Unload()
{
	if (NULL != m_pixels)
	{
		delete[] m_pixels;
		m_pixels = NULL;
	}
}

//==========================================================================

const BYTE* FCELTexture::GetColumn(unsigned int column, const Span** spans)
{
	if (m_pixels == NULL)
	{
		MakeTexture();
	}

	if (DWORD(column) >= DWORD(Width))
	{
		if (WidthMask + 1 == Width)
		{
			column &= WidthMask;
		}
		else
		{
			column %= Width;
		}
	}

	if (NULL != spans)
	{
		if (NULL == m_spans)
		{
			m_spans = CreateSpans(m_pixels);
		}

		*spans = m_spans[column];
	}

	return m_pixels + column * Height;
}

//==========================================================================

const BYTE* FCELTexture::GetPixels()
{
	if (NULL == m_pixels)
	{
		MakeTexture();
	}

	return m_pixels;
}

//==========================================================================

void FCELTexture::MakeTexture()
{
	CELPalette celPalette;

	LoadCELLump(SourceLump, celPalette, m_pixels);

	BYTE palette[256];

	for (size_t i = 0; i < 255; ++i)
	{
		const BYTE* const color = &celPalette[3 * i];
		palette[i] = ColorMatcher.Pick(color[0], color[1], color[2]);
	}

	// The last palette entry is an alpha mask
	palette[255] = 0;

	const BYTE* const oldPixels = m_pixels;

	m_pixels = new BYTE[Width * Height];
	FlipNonSquareBlockRemap(m_pixels, oldPixels, Width, Height, Width, palette);

	delete[] oldPixels;
}

//===========================================================================
//
// FCELTexture::CopyTrueColorPixels
//
// Preserves the full color information (unlike software mode)
//
//===========================================================================

int FCELTexture::CopyTrueColorPixels(FBitmap* bitmap, int x, int y, int rotate, FCopyInfo* info)
{
	CELPalette celPalette = {};
	BYTE* pixels = NULL;

	LoadCELLump(SourceLump, celPalette, pixels);

	PalEntry palette[256];

	for (size_t i = 0; i < 256; ++i)
	{
		const BYTE* const color = &celPalette[3 * i];
		palette[i] = PalEntry(255, color[0], color[1], color[2]);
	}

	// The last palette entry is an alpha mask
	palette[255].a = 0;

	bitmap->CopyPixelData(x, y, pixels, Width, Height, 1, Width, rotate, palette, info);

	delete[] pixels;

	return 1;
}
