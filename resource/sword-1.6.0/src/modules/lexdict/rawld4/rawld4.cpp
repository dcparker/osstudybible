/******************************************************************************
 *  rawld.cpp - code for class 'RawLD'- a module that reads raw lexicon and
 *		dictionary files: *.dat *.idx
 *
 *
 * Copyright 2009 CrossWire Bible Society (http://www.crosswire.org)
 *	CrossWire Bible Society
 *	P. O. Box 2528
 *	Tempe, AZ  85280-2528
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation version 2.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 */

#include <fcntl.h>

#include <filemgr.h>
#include <utilstr.h>
#include <rawstr4.h>
#include <rawld4.h>

#include <stdio.h>

SWORD_NAMESPACE_START

 /******************************************************************************
 * RawLD Constructor - Initializes data for instance of RawLD
 *
 * ENT:	ipath	- path and filename of files (no extension)
 *		iname	- Internal name for module
 *		idesc	- Name to display to user for module
 *		idisp	- Display object to use for displaying
 */

RawLD4::RawLD4(const char *ipath, const char *iname, const char *idesc, SWDisplay *idisp, SWTextEncoding enc, SWTextDirection dir, SWTextMarkup mark, const char* ilang) : RawStr4(ipath), SWLD(iname, idesc, idisp, enc, dir, mark, ilang)
{
}


/******************************************************************************
 * RawLD Destructor - Cleans up instance of RawLD
 */

RawLD4::~RawLD4()
{
}


bool RawLD4::isWritable() {
	return ((idxfd->getFd() > 0) && ((idxfd->mode & FileMgr::RDWR) == FileMgr::RDWR));
}


/******************************************************************************
 * RawLD4::getEntry	- Looks up entry from data file.  'Snaps' to closest
 *				entry and sets 'entrybuf'.
 *
 * ENT: away - number of entries offset from key (default = 0)
 *
 * RET: error status
 */

char RawLD4::getEntry(long away)
{
	__u32 start  = 0;
	__u32 size   = 0;
	char *idxbuf = 0;
	char retval  = 0;

	char *buf = new char [ strlen(*key) + 6 ];
	strcpy(buf, *key);

	strongsPad(buf);

	entryBuf = "";
	if (!(retval = findOffset(buf, &start, &size, away))) {
		readText(start, &size, &idxbuf, entryBuf);
		rawFilter(entryBuf, 0);	// hack, decipher
		rawFilter(entryBuf, key);
		entrySize = size;        // support getEntrySize call
		if (!key->Persist())			// If we have our own key
			*key = idxbuf;				// reset it to entry index buffer

		stdstr(&entkeytxt, idxbuf);	// set entry key text that module 'snapped' to.
		delete [] idxbuf;
	}
		
	delete [] buf;
	return retval;
}


/******************************************************************************
 * RawLD4::getRawEntry	- Returns the correct entry when char * cast
 *							is requested
 *
 * RET: string buffer with entry
 */

SWBuf &RawLD4::getRawEntryBuf() {

	char ret = getEntry();
	if (!ret) {
//		if (!isUnicode())
			prepText(entryBuf);
	}
	else error = ret;

	return entryBuf;
}


/******************************************************************************
 * RawLD4::increment	- Increments module key a number of entries
 *
 * ENT:	increment	- Number of entries to jump forward
 *
 * RET: *this
 */

void RawLD4::increment(int steps) {
	char tmperror;

	if (key->isTraversable()) {
		*key += steps;
		error = key->Error();
		steps = 0;
	}
	
	tmperror = (getEntry(steps)) ? KEYERR_OUTOFBOUNDS : 0;
	error = (error)?error:tmperror;
	*key = entkeytxt;
}


void RawLD4::setEntry(const char *inbuf, long len) {
	doSetText(*key, inbuf, len);
}


void RawLD4::linkEntry(const SWKey *inkey) {
	doLinkEntry(*key, *inkey);
}


/******************************************************************************
 * RawFiles::deleteEntry	- deletes this entry
 *
 * RET: *this
 */

void RawLD4::deleteEntry() {
	doSetText(*key, "");
}

long RawLD4::getEntryCount() const {
	if (idxfd < 0) return 0;
	return idxfd->seek(0, SEEK_END) / IDXENTRYSIZE;
}

long RawLD4::getEntryForKey(const char *key) const {
	__u32 start, offset;
	__u32 size;

	char *buf = new char [ strlen(key) + 6 ];
	strcpy(buf, key);

	strongsPad(buf);
	
	findOffset(buf, &start, &size, 0, &offset);

	delete [] buf;

	return offset / IDXENTRYSIZE;
}

char *RawLD4::getKeyForEntry(long entry) const {
	char *key = 0;
	getIDXBuf(entry * IDXENTRYSIZE, &key);
	return key;
}

SWORD_NAMESPACE_END
