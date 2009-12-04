/******************************************************************************
 *
 * utf8html -	SWFilter descendant to convert a UTF-8 stream to HTML escapes
 *
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

#include <stdlib.h>
#include <stdio.h>
#include <utf8html.h>
#include <swbuf.h>

SWORD_NAMESPACE_START

UTF8HTML::UTF8HTML() {
}


char UTF8HTML::processText(SWBuf &text, const SWKey *key, const SWModule *module)
{
	unsigned char *from;
	int len;
        char digit[10];
        unsigned long ch;
	 if ((unsigned long)key < 2)	// hack, we're en(1)/de(0)ciphering
		return (char)-1;

	len = strlen(text.c_str()) + 2;						// shift string to right of buffer

	SWBuf orig = text;
  	from = (unsigned char *)orig.c_str();

	// -------------------------------
	for (text = ""; *from; from++) {
	  ch = 0;
          if ((*from & 128) != 128) {
//          	if (*from != ' ')
	       text += *from;
               continue;
          }
          if ((*from & 128) && ((*from & 64) != 64)) {
	    // error
               *from = 'x';
               continue;
          }
          *from <<= 1;
          int subsequent;
          for (subsequent = 1; (*from & 128); subsequent++) {
          	*from <<= 1;
               from[subsequent] &= 63;
               ch <<= 6;
               ch |= from[subsequent];
          }
          subsequent--;
          *from <<=1;
          char significantFirstBits = 8 - (2+subsequent);
          
          ch |= (((short)*from) << (((6*subsequent)+significantFirstBits)-8));
          from += subsequent;
          text += '&';
          text += '#';
	  sprintf(digit, "%ld", ch);
		for (char *dig = digit; *dig; dig++)
			text += *dig;
		text += ';';
	}
	return 0;
}

SWORD_NAMESPACE_END
