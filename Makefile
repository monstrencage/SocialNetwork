#*********************************************************************#
#                                                                     #
#                           Objective Caml                            #
#                                                                     #
#            Pierre Weis, projet Cristal, INRIA Rocquencourt          #
#                                                                     #
# Copyright 1998, 2004 Institut National de Recherche en Informatique #
# et en Automatique. Distributed only by permission.                  #
#                                                                     #
#*********************************************************************#

#                   Generic Makefile for Objective Caml Programs

# $Id: Exp $

############################ Documentation ######################
#
# To use this Makefile:
# -- You must fix the value of the variable SOURCES below.
# (The variable SOURCES is the list of your Caml source files.)
# -- You must create a file .depend, using
# $touch .depend
# (This file will contain the dependancies between your Caml modules,
#  automatically computed by this Makefile.)

# Usage of this Makefile:
# To incrementally recompile the system, type
#     make
# To recompute dependancies between modules, type
#     make depend
# To remove the executable and all the compiled files, type
#     make clean
# To compile using the native code compiler
#     make opt
#
##################################################################


##################################################################
#
# Advanced usage:
# ---------------

# If you want to fix the name of the executable, set the variable
# EXEC, for instance, if you want to obtain a program named my_prog:
# EXEC = my_prog

# If you need special libraries provided with the Caml system,
# (graphics, arbitrary precision numbers, regular expression on strings, ...),
# you must set the variable LIBS to the proper set of libraries. For
# instance, to use the graphics library set LIBS to $(WITHGRAPHICS):
# LIBS=$(WITHGRAPHICS)

# You may use any of the following predefined variable
# WITHGRAPHICS : provides the graphics library
# WITHUNIX : provides the Unix interface library
# WITHSTR : provides the regular expression string manipulation library
# WITHNUMS : provides the arbitrary precision arithmetic package
# WITHTHREADS : provides the byte-code threads library
# WITHDBM : provides the Data Base Manager library
#
#
########################## End of Documentation ####################



########################## User's variables #####################
#
# The Caml sources (including camlyacc and camllex source files)

SOURCES = $(SOURCESMLI) $(SOURCESML)

SOURCESMLI = date.mli social.mli tools.mli clique.mli socialNetwork.mli connect.mli fb.mli json.mli auth.mli getFb.mli facebook.mli

SOURCESML = date.ml tools.ml clique.ml socialNetwork.ml connect.ml fb.ml json.ml auth.ml getFb.ml getFbPublic.ml facebook.ml

# The executable file to generate (default a.out under Unix)

EXEC = social


########################## Advanced user's variables #####################
#
# The Caml compilers.
# You may fix here the path to access the Caml compiler on your machine
CAMLC = ocamlfind ocamlc
CAMLOPT = ocamlfind ocamlopt
CAMLTOP = ocamlfind ocamlmktop 
CAMLDEP = ocamldep
CAMLLEX = ocamllex
CAMLYACC = ocamlyacc
CAMLDOC = ocamlfind ocamldoc

# The list of Caml libraries needed by the program
# For instance:
# LIBS=$(WITHGRAPHICS) $(WITHUNIX) $(WITHSTR) $(WITHNUMS) $(WITHTHREADS)\
# $(WITHDBM)

LIB=$(REPO) $(WITHUNIX) $(WITHSTR) $(WITHJSON) $(WITHHTTP)
#$(WITHCURL) $(WITHJSON)

# Should be set to -custom if you use any of the libraries above
# or if any C code have to be linked with your program
# (irrelevant for ocamlopt)

CUSTOM=
# CUSTOM=-custom

REPO = -package netclient,netsys,netstring,equeue,easy-format,biniou,yojson

# Default setting of the WITH* variables. Should be changed if your
# local libraries are not found by the compiler.
WITHGRAPHICS =graphics.cma -cclib -lgraphics -cclib -L/usr/X11R6/lib -cclib -lX11

WITHUNIX =unix.cma -cclib -lunix

WITHSTR =str.cma

WITHNUMS =nums.cma -cclib -lnums

WITHTHREADS =threads.cma -cclib -lthreads

WITHDBM =dbm.cma -cclib -lmldbm -cclib -lndbm

