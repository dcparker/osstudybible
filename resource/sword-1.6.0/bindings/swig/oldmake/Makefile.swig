# Generated automatically from Makefile.in by configure.
# ------------------------------------------------------------
# SWIG Examples Makefile
#
# This file is used by the examples to build modules.  Assuming
# you ran configure, this file will probably work.  However,
# it's not perfect so you might need to do some hand tweaking.
#
# Other notes:
#
# 1.   Take a look at the prefixes below.   Since SWIG works with
#      multiple target languages, you may need to find out where
#      certain packages have been installed.   Set the prefixes
#      accordingly.
#
# 2.   To use this makefile, simply set SRCS, INTERFACE, INCLUDE, LIBS,
#      TARGET, and do a
#           $(MAKE) -f Makefile.template.in SRCS='$(SRCS)' \
#           INCLUDE='$(INCLUDE) LIBS='$(LIBS)' INTERFACE='$(INTERFACE)' \
#           TARGET='$(TARGET)' method
#
#      'method' describes what is being built.
#---------------------------------------------------------------

TARGET     =
CC         = gcc
CXX        = c++
CFLAGS     =
prefix     = /usr/local
exec_prefix= ${prefix}
SRCS       =
INCLUDE    =
LIBS       =
INTERFACE  =
SWIGOPT    =
SWIG       = swig
RUNTIMEDIR = $(exec_prefix)/lib

LIBM       = -lieee -lm
LIBC       = 
LIBCRYPT   = -lcrypt
SYSLIBS    = $(LIBM) $(LIBC) $(LIBCRYPT)

libtool_comp = $(TOP)/../Tools/libtool --mode compile
libtool_link = $(TOP)/../Tools/libtool --mode link

# X11 options

XLIB       = -L/usr/X11R6/lib -lX11
XINCLUDE   = -I/usr/X11R6/include

IWRAP      = $(INTERFACE:.i=_wrap.i)
ISRCS      = $(IWRAP:.i=.c)
ICXXSRCS   = $(IWRAP:.i=.cxx)
IOBJS      = $(IWRAP:.i=.o)

##################################################################
# Dynamic loading for C++
# If you are going to be building dynamic loadable modules in C++,
# you may need to edit this line appropriately.
#
# This line works for g++, but I'm not sure what it might be
# for other C++ compilers
##################################################################

CPP_DLLIBS = #-L/usr/local/lib/gcc-lib/sparc-sun-solaris2.5.1/2.7.2 \
             -L/usr/local/lib -lg++ -lstdc++ -lgcc

# Solaris workshop 5.0 
# CPP_DLLIBS = -L/opt/SUNWspro/lib -lCrun

# Symbols used for using shared libraries
SO=		.so
LDSHARED=	gcc -shared
CCSHARED=	-fpic
CXXSHARED=      gcc -shared

# This is used for building shared libraries with a number of C++
# compilers.   If it doesn't work,  comment it out.
CXXSHARED=      c++ -shared 

OBJS      = $(SRCS:.c=.o) $(CXXSRCS:.cxx=.o)

##################################################################
#####                       Tcl/Tk                          ######
##################################################################

# Set these to your local copy of Tcl/Tk.

TCL_INCLUDE = 
TCL_LIB     = 
TCL_OPTS    = -ldl 
TK_OPTS     = -ltk -ltcl -ldl 

# Extra Tcl specific dynamic linking options
TCL_DLNK   = 

# -----------------------------------------------------------
# Build a new version of the tclsh shell
# -----------------------------------------------------------


tclsh: $(SRCS)
	$(SWIG) -tcl8 $(SWIGOPT) $(TCL_SWIGOPTS) -ltclsh.i $(INTERFACE)
	$(CC) $(CFLAGS) $(SRCS) $(ISRCS) $(INCLUDE) $(TCL_INCLUDE) \
	$(TCL_LIB)  $(TCL_OPTS) $(LIBS) $(SYSLIBS) -o $(TARGET)

tclsh_cpp: $(SRCS)
	$(SWIG) -tcl8 -c++ $(SWIGOPT) $(TCL_SWIGOPTS) -ltclsh.i $(INTERFACE)
	$(CXX) $(CFLAGS) $(SRCS) $(CXXSRCS) $(ICXXSRCS) $(INCLUDE) $(TCL_INCLUDE) \
	$(TCL_LIB) $(TCL_OPTS) $(LIBS) $(SYSLIBS) -o $(TARGET)

