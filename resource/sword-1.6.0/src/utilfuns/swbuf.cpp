/******************************************************************************
*  swbuf.cpp  - code for SWBuf used as a transport and utility for data buffers
*
* $Id: swbuf.cpp 2198 2008-09-11 20:59:30Z scribe $
*
* Copyright 2003 CrossWire Bible Society (http://www.crosswire.org)
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

#include <swbuf.h>

#include <stdlib.h>
#include <stdarg.h>
#include <stdio.h>

SWORD_NAMESPACE_START

char *SWBuf::nullStr = (char *)"";
char SWBuf::junkBuf[JUNKBUFSIZE];

/******************************************************************************
* SWBuf Constructor - Creates an empty SWBuf object or an SWBuf initialized
* 		to a value from a const char *
*
*/
SWBuf::SWBuf(const char *initVal, unsigned long initSize) {
	init(initSize);
	if (initVal)
		set(initVal);
}

/******************************************************************************
* SWBuf Constructor - Creates an SWBuf initialized
* 		to a value from another SWBuf
*
*/
SWBuf::SWBuf(const SWBuf &other, unsigned long initSize) {
	init(initSize);
	set(other);
}

/******************************************************************************
* SWBuf Constructor - Creates an SWBuf initialized
* 		to a value from a char
*
*/
SWBuf::SWBuf(char initVal, unsigned long initSize) {
	init(initSize+1);
	*buf = initVal;
	end = buf+1;
	*end = 0;
}

/*
SWBuf::SWBuf(unsigned long initSize) {
	init(initSize);
	set((const char *)0);
}
*/


/******************************************************************************
* SWBuf::setFormatted - sets this buf to a formatted string
* WARNING: This function can only write at most
* JUNKBUFSIZE to the string per call.
*/
SWBuf &SWBuf::setFormatted(const char *format, ...) {
	va_list argptr;

	va_start(argptr, format);
#ifdef NO_VSNPRINTF
	int len = vsprintf(junkBuf, format, argptr)+1;
#else
	int len = vsnprintf(0, 0, format, argptr)+1;
#endif
	va_end(argptr);
	assureSize(len);
	va_start(argptr, format);
	end = vsprintf(buf, format, argptr) + buf;
	va_end(argptr);
	return *this;
}

/******************************************************************************
* SWBuf::append - appends a value to the current value of this SWBuf
* 
*/
void SWBuf::append(const char *str, long max) {
//	if (!str) //A null string was passed
//		return;
	if (max < 0)
		max = strlen(str);
	assureMore(max+1);
	for (;((max)&&(*str));max--)
		*end++ = *str++;
	*end = 0;
}

/******************************************************************************
* SWBuf::setSize - Size this buffer to a specific length
*/
void SWBuf::setSize(unsigned long len) {
	assureSize(len+1);
	if ((unsigned)(end - buf) < len)
		memset(end, fillByte, len - (end-buf));
	end = buf + len;
	*end = 0;
}

/******************************************************************************
* SWBuf::appendFormatted - appends formatted strings to the current value of this SWBuf
* WARNING: This function can only write at most
* JUNKBUFSIZE to the string per call.
*/
void SWBuf::appendFormatted(const char *format, ...) {
	va_list argptr;

	va_start(argptr, format);
#ifdef NO_VSNPRINTF
	int len = vsprintf(junkBuf, format, argptr)+1;
#else
	int len = vsnprintf(0, 0, format, argptr)+1;
#endif
	va_end(argptr);
	assureMore(len);
	va_start(argptr, format);
	end += vsprintf(end, format, argptr);
	va_end(argptr);
}

void SWBuf::insert(unsigned long pos, const char* str, unsigned long start, signed long max) {
// 	if (!str) //A null string was passed
// 		return;

	str += start;
	int len = (max > -1) ? max : strlen(str);

	if (!len || (pos > length())) //nothing to do, return
		return;
	
	// pos==length(), so we can call append in this case
	if (pos == length()) { //append is more efficient
		append(str, max);
		return;
	}
	
	assureMore( len );
	
	memmove(buf + pos + len, buf + pos, (end - buf) - pos); //make a gap of "len" bytes
	memcpy(buf+pos, str, len);
	
	end += len;
	*end = 0;
}

SWORD_NAMESPACE_END
