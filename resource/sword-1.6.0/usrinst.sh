#!/bin/sh
#******************************************************************************
# Convenience script specifying most common options to ./configure
#
# $Id: usrinst.sh 2362 2009-04-29 07:21:35Z scribe $
#
# Copyright 1998-2009 CrossWire Bible Society (http://www.crosswire.org)
#	CrossWire Bible Society
#	P. O. Box 2528
#	Tempe, AZ  85280-2528
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation version 2.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
#

OPTIONS="--prefix=/usr $OPTIONS"
OPTIONS="--libdir=/usr/lib64 $OPTIONS"
OPTIONS="--sysconfdir=/etc $OPTIONS"
OPTIONS="--without-conf $OPTIONS"
OPTIONS="--disable-shared $OPTIONS"
OPTIONS="--enable-debug $OPTIONS"
#OPTIONS="--enable-profile $OPTIONS"

OPTIONS="--with-icu $OPTIONS"
#OPTIONS="--without-clucene $OPTIONS"
#OPTIONS="--without-curl $OPTIONS"

OPTIONS="--enable-tests $OPTIONS"
#OPTIONS="--disable-utilities $OPTIONS"


# Use these for Windows DLL build
#LIBS="-no-undefined"
#OPTIONS="lt_cv_deplibs_check_method=pass_all $OPTIONS"

LIBS="$LIBS" CPPFLAGS="$CFLAGS $CPPFLAGS -DUSBINARY" ./configure $OPTIONS $*


echo ""
echo ""
echo ""
echo "Configured to NOT write a global /etc/sword.conf on 'make install'."
echo "If this is the first time you've installed sword, be sure to run"
echo "'make install_config' if you would like a basic configuration installed"
echo ""
echo "Next you might try something like: "
echo ""
echo "make"
echo "su"
echo "make install"
echo "(and optionally)"
echo "make install_config"
echo "make register"
echo ""
echo ""
echo ""