# -----------------------------------------------------------
# Build a new copy of wish
# -----------------------------------------------------------

wish: $(SRCS)
	$(SWIG) -tcl8 $(SWIGOPT) $(TCL_SWIGOPTS) -lwish.i $(INTERFACE)
	$(CC) $(CFLAGS) $(SRCS) $(ISRCS) $(INCLUDE) $(TCL_INCLUDE) \
	$(XINCLUDE) $(TCL_LIB) $(TK_OPTS) $(XLIB) $(LIBS) $(SYSLIBS) -o $(TARGET)


wish_cpp: $(SRCS)
	$(SWIG) -tcl8 -c++ $(SWIGOPT) $(TCL_SWIGOPTS) -lwish.i $(INTERFACE)
	$(CXX) $(CFLAGS) $(SRCS) $(CXXSRCS) $(ICXXSRCS) $(INCLUDE) $(TCL_INCLUDE) \
	$(XINCLUDE) $(TCL_LIB) $(TK_OPTS) $(XLIB) $(LIBS) $(SYSLIBS) -o $(TARGET)

# -----------------------------------------------------------
# Build a Tcl dynamic loadable module (you might need to tweak this)
# -----------------------------------------------------------

tcl:  $(SRCS)
	$(SWIG) -tcl8 $(SWIGOPT) $(TCL_SWIGOPTS) $(INTERFACE)
	$(CC) -c $(CCSHARED) $(CFLAGS) $(SRCS) $(ISRCS) $(INCLUDE) $(TCL_INCLUDE)
	$(LDSHARED) $(OBJS) $(IOBJS) $(TCL_DLNK) $(LIBS) -o $(TARGET)$(SO)

# -----------------------------------------------------------
# Build a Tcl7.5 dynamic loadable module for C++
# -----------------------------------------------------------

tcl_cpp: $(SRCS)
	$(SWIG) -tcl8 -c++ $(SWIGOPT) $(TCL_SWIGOPTS) $(INTERFACE)
	$(CXX) -c $(CCSHARED) $(CFLAGS) $(SRCS) $(CXXSRCS) $(ICXXSRCS) $(INCLUDE) $(TCL_INCLUDE)
	$(CXXSHARED) $(OBJS) $(IOBJS) $(TCL_DLNK) $(LIBS) $(CPP_DLLIBS) -o $(TARGET)$(SO)

# -----------------------------------------------------------
# Build a Tcl7.5 dynamic loadable module, linked against SWIG runtime lib
# -----------------------------------------------------------

TCL_RUNTIME=-L$(RUNTIMEDIR) -lswigtcl8

tcl_multi:  $(SRCS)
	$(SWIG) -c -tcl8 $(SWIGOPT) $(TCL_SWIGOPTS) $(INTERFACE)
	$(CC) -c $(CCSHARED) $(CFLAGS) $(SRCS) $(ISRCS) $(INCLUDE) $(TCL_INCLUDE)
	$(LDSHARED) $(OBJS) $(IOBJS) $(TCL_RUNTIME) $(TCL_DLNK) $(LIBS) -o $(TARGET)$(SO)

tcl_multi_cpp: $(SRCS)
	$(SWIG) -c -tcl8 -c++ $(SWIGOPT) $(TCL_SWIGOPTS) $(INTERFACE)
	$(CXX) -c $(CCSHARED) $(CFLAGS) $(SRCS) $(CXXSRCS) $(ICXXSRCS) $(INCLUDE) $(TCL_INCLUDE)
	$(CXXSHARED) $(OBJS) $(IOBJS) $(TCL_RUNTIME) $(TCL_DLNK) $(LIBS) $(CPP_DLLIBS) -o $(TARGET)$(SO)

##################################################################
#####                       PERL 5                          ######
##################################################################

# You need to set this variable to the Perl5 directory containing the
# files "perl.h", "EXTERN.h" and "XSUB.h".   With Perl5.003, it's
# usually something like /usr/local/lib/perl5/arch-osname/5.003/CORE.

PERL5_INCLUDE= /usr/lib/perl5/5.6.1/i386-linux/CORE

