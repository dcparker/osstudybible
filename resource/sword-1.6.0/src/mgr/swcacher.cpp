/******************************************************************************
 *  swcacher.h	- definition of class SWCacher used to provide an interface for
 *  	objects that cache and want a standard interface for cleaning up.
 *
 * $Id: swcacher.cpp 1688 2005-01-01 04:42:26Z scribe $
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

#include <swcacher.h>

SWORD_NAMESPACE_START


SWCacher::SWCacher() {
}


SWCacher::~SWCacher() {
}


void SWCacher::flush() {
}

long SWCacher::resourceConsumption() {
	return 0;
}

long SWCacher::lastAccess() {
	return 0;
}

SWORD_NAMESPACE_END
