#define SWDLLEXPORT  

%module "Sword"
%module(directors="1") Sword;

/* Ignore warnings about Unknown base class */
%warnfilter(401);

%include "directors.i"

/* Some generic ignores. These don't map into any Python operators */
%ignore *::operator=;
%ignore *::operator++;
%ignore *::operator--;
%ignore *::operator const char *;
%ignore *::operator sword::SWKey &;
%ignore *::operator sword::SWKey *;

%include "defs.i"
%include "swbuf.i"

/* Now include all the STL templates we are going to use */
%include "templates.i"

%include "swobject.i"
%include "swconfig.i"
%include "swversion.i"
%include "bases.i"

%include "swkey.i"
%include "listkey.i"
%include "versekey.i"
%include "treekey.i"
%include "treekeyidx.i"
%include "versetreekey.i"

%include "swdisp.i"

%include "swfilter.i"
%include "swoptfilter.i"
%include "swfiltermgr.i"


%include "stringmgr.i"
%include "swsearchable.i"
//%include "swcacher.i"
%include "swmodule.i"



%include "swmgr.i"
%include "filemgr.h"

%include "encfiltmgr.i"
%include "markupfiltmgr.i"

%include "swlocale.i"

%include "swcomprs.i"
%include "lzsscomprs.i"
%include "zipcomprs.i"


%include "swcom.i"
%include "rawcom.i"
%include "zcom.i"

%include "swgenbook.i"
%include "rawgenbook.i"

%include "swld.i"
%include "rawld.i"
%include "rawld4.i"
%include "zld.i"

%include "swtext.i"
%include "rawtext.i"
%include "ztext.i"

%include "localemgr.i"

%include "url.i"
%include "utilxml.i"

%include "osishtmlhref.i"
%include "extras.i"
%include "swlog.i"

#ifndef EXCLUDE_FTP
%include "ftptrans.i"

#ifndef EXCLUDE_INSTALLMGR
%include "installmgr.i"
#endif
#endif