# Extra Perl specific dynamic linking options
PERL5_DLNK   = 

# ----------------------------------------------------------------
# Build a Perl5 dynamically loadable module (C)
# ----------------------------------------------------------------

perl5: $(SRCS)
	$(SWIG) -perl5 $(SWIGOPT) $(INTERFACE)
	$(CC) -c -Dbool=char $(CCSHARED) $(CFLAGS) -DSWIG $(SRCS) $(ISRCS) $(INCLUDE) -I$(PERL5_INCLUDE)
	$(LDSHARED) $(OBJS) $(IOBJS) $(PERL5_DLNK) $(LIBS) -o $(TARGET)$(SO)

# ----------------------------------------------------------------
# Build a Perl5 dynamically loadable module (C++)
# ----------------------------------------------------------------

perl5_cpp: $(SRCS)
	$(SWIG) -perl5 -c++ $(SWIGOPT) $(INTERFACE)
	$(CXX) -c $(CCSHARED) $(CFLAGS) -DSWIG -Dexplicit= $(SRCS) $(CXXSRCS) $(ICXXSRCS) $(INCLUDE) -I$(PERL5_INCLUDE)
	$(CXXSHARED) $(OBJS) $(IOBJS) $(PERL5_DLNK) $(LIBS) $(CPP_DLLIBS) -o $(TARGET)$(SO)

# ----------------------------------------------------------------
# Build a Perl5 dynamically loadable module, linked against SWIG runtime lib
# ----------------------------------------------------------------

PERL5_RUNTIME=-L$(RUNTIMEDIR) -lswigpl

perl5_multi: $(SRCS)
	$(SWIG) -c -perl5 $(SWIGOPT) $(INTERFACE)
	$(CC) -c -DSWIG -Dbool=char $(CCSHARED) $(CFLAGS) $(SRCS) $(ISRCS) $(INCLUDE) -I$(PERL5_INCLUDE)
	$(LDSHARED) $(OBJS) $(IOBJS) $(PERL5_RUNTIME) $(PERL5_DLNK) $(LIBS) -o $(TARGET)$(SO)

perl5_multi_cpp: $(SRCS)
	$(SWIG) -c -perl5 -c++ $(SWIGOPT) $(INTERFACE)
	$(CXX) -c $(CCSHARED) $(CFLAGS) -DSWIG -Dexplicit= $(SRCS) $(CXXSRCS) $(ICXXSRCS) $(INCLUDE) -I$(PERL5_INCLUDE)
	$(CXXSHARED) $(OBJS) $(IOBJS) $(PERL5_RUNTIME) $(PERL5_DLNK) $(LIBS) $(CPP_DLLIBS) -o $(TARGET)$(SO)

# ----------------------------------------------------------------
# Build a module from existing XS C source code.   (ie. from xsubpp).
# ----------------------------------------------------------------
perl5_xs: $(SRCS)
	$(CC) -c $(CCSHARED) $(CFLAGS) $(SRCS) $(INCLUDE) -I$(PERL5_INCLUDE)
	$(LDSHARED) $(OBJS) $(LIBS) -o $(TARGET)$(SO)

# ----------------------------------------------------------------
# Build a statically linked Perl5 executable
# ----------------------------------------------------------------

PERL5_LIB    = -L$(PERL5_INCLUDE) -lperl.so -ldl  $(SYSLIBS)

perl5_static: $(SRCS)
	$(SWIG) -perl5 -static -lperlmain.i $(SWIGOPT) $(INTERFACE)
	$(CC) $(CFLAGS) -Dbool=char $(SRCS) $(ISRCS) $(INCLUDE) -I$(PERL5_INCLUDE) $(PERL5_LIB) $(LIBS) -o $(TARGET)

perl5_static_cpp: $(SRCS)
	$(SWIG) -perl5 -c++ -static -lperlmain.i $(SWIGOPT) $(INTERFACE)
	$(CXX) $(CFLAGS) -Dexplicit= $(SRCS) $(CXXSRCS) $(ICXXSRCS) $(INCLUDE) -I$(PERL5_INCLUDE) $(PERL5_LIB) $(LIBS) -o $(TARGET)


##################################################################
#####                       PYTHON                          ######
##################################################################

# Make sure these locate your Python installation
PYTHON_INCLUDE= -DHAVE_CONFIG_H 
PYTHON_LIB    = 