WITHHTTP = bigarray.cma netsys_oothr.cma netsys.cma netstring.cma equeue.cma netclient.cma

WITHJSON = easy_format.cma biniou.cma

################ End of user's variables #####################


##############################################################
################ This part should be generic
################ Nothing to set up or fix here
##############################################################

all: depend $(EXEC)

opt : $(EXEC).opt

lib : $(EXEC).cma

top : $(EXEC)_top

#configure : $(LIBPERSO)

#ocamlc -custom other options graphics.cma other files -cclib -lgraphics -cclib -lX11
#ocamlc -thread -custom other options threads.cma other files -cclib -lthreads
#ocamlc -custom other options str.cma other files -cclib -lstr
#ocamlc -custom other options nums.cma other files -cclib -lnums
#ocamlc -custom other options unix.cma other files -cclib -lunix
#ocamlc -custom other options dbm.cma other files -cclib -lmldbm -cclib -lndbm

SOURCES1 = $(SOURCES:.mly=.ml)
SOURCES2 = $(SOURCES1:.mll=.ml)
OBJS = $(SOURCES2:.ml=.cmo)
OPTOBJS = $(SOURCES2:.ml=.cmx)
LIBS = $(LIB) yojson.cmo
LIBSOPT = $(LIB:.cma=.cmxa) yojson.cmx

$(EXEC): $(OBJS)
	$(CAMLC) $(CUSTOM) -o $(EXEC) $(LIBS) $(OBJS)

$(EXEC).opt: $(OPTOBJS)
	$(CAMLOPT) -o $(EXEC).opt $(LIBSOPT) $(OPTOBJS)

$(EXEC).cma: $(OBJS)
	$(CAMLC) $(CUSTOM) -linkall -a -o $(EXEC).cma $(LIBS) $(OBJS)

$(EXEC)_top: $(EXEC).cma
	$(CAMLTOP) $(LIBS) $(EXEC).cma -o $(EXEC)_top

.SUFFIXES:
.SUFFIXES: .ml .mli .cmo .cmi .cmx .mll .mly

.ml.cmo:
	$(CAMLC) -c $(LIBS) $<

.mli.cmi:
	$(CAMLC) -c $(LIBS) $<

.ml.cmx:
	$(CAMLOPT) -c $(LIBSOPT) $<

.mll.cmo:
	$(CAMLLEX) $<
	$(CAMLC) -c $*.ml

.mll.cmx:
	$(CAMLLEX) $<
	$(CAMLOPT) -c $*.ml

.mly.cmo:
	$(CAMLYACC) $<
	$(CAMLC) -c $*.mli
	$(CAMLC) -c $*.ml

.mly.cmx:
	$(CAMLYACC) $<
	$(CAMLOPT) -c $*.mli
	$(CAMLOPT) -c $*.ml

.mly.cmi:
	$(CAMLYACC) $<
	$(CAMLC) -c $*.mli

.mll.ml:
	$(CAMLLEX) $<

.mly.ml:
	$(CAMLYACC) $<

clean:
	rm -f *.cm[iox] *~ .*~ *.o #*#
	rm -f $(EXEC)
	rm -f $(EXEC).opt
	rm -f $(EXEC).cma

.depend: $(SOURCES2)
	$(CAMLDEP) *.mli *.ml > .depend

depend: $(SOURCES2)
	$(CAMLDEP) *.mli *.ml > .depend

doctex: $(OBJS)
	$(CAMLDOC) $(REPO) $(SOURCESMLI) -noheader -notrailer -sepfiles -latex -o src.tex
	mv Doc/Tex/$(EXEC).tex .
	pdflatex $(EXEC).tex
	mv $(EXEC).pdf Doc
	mv *.{tex,sty} Doc/Tex
	rm *.{log,out,aux}

dochtml:$(OBJS)
	$(CAMLDOC) $(REPO) $(SOURCESMLI) -short-functors -html -charset utf8 -o social
	mv *.html Doc/Html
	mv style.css Doc/Html

ident: 
	rm auth.ml
	echo "Nom d'utilisateur ?"
	read USER
	echo -e "let user = \"\" ;;\n" >> auth.ml
	echo "Jeton d'accès ?"
	read access_token
	echo -e "let access_token = \"$access_token\" ;;\n" >> auth.ml


include .depend
