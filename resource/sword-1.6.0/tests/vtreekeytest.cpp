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

#include <iostream>
#include <stdio.h>
#include <stdlib.h>

#include <versekey.h>
#include <listkey.h>
#include <localemgr.h>
#include <swmgr.h>
#include <swmodule.h>
#ifndef NO_SWORD_NAMESPACE
using namespace sword;
#endif

using std::cout;
using std::endl;

int main(int argc, char **argv) {

	SWMgr mgr;
	SWModule *mod = mgr.getModule("KJVgb");

	VerseKey *key1 = (VerseKey *)mod->CreateKey();

	key1->Testament(2);
	key1->Book(4);
	key1->Chapter(2);
	key1->Verse(3);

	cout << "\n" << key1->getText() << ":\n\n";

	ListKey keys;
	keys << *key1;

	cout << "\n" << keys.getRangeText() << ":\n\n";

	ListKey keys2 = keys;

	cout << "\n" << keys2.getRangeText() << ":\n\n";

	keys = key1->ParseVerseList("Lk.4.5");

	cout << "\n" << key1->getText() << ":\n\n";

	key1->setText("jn.6.7");

	cout << "\n" << key1->getText() << ":\n\n";
	

	mod->setKey("lk.2.3");

	cout << "\n" << mod->getKeyText() << ":\n" << endl;
	cout << mod->getRawEntry() << endl;


	cout << "\nListkey persist key iteration test\n\n";
	keys = key1->ParseVerseList("mat1", 0, true);

	for (keys = TOP; !keys.Error(); keys++) {
		cout << "\n" << keys.getText() << ":\n" << endl;
	}


	keys.Persist(1);

	mod->setKey(keys);

	for ((*mod) = TOP; !mod->Error(); (*mod)++) {
		cout << "\n" << mod->getKeyText() << ":\n" << endl;
	}

	delete key1;

	return 0;
}
