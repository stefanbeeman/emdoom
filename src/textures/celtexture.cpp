/*
** celtexture.cpp
** Texture class for Chasm: The Rift CEL texture
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
#include "files.h"
#include "w_wad.h"

//==========================================================================
//
// CEL file header
//
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
}

//==========================================================================
//
// CEL texture
//
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

protected:
	BYTE* m_pixels;
	BYTE m_palette[3 * 256];

	Span** m_spans;

	void MakeTexture();

};


//==========================================================================
//
//
//
//==========================================================================

FTexture* CELTexture_TryCreate(FileReader& file, int lumpnum)
{
	CELHeader header;

	file.Seek(0, SEEK_SET);

	if (sizeof header != file.Read(&header, sizeof header))
	{
		return NULL;
	}

	header.magic  = LittleShort(header.magic);
	header.width  = LittleShort(header.width);
	header.height = LittleShort(header.height);
	header.x      = LittleShort(header.x);
	header.y      = LittleShort(header.y);
	header.size   = LittleLong (header.size);

	if (0x9119 != header.magic
		|| header.width * header.height != header.size
		|| 8 != header.depth
		|| 0 != header.compress)
	{
		return NULL;
	}

	return new FCELTexture(lumpnum, header);
}

//==========================================================================
//
//
//
//==========================================================================

FCELTexture::FCELTexture(int lumpnum, const CELHeader& header)
: FTexture(NULL, lumpnum)
, m_pixels(NULL)
, m_spans(NULL)
{
	Width  = header.width;
	Height = header.height;

	bMasked = true;

	CalcBitSize();
}

//==========================================================================
//
//
//
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
//
//
//
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
//
//
//
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
//
//
//
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
//
//
//
//==========================================================================

void FCELTexture::MakeTexture()
{
	m_pixels = new BYTE[Width * Height];

	FWadLump lump = Wads.OpenLumpNum(SourceLump);
	lump.Seek(sizeof(CELHeader), SEEK_SET);
	lump.Read(m_palette, sizeof m_palette);
	lump.Read(m_pixels, Width * Height);

	for (size_t i = 0; i < 256; ++i)
	{
		BYTE* color = &m_palette[3 * i];
		color[0] *= 4;
		color[1] *= 4;
		color[2] *= 4;
	}

	// TODO: apply palette
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
	// TODO: implement without MakeTexture()

	if (NULL == m_pixels)
	{
		MakeTexture();
	}

	PalEntry palette[256];

	for (size_t i = 0; i < 256; ++i)
	{
		const BYTE* color = &m_palette[3 * i];
		palette[i] = PalEntry(255, color[0], color[1], color[2]);
	}

	// Looks like the last palette entry is used as alpha mask color
	palette[255].a = 0;

	bitmap->CopyPixelData(x, y, m_pixels, Width, Height, 1, Width, rotate, palette, info);

	return 0;
}
