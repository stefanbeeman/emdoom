/*
** file_chasm_bin.cpp
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

#include "resourcefile.h"

#include <cstdint>
#include <cstdio>

#include "cmdlib.h"
#include "doomdef.h"
#include "templates.h"

//==========================================================================
//
// Internal definitions
//
//==========================================================================

namespace
{
#pragma pack(1)

	struct ChasmBinHeader
	{
		uint32_t magic;
		uint16_t entryCount;
	};

	struct ChasmBinEntry
	{
		uint8_t nameSize;
		char name[12];

		uint32_t size;
		uint32_t offset;
	};

#pragma pack()

	const uint32_t CHASM_BIN_MAGIC = MAKE_ID('C', 'S', 'i', 'd');

}


//==========================================================================
//
// Chasm BIN file
//
//==========================================================================

class FChasmBinFile : public FUncompressedFile
{
public:
	FChasmBinFile(const char * filename, FileReader *file);
	bool Open(bool quiet);

	void DumpFiles(const char* const path);

};


//==========================================================================
//
// FChasmBinFile::FChasmBinFile
//
// Initializes a Chasm BIN file
//
//==========================================================================

FChasmBinFile::FChasmBinFile(const char *filename, FileReader *file)
: FUncompressedFile(filename, file)
{
	Lumps = NULL;
}

//==========================================================================
//
// Open it
//
//==========================================================================

bool FChasmBinFile::Open(bool quiet)
{
	ChasmBinHeader header;
	Reader->Read(&header, sizeof header);

	NumLumps = LittleLong(header.entryCount);
	Lumps = new FUncompressedLump[NumLumps];

	for (DWORD i = 0; i < NumLumps; ++i)
	{
		ChasmBinEntry entry;

		const long bytesRead =  Reader->Read(&entry, long(sizeof entry));
		if (size_t(bytesRead) != sizeof entry)
		{
			return false;
		}

		char name[sizeof entry.name + 1];
		memcpy(name, entry.name, sizeof entry.name);
		name[sizeof name - 1] = '\0';

		FUncompressedLump& lump = Lumps[i];
		lump.Owner = this;
		lump.Position = LittleLong(entry.offset);
		lump.LumpSize = LittleLong(entry.size);
		lump.LumpNameSetup(name);

		// TODO: namespace
	}

	if (!quiet)
	{
		Printf(", %d lumps\n", NumLumps);
	}

	return true;
}

void FChasmBinFile::DumpFiles(const char* const path)
{
	CreatePath(path);

	for (DWORD i = 0; i < NumLumps; ++i)
	{
		char filename[1024] = {};
		mysnprintf(filename, sizeof filename, "%s/%s", path, Lumps[i].FullName);

		FILE* const file = fopen(filename, "wb");
		if (NULL == file)
		{
			continue;
		}

		Reader->Seek(Lumps[i].Position, SEEK_SET);

		for (long bytesLeft = Lumps[i].LumpSize; bytesLeft > 0; /* EMPTY */)
		{
			unsigned char buffer[4096];

			const long bytesToRead = MIN(bytesLeft, long(sizeof buffer));
			const long bytesRead = Reader->Read(buffer, bytesToRead);

			fwrite(buffer, bytesRead, 1, file);

			bytesLeft -= bytesRead;
		}

		fclose(file);
	}
}


//==========================================================================
//
// File open
//
//==========================================================================

FResourceFile *CheckChasmBin(const char *filename, FileReader *file, bool quiet)
{
	if (file->GetLength() > 4)
	{
		uint32_t magic;

		file->Seek(0, SEEK_SET);
		file->Read(&magic, 4);
		file->Seek(0, SEEK_SET);

		if (LittleLong(magic) == CHASM_BIN_MAGIC)
		{
			FResourceFile* result = new FChasmBinFile(filename, file);

			if (result->Open(quiet))
			{
				return result;
			}

			delete result;
		}
	}

	return NULL;
}