# Extra Python specific dynamic linking options
PYTHON_DLNK   = 

# ----------------------------------------------------------------
# Build a C dynamically loadable module
# ----------------------------------------------------------------

python: $(SRCS)
	$(SWIG) -python $(SWIGOPT) $(INTERFACE)
	$(CC) -c $(CCSHARED) $(CFLAGS) $(ISRCS) $(SRCS) $(INCLUDE) $(PYTHON_INCLUDE)
	$(LDSHARED) $(OBJS) $(IOBJS) $(PYTHON_DLNK) $(LIBS) -o $(TARGET)module$(SO)

# -----------------------------------------------------------------
# Build a C++ dynamically loadable module
# -----------------------------------------------------------------

python_cpp: $(SRCS)
	$(SWIG) -c++ -python $(SWIGOPT) $(INTERFACE)
	$(CXX) -c $(CCSHARED) $(CFLAGS) $(ICXXSRCS) $(SRCS) $(CXXSRCS) $(INCLUDE) $(PYTHON_INCLUDE)
	$(CXXSHARED) $(OBJS) $(IOBJS) $(PYTHON_DLNK) $(LIBS) $(CPP_DLLIBS) -o $(TARGET)module$(SO)

# -----------------------------------------------------------------
# Build a dynamically loadable module, linked against SWIG Runtime lib
# -----------------------------------------------------------------

PYTHON_RUNTIME=-L$(RUNTIMEDIR) -lswigpy

python_multi: $(SRCS)
	$(SWIG) -c -python $(SWIGOPT) $(INTERFACE)
	$(CC) -c $(CCSHARED) $(CFLAGS) $(ISRCS) $(SRCS) $(INCLUDE) $(PYTHON_INCLUDE)
	$(LDSHARED) $(OBJS) $(IOBJS) $(PYTHON_RUNTIME) $(PYTHON_DLNK) $(LIBS) -o $(TARGET)module$(SO)

python_multi_cpp: $(SRCS)
	$(SWIG) -c -c++ -python $(SWIGOPT) $(INTERFACE)
	$(CXX) -c $(CCSHARED) $(CFLAGS) $(ICXXSRCS) $(SRCS) $(CXXSRCS) $(INCLUDE) $(PYTHON_INCLUDE)
	$(CXXSHARED) $(OBJS) $(IOBJS) $(PYTHON_RUNTIME) $(PYTHON_DLNK) $(LIBS) $(CPP_DLLIBS) -o $(TARGET)module$(SO)


# -----------------------------------------------------------------
# Build statically linked Python interpreter
#
# These should only be used in conjunction with the %include embed.i
# library file
# -----------------------------------------------------------------

#TKINTER = -L/usr/X11R6.3/lib -L/usr/local/compat/lib -ltk4.0 -ltcl7.4 -lX11
TKINTER =
PYTHON_LIBOPTS = -lpython2.2 -ldl  $(TKINTER) $(SYSLIBS)

python_static: $(SRCS)
	$(SWIG) -python -lembed.i $(SWIGOPT) $(INTERFACE)
	$(CC) $(CFLAGS) -Xlinker -export-dynamic $(ISRCS) $(SRCS) $(INCLUDE) \
	$(PYTHON_INCLUDE) $(LIBS) -L$(PYTHON_LIB) $(PYTHON_LIBOPTS) -o $(TARGET)

python_static_cpp: $(SRCS)
	$(SWIG) -c++ -python -lembed.i $(SWIGOPT) $(INTERFACE)
	$(CXX) $(CFLAGS) $(ICXXSRCS) $(SRCS) $(CXXSRCS) $(INCLUDE) \
	$(PYTHON_INCLUDE) $(LIBS)  -L$(PYTHON_LIB) $(PYTHON_LIBOPTS) -o $(TARGET)

# -----------------------------------------------------------------
# Cleaning the python examples
# -----------------------------------------------------------------

python_clean:
	rm -f *_wrap* *.o *~ *$(SO) mypython *.pyc .~* core

##################################################################
#####                       GUILE                           ######
##################################################################

# Make sure these locate your Guile installation
GUILE_INCLUDE = 
GUILE_LIB     = 

# ----------------------------------------------------------------
# Build a C dynamically loadable module
# ----------------------------------------------------------------

