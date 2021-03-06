/***************************************************************************
 *                  thmlcgi.h  -  OSIS to Diatheke/CGI format
 *                            -------------------
 *   begin                : 2001-11-12
 *   copyright            : 2001 by CrossWire Bible Society
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

#ifndef THMLCGI_H
#define THMLCGI_H

#include <swbasicfilter.h>
#include <map>

#include <defs.h>

SWORD_NAMESPACE_START

typedef std::map<SWBuf, SWBuf> DualStringMap;
/** this filter converts ThML text to Diatheke/CGI format
 */
class ThMLCGI : public SWBasicFilter {
protected:
	virtual bool handleToken(SWBuf &buf, const char *token, DualStringMap &userData);
public:
	ThMLCGI();
};

SWORD_NAMESPACE_END
#endif
