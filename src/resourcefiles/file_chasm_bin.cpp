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

#include <cstdio>

#include "cmdlib.h"
#include "doomdef.h"
#include "templates.h"
#include "w_wad.h"


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
		DWORD magic;
		WORD entryCount;
	};

	struct ChasmBinEntry
	{
		BYTE nameSize;
		char name[12];

		DWORD size;
		DWORD offset;
	};

#pragma pack()

	const DWORD CHASM_BIN_MAGIC = MAKE_ID('C', 'S', 'i', 'd');

	class MemoryLump : public FResourceLump
	{
	public:
		MemoryLump(const FString& buffer)
		: m_buffer(buffer)
		, m_reader(m_buffer.GetChars(), m_buffer.Len())
		{

		}

		virtual FileReader* GetReader()
		{
			return &m_reader;
		}

		virtual int FillCache()
		{
			Cache    = const_cast<char*>(m_reader.GetBuffer());
			RefCount = -1;
			
			return -1;
		}

		virtual int GetFileOffset() { return 0; }

	private:
		FString      m_buffer;
		MemoryReader m_reader;

	};

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
	~FChasmBinFile();

	virtual bool Open(bool quiet);

	virtual FResourceLump* GetLump(int no);

private:
	DWORD m_fileLumpCount;

	TArray<MemoryLump*> m_specialLumps;

	bool ReadNextEntry(const DWORD index);

	void AddSoundInfoLump();

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
, m_fileLumpCount(0)
{

}

FChasmBinFile::~FChasmBinFile()
{
	for (unsigned int i = 0, count = m_specialLumps.Size(); i < count; ++i)
	{
		delete m_specialLumps[i];
	}
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

	m_fileLumpCount = LittleLong(header.entryCount);
	Lumps = new FUncompressedLump[m_fileLumpCount];

	for (DWORD i = 0; i < m_fileLumpCount; ++i)
	{
		if (!ReadNextEntry(i))
		{
			return false;
		}
	}

	AddSoundInfoLump();

	NumLumps = m_fileLumpCount + m_specialLumps.Size();

	if (!quiet)
	{
		Printf(", %d lumps\n", NumLumps);
	}

	return true;
}

FResourceLump* FChasmBinFile::GetLump(int no)
{
	const DWORD lump = static_cast<DWORD>(no);

	if (lump < m_fileLumpCount)
	{
		return &Lumps[lump];
	}
	else if (lump < m_fileLumpCount + m_specialLumps.Size())
	{
		return m_specialLumps[m_fileLumpCount - lump];
	}

	return NULL;
}

bool FChasmBinFile::ReadNextEntry(const DWORD index)
{
	ChasmBinEntry entry;

	const long bytesRead = Reader->Read(&entry, long(sizeof entry));
	if (size_t(bytesRead) != sizeof entry)
	{
		return false;
	}

	char name[sizeof entry.name + 1];
	memcpy(name, entry.name, sizeof entry.name);
	name[sizeof name - 1] = '\0';

	FUncompressedLump& lump = Lumps[index];
	lump.Owner    = this;
	lump.Position = LittleLong(entry.offset);
	lump.LumpSize = LittleLong(entry.size);
	lump.FullName = copystring(name);
	
	// TODO: namespace

	memset(lump.Name, 0, sizeof lump.Name);

	const char* const extension = strrchr(name, '.');
	if (NULL == extension)
	{
		return true;
	}

	// Assign short name for supported files only

	if (   0 == stricmp(extension, ".cel")
		|| 0 == stricmp(extension, ".wav"))
	{
		strncpy(lump.Name, name, extension - name);
	}

	return true;
}

void FChasmBinFile::AddSoundInfoLump()
{
	FString soundInfo;

	for (DWORD i = 0; i < m_fileLumpCount; ++i)
	{
		const FResourceLump& lump = Lumps[i];

		const char* const fullName = lump.FullName;
		const char* const extension = strrchr(fullName, '.');

		if (NULL == extension)
		{
			continue;
		}

		if (0 == stricmp(extension, ".wav"))
		{
			soundInfo += "chasm/";
			soundInfo += lump.Name;
			soundInfo += " ";
			soundInfo += lump.Name;
			soundInfo += "\n";
		}
	}

	MemoryLump* lump = new MemoryLump(soundInfo);
	lump->Owner    = this;
	lump->LumpSize = soundInfo.Len();
	lump->FullName = copystring("sndinfo.txt");
	strcpy(lump->Name, "SNDINFO");

	m_specialLumps.Push(lump);
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
		DWORD magic;

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
