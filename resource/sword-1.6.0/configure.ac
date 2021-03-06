# ---------------------------------------------------------------------
# Initialisation
# ---------------------------------------------------------------------

# Version change: Change line 8 only !
# Change it immediately after a release

AC_INIT(sword, 1.6.0, sword-bugs@crosswire.org)
AC_CONFIG_SRCDIR(sword.bmp)
AC_PREREQ(2.52)
AC_REVISION($Revision: 1.45 $)

AC_CANONICAL_TARGET
AM_INIT_AUTOMAKE

AM_CONFIG_HEADER(include/config.h)

AC_CONFIG_MACRO_DIR([m4])

# ---------------------------------------------------------------------
# Check Programs
# ---------------------------------------------------------------------
CFLAGS=" $CFLAGS"
CXXFLAGS=" $CXXFLAGS"
AC_LANG(C++)
AC_PROG_CC
AC_PROG_CXX
AC_PROG_INSTALL
AC_LIBTOOL_WIN32_DLL
AC_PROG_LIBTOOL

AC_C_BIGENDIAN

ACX_CLUCENE

# ---------------------------------------------------------------------
# With options
# ---------------------------------------------------------------------
AC_ARG_WITH(zlib,
	AC_HELP_STRING([--with-zlib],[allow zlib compressed modules (default=yes)]),,with_zlib=yes)
AC_ARG_WITH(icu,
	AC_HELP_STRING([--with-icu],[use ICU for unicode (default=no)]),,with_icu=no)
AC_ARG_WITH(conf,
	AC_HELP_STRING([--with-conf],[install a new sword.conf (default=yes)]),,with_conf=yes)
#AC_ARG_WITH(installmgr,
#	AC_HELP_STRING([--with-installmgr],[build install manager support: 
#	curl=using libcurl, 
#	ftplib=using external ftplib, 
#	internal=using internal ftplib 
#	(default=internal)]),,with_installmgr=internal)
AC_ARG_WITH(curl,
	AC_HELP_STRING([--with-curl],[build install manager support using libcurl (default=yes)]),,with_curl=yes)
#AC_ARG_WITH(lucene,
#	AC_HELP_STRING([--with-lucene],[include lucene support for searching (default=no)]),,with_lucene=no)


# ---------------------------------------------------------------------
# Enable options
# ---------------------------------------------------------------------
AC_ARG_ENABLE(debug,
	AC_HELP_STRING([--enable-debug],[build debug library (default=no)]),,enable_debug=no)
AC_ARG_ENABLE(warnings,
	AC_HELP_STRING([--enable-warnings],[build with compiler warnings as errors (default=no)]),,enable_warnings=no)
AC_ARG_ENABLE(profile,
	AC_HELP_STRING([--enable-profile],[allow profiling (default=no)]),,enable_profile=no)
AC_ARG_ENABLE(profilefn,
	AC_HELP_STRING([--enable-profilefn],[allow functioncheck profiling (default=no)]),,enable_profilefn=no)
AC_ARG_ENABLE(tests,
	AC_HELP_STRING([--enable-tests],[build test programs (default=no)]),,enable_tests=no)
AC_ARG_ENABLE(utilities,
	AC_HELP_STRING([--enable-utilities],[build utilities (default=yes)]),,enable_utilities=yes)
AC_ARG_ENABLE(examples,
	AC_HELP_STRING([--enable-examples],[build examples (default=no)]),,enable_examples=no)
AM_MAINTAINER_MODE

# ---------------------------------------------------------------------
# Debug and profile
# ---------------------------------------------------------------------

# these are first because the SET AM_C.*FLAGS, not just append
if test x$enable_debug = xyes; then
  GCJFLAGS="-g -O0"
  if test x$ac_cv_prog_cc_g = xyes; then
    AM_CFLAGS="-g3 -O0 -Wall -Werror"
  else
    AM_CFLAGS="-O0 -Wall -Werror"
  fi
  if test x$ac_cv_prog_cxx_g = xyes; then
    AM_CXXFLAGS="-g3 -O0 -Wall -Werror"
  else
    AM_CXXFLAGS="-O0 -Wall -Werror"
  fi
else
  AM_CFLAGS="-O3"
  AM_CXXFLAGS="-O3"
fi

# ---------------------------------------------------------------------
# Check libraries
# ---------------------------------------------------------------------
if test x$with_zlib  = xyes; then
	AC_CHECK_LIB(z, compress)
fi

#if test x$with_installmgr  = xftplib; then
#	AC_CHECK_LIB(ftplib, FtpGet)
#fi