guile: $(SRCS)
	$(SWIG) -guile -Linkage ltdlmod $(SWIGOPT) $(INTERFACE)
	$(CC) -c $(CCSHARED) $(CFLAGS) $(INCLUDE) $(GUILE_INCLUDE) $(ISRCS) $(SRCS)
	$(LDSHARED) $(OBJS) $(IOBJS) $(LIBS) -o lib$(TARGET)$(SO)

# -----------------------------------------------------------------
# Build a C++ dynamically loadable module
# -----------------------------------------------------------------

guile_cpp: $(SRCS)
	$(SWIG) -c++ -guile -Linkage ltdlmod $(SWIGOPT) $(INTERFACE)
	$(CXX) -c $(CCSHARED) $(CFLAGS) $(INCLUDE) $(GUILE_INCLUDE) $(ICXXSRCS) $(SRCS) $(CXXSRCS)
	$(CXXSHARED) $(OBJS) $(IOBJS) $(LIBS) $(CPP_DLLIBS) -o lib$(TARGET)$(SO)

# -----------------------------------------------------------------
# Build a dynamically loadable module with passive linkage
# -----------------------------------------------------------------

guile_passive: $(SRCS)
	$(SWIG) -guile -Linkage passive $(SWIGOPT) $(INTERFACE)
	$(CC) -c $(CCSHARED) $(CFLAGS) $(INCLUDE) $(GUILE_INCLUDE) $(ISRCS) $(SRCS)
	$(LDSHARED) $(OBJS) $(IOBJS) $(LIBS) -o lib$(TARGET)$(SO)

guile_passive_cpp: $(SRCS)
	$(SWIG) -c++ -guile -Linkage passive $(SWIGOPT) $(INTERFACE)
	$(CXX) -c $(CCSHARED) $(CFLAGS) $(INCLUDE) $(GUILE_INCLUDE) $(ICXXSRCS) $(SRCS) $(CXXSRCS)
	$(CXXSHARED) $(OBJS) $(IOBJS) $(LIBS) $(CPP_DLLIBS) -o lib$(TARGET)$(SO)

# -----------------------------------------------------------------
# Build a dynamically loadable module with passive linkage, 
# linked against SWIG runtime lib
# -----------------------------------------------------------------

GUILE_RUNTIME=-L$(RUNTIMEDIR) -lswigguile

guile_passive_multi: $(SRCS)
	$(SWIG) -c -guile -Linkage passive $(SWIGOPT) $(INTERFACE)
	$(CC) -c $(CCSHARED) $(CFLAGS) $(INCLUDE) $(GUILE_INCLUDE) $(ISRCS) $(SRCS)
	$(LDSHARED) $(OBJS) $(IOBJS) $(GUILE_RUNTIME) $(LIBS) -o lib$(TARGET)$(SO)

guile_passive_multi_cpp: $(SRCS)
	$(SWIG) -c -c++ -guile -Linkage passive $(SWIGOPT) $(INTERFACE)
	$(CXX) -c $(CCSHARED) $(CFLAGS) $(INCLUDE) $(GUILE_INCLUDE) $(ICXXSRCS) $(SRCS) $(CXXSRCS)
	$(CXXSHARED) $(OBJS) $(IOBJS) $(GUILE_RUNTIME) $(LIBS) $(CPP_DLLIBS) -o lib$(TARGET)$(SO)

# -----------------------------------------------------------------
# Build statically linked Guile interpreter
# -----------------------------------------------------------------

GUILE_LIBOPTS =  -ldl  $(SYSLIBS)

guile_static: $(SRCS)
	$(SWIG) -guile -lguilemain.i -Linkage ltdlmod $(SWIGOPT) $(INTERFACE)
	$(CC) $(CFLAGS) $(ISRCS) $(SRCS) $(INCLUDE) \
	  -DSWIGINIT="SCM scm_init_$(TARGET)_module(void); scm_init_$(TARGET)_module();" \
	  $(GUILE_INCLUDE) $(LIBS) -L$(GUILE_LIB) $(GUILE_LIBOPTS) -o $(TARGET)-guile

