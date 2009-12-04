/*
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

#include <sysdata.h>
#include <stdio.h>

int main(int argc, char **argv) {
	printf("0x%.4x 0x%.4x\n", 255, __swap16(255));
	printf("0x%.8x 0x%.8x\n", 255, __swap32(255));
//	printf("0x%.16x 0x%.16llx\n", 255, __swap64(255));
	return 0;
}
