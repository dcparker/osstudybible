/******************************************************************************
*  swgenbook.h
*
* $Id: swgenbook.h 2303 2009-04-06 13:38:34Z scribe $
*
* Copyright 1998 CrossWire Bible Society (http://www.crosswire.org)
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

#ifndef SWGENBOOK_H
#define SWGENBOOK_H

#include <defs.h>

#include <swmodule.h>
#include <treekey.h>


SWORD_NAMESPACE_START

/** The basis for all Book modules.
*/
class SWDLLEXPORT SWGenBook : public SWModule {

protected:
	char *entkeytxt;
	mutable TreeKey *tmpTreeKey;
	TreeKey &getTreeKey(const SWKey *k = 0) const;

public:
	/** Initializes data for instance of SWGenBook
	*/
	SWGenBook(const char *imodname = 0, const char *imoddesc = 0,
			SWDisplay * idisp = 0, SWTextEncoding encoding = ENC_UNKNOWN,
			SWTextDirection dir = DIRECTION_LTR,
			SWTextMarkup markup = FMT_UNKNOWN, const char* ilang = 0);

	virtual ~SWGenBook();
	virtual SWKey *CreateKey() const = 0;


	// OPERATORS -----------------------------------------------------------------
	
	SWMODULE_OPERATORS

};

SWORD_NAMESPACE_END
#endif