guile_static_cpp: $(SRCS)
	$(SWIG) -c++ -guile -lguilemain.i -Linkage ltdlmod $(SWIGOPT) $(INTERFACE)
	$(CXX) $(CFLAGS) $(ICXXSRCS) $(SRCS) $(CXXSRCS) $(INCLUDE) \
	  -DSWIGINIT="SCM scm_init_$(TARGET)_module(void); scm_init_$(TARGET)_module();" \
	  $(GUILE_INCLUDE) $(LIBS) -L$(GUILE_LIB) $(GUILE_LIBOPTS) -o $(TARGET)-guile

guile_simple: $(SRCS)
	$(SWIG) -guile -lguilemain.i -Linkage simple $(SWIGOPT) $(INTERFACE)
	$(CC) $(CFLAGS) $(ISRCS) $(SRCS) $(INCLUDE) \
	  $(GUILE_INCLUDE) $(LIBS) -L$(GUILE_LIB) $(GUILE_LIBOPTS) -o $(TARGET)-guile

guile_simple_cpp: $(SRCS)
	$(SWIG) -c++ -guile -lguilemain.i -Linkage simple $(SWIGOPT) $(INTERFACE)
	$(CXX) $(CFLAGS) $(ICXXSRCS) $(SRCS) $(CXXSRCS) $(INCLUDE) \
	  $(GUILE_INCLUDE) $(LIBS) -L$(GUILE_LIB) $(GUILE_LIBOPTS) -o $(TARGET)-guile

##################################################################
#####                       JAVA                            ######
##################################################################

# You need to set this variable to the java directories containing the
# files "jni.h" and "md.h"
# usually something like /usr/java/include and /usr/java/include/<arch-osname>.
JAVA_INCLUDE= 

# Extra Java specific dynamic linking options
JAVA_DLNK  = 
JAVALIBPREFIX = lib

# ----------------------------------------------------------------
# Build a java dynamically loadable module (C)
# ----------------------------------------------------------------

java: $(SRCS)
	$(SWIG) -java $(SWIGOPT) $(INTERFACE)
	$(CC) -c $(CCSHARED) $(CFLAGS) $(SRCS) $(ISRCS) $(INCLUDE) $(JAVA_INCLUDE)
	$(LDSHARED) $(OBJS) $(IOBJS) $(JAVA_DLNK) $(LIBS) -o $(JAVALIBPREFIX)$(TARGET)$(SO)

# ----------------------------------------------------------------
# Build a java dynamically loadable module (C++)
# ----------------------------------------------------------------

java_cpp: $(SRCS)
	$(SWIG) -java -c++ $(SWIGOPT) $(INTERFACE)
	$(CXX) -c $(CCSHARED) $(CFLAGS) $(SRCS) $(CXXSRCS) $(ICXXSRCS) $(INCLUDE) $(JAVA_INCLUDE)
	$(CXXSHARED) $(OBJS) $(IOBJS) $(JAVA_DLNK) $(LIBS) $(CPP_DLLIBS) -o $(JAVALIBPREFIX)$(TARGET)$(SO)

# ----------------------------------------------------------------
# Build a java dynamically loadable module
# ----------------------------------------------------------------

java_multi: $(SRCS)
	$(SWIG) -java $(SWIGOPT) $(INTERFACE)
	$(CC) -c $(CCSHARED) $(CFLAGS) $(SRCS) $(ISRCS) $(INCLUDE) $(JAVA_INCLUDE)
	$(LDSHARED) $(OBJS) $(IOBJS) $(JAVA_DLNK) $(LIBS) -o $(JAVALIBPREFIX)$(TARGET)$(SO)

java_multi_cpp: $(SRCS)
	$(SWIG) -java -c++ $(SWIGOPT) $(INTERFACE)
	$(CXX) -c $(CCSHARED) $(CFLAGS) $(SRCS) $(CXXSRCS) $(ICXXSRCS) $(INCLUDE) $(JAVA_INCLUDE)
	$(CXXSHARED) $(OBJS) $(IOBJS) $(JAVA_DLNK) $(LIBS) $(CPP_DLLIBS) -o $(JAVALIBPREFIX)$(TARGET)$(SO)

# -----------------------------------------------------------------
# Cleaning the java examples
# -----------------------------------------------------------------

java_clean:
	mv main.java main.java.tmp
	rm -f *_wrap* *.o core *~ *$(SO) *.class *.java 
	mv main.java.tmp main.java