# ---------------------------------------------------------------------
# Find CppUnit
# ---------------------------------------------------------------------
# Locate CppUnit (minimum version 1.8.0) for testing.  
AM_PATH_CPPUNIT(1.8.0)

# You can set up an automake conditional and use it to conditionally
# build cppunit-using test programs.
AM_CONDITIONAL(HAVE_CPPUNIT, test "$CPPUNIT_LIBS")


# ---------------------------------------------------------------------
# Find pkg-config
# ---------------------------------------------------------------------
use_pkgconfig=yes
AC_PATH_PROG(PKG_CONFIG, pkg-config, no)
if test x$PKG_CONFIG = xno ; then
  AC_MSG_WARN([*** pkg-config not found. See http://www.freedesktop.org/software/pkgconfig/])
  AC_MSG_WARN([not using pkg-config])
  use_pkgconfig=no
fi

if $PKG_CONFIG --atleast-pkgconfig-version 0.14 ; then
  :
else
  AC_MSG_WARN([*** pkg-config too old; version 0.14 or better required.])
  AC_MSG_WARN([not using pkg-config])
  use_pkgconfig=no
fi


# ---------------------------------------------------------------------
# Find ICU tools
# ---------------------------------------------------------------------
ICU_VER=
ICU_LIBS=
ICU_IOLIBS=
if test x$with_icu = xyes; then
	AC_PATH_PROG([PKGDATA], [pkgdata],[/usr/bin/pkgdata],[$PATH:/usr/sbin:.])
	AC_PATH_PROG([GENCCODE], [genccode], [/usr/bin/genccode], [$PATH:/usr/sbin:.])
	AC_PATH_PROG([GENCMN], [gencmn], [/usr/bin/gencmn], [$PATH:/usr/sbin:.])
	AC_PATH_PROG([GENRB], [genrb], [/usr/bin/genrb], [$PATH:/usr/sbin:.])
	
	AC_PATH_PROG(ICU_CONFIG, icu-config, no)
# The icu-config script was new in icu 2.2
	if test "$ICU_CONFIG" = "no" ; then
	   echo "*** The icu-config script installed by icu could not be found"
	   echo "*** continuing anyway and assuming 2.1 or earlier"
	   ICU_VER="2.1"
	   ICU_LIBS="-licui18n -licuuc -licudata"
	   ICU_IOLIBS="-lustdio"
	else
	   ICU_VER=`$ICU_CONFIG --version`
	   ICU_LIBS=`$ICU_CONFIG --ldflags`
	   #ICU_IOLIBS=`if test $(echo "$ICU_VER >= 3.0"|bc) -eq 1; then $ICU_CONFIG --ldflags-icuio; else $ICU_CONFIG --ldflags-ustdio; fi;`
	   ICU_IOLIBS=`$ICU_CONFIG --ldflags-icuio`
	fi
     AM_CXXFLAGS="$AM_CXXFLAGS -D_ICU_"
     AM_CFLAGS="$AM_CFLAGS -D_ICU_"
fi


AM_CXXFLAGS="$AM_CXXFLAGS -ftemplate-depth-25"
#  AC_DEFINE(DEBUG)
#else
#  AC_DEFINE(NDEBUG)
#fi

if test x$enable_warnings = xyes; then
  AM_CFLAGS="$AM_CFLAGS -Werror"
  AM_CXXFLAGS="$AM_CXXFLAGS -Werror"
fi

if test x$enable_profile = xyes; then
  AM_CFLAGS="$AM_CFLAGS -pg"
  AM_CXXFLAGS="$AM_CXXFLAGS -pg"
fi
if test x$enable_profilefn = xyes; then
  AM_CFLAGS="$AM_CFLAGS -g -finstrument-functions"
  AM_CXXFLAGS="$AM_CXXFLAGS -g -finstrument-functions"
  LIBS="$LIBS -g -finstrument-functions -lfnccheck"
fi

# ---------------------------------------------------------------------
# Check for curl for installmgr suport
# ---------------------------------------------------------------------

CURL_AM_CFLAGS=
CURL_LIBS=
#if test x$with_installmgr = xcurl; then
if test x$with_curl = xyes; then
    AC_PATH_PROG(CURL_CONFIG, curl-config, no)
    if test "$CURL_CONFIG" = "no" ; then
	echo "*** The curl-config script installed by curl could not be found"
	echo "*** compiling without libcurl support"
	with_curl=no
    else
	echo "curl found - remote install options available"
	CURL_AM_CFLAGS=`$CURL_CONFIG --cflags`
	CURL_LIBS=`$CURL_CONFIG --libs`
	AM_CXXFLAGS="$AM_CXXFLAGS -DCURLAVAILABLE"
	AM_CFLAGS="$AM_CFLAGS -DCURLAVAILABLE"
    fi
fi

# ---------------------------------------------------------------------
# Check for clucene for lucene searching support
# ---------------------------------------------------------------------

use_clucene=
if test -z "$CLUCENE_LIBS"; then
   echo "lucene searching options not available"
else
   echo "lucene found - lucene searching options available"
   AM_CXXFLAGS="$AM_CXXFLAGS $CLUCENE_CXXFLAGS -DUSELUCENE"
   AM_CFLAGS="$AM_CFLAGS -DUSELUCENE"
   LIBS="$LIBS $CLUCENE_LIBS"
   use_clucene="yes"
fi

AC_CHECK_FUNCS(vsnprintf, [have_vsnprintf="yes"])

# ---------------------------------------------------------------------
# Alter global conf directory only if not /etc
# ---------------------------------------------------------------------

if test "x$sysconfdir" = "x/etc"; then
  dir_confdef="no"
else
  dir_confdef="yes"
fi


# ---------------------------------------------------------------------
# Substitute variables into makefiles
# ---------------------------------------------------------------------
AC_SUBST(with_zlib)
AC_SUBST(with_icu)
AC_SUBST(with_conf)
AC_SUBST(dir_confdef)
AC_SUBST(CC)
AC_SUBST(CURL_AM_CFLAGS)
AC_SUBST(CURL_LIBS)
#AC_SUBST(LUCENE_LIBS)
AC_SUBST(ICU_LIBS)
AC_SUBST(ICU_IOLIBS)
AC_SUBST(ICU_VER)
AC_SUBST(XML_LIBS)
AC_SUBST(enable_debug)
AC_SUBST(enable_profile)
AC_SUBST(AM_CXXFLAGS)

AC_SUBST(target_cpu)
AC_SUBST(target_vendor)
AC_SUBST(target_os)

AC_SUBST(target_system)
AC_SUBST(target_mingw32)



# ---------------------------------------------------------------------
# Conditional variables
# ---------------------------------------------------------------------
AM_CONDITIONAL(HAVE_VSNPRINTF, test x$have_vsnprintf = xyes)
AM_CONDITIONAL(MINGW, test x$target_mingw32 = xyes)
AM_CONDITIONAL(ICU, test x$with_icu = xyes)
AM_CONDITIONAL(USELUCENE, test x$use_clucene = xyes)
AM_CONDITIONAL(ICUSWORD, test x$with_icu = xsword)
AM_CONDITIONAL(ZLIB, test x$with_zlib = xyes)
AM_CONDITIONAL(SHAREDLIB, test x$enable_shared = xyes)
AM_CONDITIONAL(INSTCONF, test x$with_conf = xyes)
AM_CONDITIONAL(INSTALLMGR, test x$with_curl = xyes)
#AM_CONDITIONAL(INTERNALFTPLIB, test x$with_installmgr = xinternal)
#AM_CONDITIONAL(WITHCURL, test x$with_installmgr = xcurl)
AM_CONDITIONAL(WITHCURL, test x$with_curl = xyes)
AM_CONDITIONAL(INTERNALFTPLIB, test x$with_curl != xyes)
#AM_CONDITIONAL(WITHFTPLIB, test x$with_installmgr = xftplib)
AM_CONDITIONAL(CONFDEF, test x$dir_confdef = xyes)
AM_CONDITIONAL(USE_PKGCONF, test x$use_pkgconfig = xyes)
#AM_CONDITIONAL(DEBUG, test x$with_debug = xyes)
#AM_CONDITIONAL(PROFILE, test x$with_profile = xyes)
AM_CONDITIONAL(BUILDTESTS, test x$enable_tests = xyes)
AM_CONDITIONAL(BUILDUTILS, test x$enable_utilities = xyes)
AM_CONDITIONAL(BUILDEXAMPLES, test x$enable_examples = xyes)

# ---------------------------------------------------------------------
# Final output
# ---------------------------------------------------------------------
AC_CONFIG_FILES(Makefile lib/Makefile tests/Makefile tests/cppunit/Makefile utilities/Makefile examples/Makefile examples/cmdline/Makefile utilities/diatheke/Makefile icu/Makefile sword.pc sword.spec)
AC_OUTPUT

