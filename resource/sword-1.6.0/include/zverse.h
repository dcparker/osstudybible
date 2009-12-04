/******************************************************************************
 *  rawverse.h   - code for class 'zVerse'- a module that reads raw text
 *			files:  ot and nt using indexs ??.bks ??.cps ??.vss
 *			and provides lookup and parsing functions based on
 *			class VerseKey
 */

#ifndef ZVERSE_H
#define ZVERSE_H

#include <defs.h>

SWORD_NAMESPACE_START

class FileDesc;
class SWCompress;
class SWBuf;

class SWDLLEXPORT zVerse {
	SWCompress *compressor;

protected:
	static int instance;		// number of instantiated zVerse objects or derivitives

	FileDesc *idxfp[2];
	FileDesc *textfp[2];
	FileDesc *compfp[2];
	char *path;
	void doSetText(char testmt, long idxoff, const char *buf, long len = 0);
	void doLinkEntry(char testmt, long destidxoff, long srcidxoff);
	void flushCache();
	char *cacheBuf;
	unsigned int cacheBufSize;
	char cacheTestament;
	long cacheBufIdx;
	bool dirtyCache;

public:

#define	VERSEBLOCKS 2
#define	CHAPTERBLOCKS 3
#define	BOOKBLOCKS 4

	static const char uniqueIndexID[];
	char nl;


	// fileMode default = RDONLY
	zVerse(const char *ipath, int fileMode = -1, int blockType = CHAPTERBLOCKS, SWCompress * icomp = 0);
	virtual ~zVerse();

	void findOffset(char testmt, long idxoff, long *start, unsigned short *size, unsigned long *buffnum) const;
	void zReadText(char testmt, long start, unsigned short size, unsigned long buffnum, SWBuf &buf);
	virtual void rawZFilter(SWBuf &buf, char direction = 0) {}
	static char createModule(const char *path, int blockBound, const char *v11n = "KJV");
};

SWORD_NAMESPACE_END
#endif