##################################################################
#####                       MZSCHEME                        ######
##################################################################

MZC = test -n "" && 

# ----------------------------------------------------------------
# Build a C/C++ dynamically loadable module
# ----------------------------------------------------------------

mzscheme: $(SRCS)
	$(SWIG) -mzscheme $(SWIGOPT) $(INTERFACE)
	$(MZC) ++ccf "$(INCLUDE)" --cc $(ISRCS) $(SRCS)
	$(MZC) --ld $(TARGET)$(SO) $(OBJS) $(IOBJS)

mzscheme_cpp: $(SRCS)
	$(SWIG) -mzscheme -c++ $(SWIGOPT) $(INTERFACE)
	$(MZC) ++ccf "$(INCLUDE)" --cc $(ICXXSRCS) $(SRCS) $(CXXSRCS)
	$(MZC) --ld $(TARGET)$(SO) $(OBJS) $(IOBJS) $(CPP_DLLIBS) 

# ----------------------------------------------------------------
# Build a dynamically loadable module, linked against SWIG runtime
# ----------------------------------------------------------------

MZSCHEME_RUNTIME=-L$(RUNTIMEDIR) -lswigmz

mzscheme_multi: $(SRCS)
	$(SWIG) -c -mzscheme $(SWIGOPT) $(INTERFACE)
	$(MZC) ++ccf "$(INCLUDE)" --cc $(ISRCS) $(SRCS)
	$(MZC) --ld $(TARGET)$(SO) $(OBJS) $(IOBJS) $(MZSCHEME_RUNTIME)

mzscheme_multi_cpp: $(SRCS)
	$(SWIG) -c -mzscheme -c++ $(SWIGOPT) $(INTERFACE)
	$(MZC) ++ccf "$(INCLUDE)" --cc $(ICXXSRCS) $(SRCS) $(CXXSRCS)
	$(MZC) --ld $(TARGET)$(SO) $(OBJS) $(IOBJS) $(MZSCHEME_RUNTIME) $(CPP_DLLIBS) 

##################################################################
#####                       RUBY                            ######
##################################################################

# Make sure these locate your Ruby installation
RUBY_CFLAGS=  -DHAVE_CONFIG_H
RUBY_INCLUDE= -I/usr/local/lib/ruby/1.4/arch
RUBY_LIB     = /usr/local/lib/ruby/1.4/arch
RUBY_DLNK = 

# ----------------------------------------------------------------
# Build a C dynamically loadable module
# ----------------------------------------------------------------

ruby: $(SRCS)
	$(SWIG) -ruby $(SWIGOPT) $(INTERFACE)
	$(CC) -c $(CCSHARED) $(CFLAGS) $(RUBY_CFLAGS) $(ISRCS) $(SRCS) $(INCLUDE) $(RUBY_INCLUDE)
	$(LDSHARED) $(OBJS) $(IOBJS) $(RUBY_DLNK) $(LIBS) -o $(TARGET)$(SO)

# -----------------------------------------------------------------
# Build a C++ dynamically loadable module
# -----------------------------------------------------------------

ruby_cpp: $(SRCS)
	$(SWIG) -c++ -ruby $(SWIGOPT) $(INTERFACE)
	$(CXX) -c $(CCSHARED) $(CFLAGS) $(RUBY_CFLAGS) $(ICXXSRCS) $(SRCS) $(CXXSRCS) $(INCLUDE) $(RUBY_INCLUDE)
	$(CXXSHARED) $(OBJS) $(IOBJS) $(RUBY_DLNK) $(LIBS) $(CPP_DLLIBS) -o $(TARGET)$(SO)

# -----------------------------------------------------------------
# Build a dynamically loadable module, linked against SWIG runtime lib
# -----------------------------------------------------------------

RUBY_RUNTIME=-L$(RUNTIMEDIR) -lswigrb

ruby_multi: $(SRCS)
	$(SWIG) -c -ruby $(SWIGOPT) $(INTERFACE)
	$(CC) -c $(CCSHARED) $(CFLAGS) $(RUBY_CFLAGS) $(ISRCS) $(SRCS) $(INCLUDE) $(RUBY_INCLUDE)
	$(LDSHARED) $(OBJS) $(IOBJS) $(RUBY_RUNTIME) $(RUBY_DLNK) $(LIBS) -o $(TARGET)$(SO)

ruby_multi_cpp: $(SRCS)
	$(SWIG) -c -c++ -ruby $(SWIGOPT) $(INTERFACE)
	$(CXX) -c $(CCSHARED) $(CFLAGS) $(RUBY_CFLAGS) $(ICXXSRCS) $(SRCS) $(CXXSRCS) $(INCLUDE) $(RUBY_INCLUDE)
	$(CXXSHARED) $(OBJS) $(IOBJS) $(RUBY_RUNTIME) $(RUBY_DLNK) $(LIBS) $(CPP_DLLIBS) -o $(TARGET)$(SO)

# -----------------------------------------------------------------
# Build statically linked Ruby interpreter
#
# These should only be used in conjunction with the %include embed.i
# library file
# -----------------------------------------------------------------

RUBY_LIBOPTS = -lruby -lm -ldl  $(SYSLIBS)

ruby_static: $(SRCS)
	$(SWIG) -ruby -lembed.i $(SWIGOPT) $(INTERFACE)
	$(CC) $(CFLAGS) $(RUBY_CFLAGS) -Xlinker -export-dynamic $(ISRCS) $(SRCS) $(INCLUDE) \
	$(RUBY_INCLUDE) $(LIBS) -L$(RUBY_LIB) $(RUBY_LIBOPTS) -o $(TARGET)

ruby_cpp_static: $(SRCS)
	$(SWIG) -c++ -ruby -lembed.i $(SWIGOPT) $(INTERFACE)
	$(CXX) $(CFLAGS) $(RUBY_CFLAGS) $(ICXXSRCS) $(SRCS) $(CXXSRCS) $(INCLUDE) \
	$(RUBY_INCLUDE) $(LIBS)  -L$(RUBY_LIB) $(RUBY_LIBOPTS) -o $(TARGET)


# -------------------------------------------------------------------
# Build a PHP4 dynamically loadable module (C)
# -------------------------------------------------------------------

PHP4_INCLUDE = 

php4: $(SRCS)
	$(SWIG) -php4 $(SWIGOPT) $(INTERFACE)
	$(CC) -c $(CCSHARED) $(CFLAGS) $(SRCS) $(ISRCS) $(INCLUDE) $(PHP4_INCLUDE)
	$(LDSHARED) $(OBJS) $(IOBJS) $(LIBS) -o $(TARGET)$(SO)

# --------------------------------------------------------------------
# Build a PHP4 dynamically loadable module (C++)
# --------------------------------------------------------------------

php4_cpp: $(SRCS)
	$(SWIG) -php4 -c++ $(SWIGOPT) $(INTERFACE)
	$(CXX) -c $(CCSHARED) $(CFLAGS) $(SRCS) $(CXXSRCS) $(ICXXSRCS) $(INCLUDE) $(PHP4_INCLUDE)
	$(CXXSHARED) $(OBJS) $(IOBJS) $(LIBS) $(CPP_DLLIBS) -o $(TARGET)$(SO)

# ---------------------------------------------------------------------
# Build a dynamically loadable module, linked against SWIG Runtime lib
# ---------------------------------------------------------------------

PHP4_RUNTIME=-L$(RUNTIMEDIR) -lswigphp4

php4_multi: $(SRCS)
	$(SWIG) -c -php4 $(SWIGOPT) $(INTERFACE)
	$(CC) -c $(CCSHARED) $(CFLAGS) $(ISRCS) $(SRCS) $(INCLUDE) $(PHP4_INCLUDE)
	$(LDSHARED) $(OBJS) $(IOBJS) $(PHP4_RUNTIME) $(PHP4_DLNK) $(LIBS) -o $(TARGET)module$(SO)

php4_multi_cpp: $(SRCS)
	$(SWIG) -c -c++ -php4 $(SWIGOPT) $(INTERFACE)
	$(CXX) -c $(CCSHARED) $(CFLAGS) $(ICXXSRCS) $(SRCS) $(CXXSRCS) $(INCLUDE) $(PHP4_INCLUDE)
	$(CXXSHARED) $(OBJS) $(IOBJS) $(PHP4_RUNTIME) $(PHP4_DLNK) $(LIBS) $(CPP_DLLIBS) -o $(TARGET)module$(SO)
