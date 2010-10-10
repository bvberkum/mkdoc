### MkDocs Core Makefile
# :Date: 2010-10-04
# :Author: B. van Berkum  <dev@dotmpe.com>
#
# This is a non-recursive makefile,
# see Rules.mk for each directory.
#
# To use MkDoc, include this file in your projects main Makefile first.
# Finally, include some standard rules or set these yourself. See:
# $(MK_SHARE)Core/Rules.default.mk

VPATH              := . / 
SHELL              := /bin/bash

.SUFFIXES:
.SUFFIXES:         .rst .js .xhtml .mk .tex .pdf .list

MK_ROOT            := ~/project/mkdoc/
MK_SHARE           := $(MK_ROOT)usr/share/mkdoc/

HOST               := $(shell hostname)
ifndef ROOT
ROOT               := $(shell pwd)
endif


SRC                :=
DMK                :=
MK                 :=
DEP                :=
TRGT               :=
STRGT              := 
CLN                :=
TEST               :=
INSTALL            :=

PENDING            :=
MISSING            :=  
OFFLINE            :=


ll                  = $(MK_SHARE)Core/log.sh
ee                  = /bin/echo -e
mk-target-dir       = if test ! -d $(@D); then mkdir -p $(@D); fi
sed-trim            = sed 's/^ *//g' | sed 's/ *$$//g'
kwds-file           = if test -f "$(KWDS_./$(<D))"; then \
						  echo $(KWDS_./$(<D)); \
						else if test -f "$(KWDS_./$(@D))"; then \
						  echo $(KWDS_./$(@D)); \
						else if test -f "$(KWDS_$(<D))"; then \
						  echo $(KWDS_$(<D)); \
						else if test -f "$(KWDS_$(@D))"; then \
						  echo $(KWDS_$(@D)); fi; fi; fi; fi;
kwds-file           = if test -f "$(KWDS_$(DIR))"; then \
						  echo $(KWDS_$(DIR)); fi;

define mk-target
	$(mk-target-dir)
	if test ! -f "$@"; then touch $@; fi
endef

define reset-target
	$(mk-target-dir)
	if test -f "$@"; then rm $@; fi
	touch $@
endef

define mk-include
	$(reset-target)
	for f in $(MK_FILES); do \
		echo "ifeq (\$$(realpath $$f 2>/dev/null),)" >> $@; \
		echo "MISSING += $$f" >> $@; \
		echo "else" >> $@; \
		echo "DIR := `dirname $$f`" >> $@; \
		echo "include $$f" >> $@; \
		echo "endif" >> $@; \
	done;
endef

log                 = $(ll) "$1" "$2" "$3" "$4"
count               = $(shell if test -n "$1"; then\
					    echo $1|wc -w; else echo 0; fi;)
contains            = for Z in "$1"; do if test "$$Z" = "$2"; then \
					    echo "$$Z"; fi; done;
expand-path         = $(shell echo $1)
is-path             = $(shell if test -e "$1";then echo $1; fi;)
is-file             = $(shell if test -f "$1";then echo $1; fi;)
is-dir              = $(shell if test -d "$1";then echo $1; fi;)
filter-dir          = $(shell for D in $1; do if test -d "$$D"; then \
                        echo $$D; fi; done)
filter-file         = $(shell for F in $1; do if test -f "$$F"; then \
                        echo $$F; fi; done)
rules               = $(shell for D in $1; do \
                        if test -f "$$(echo $$D/Rules.mk)"; then \
                          echo $$D/Rules.mk; else \
                        if test -f "$$(echo $$D/.Rules.mk)"; then \
						  echo $$D/.Rules.mk; else \
                        if test -f "$$(echo $$D/Rules.$(HOST).mk)"; then \
                          echo $$D/Rules.$(HOST).mk; else \
                        if test -f "$$(echo $$D/.Rules.$(HOST).mk)"; then \
						  echo $$D/.Rules.$(HOST).mk; else \
						  echo $$D/Rules.mk; fi; fi; fi; fi; done )
sub-rules           = $(foreach V,$1,$(call rules,"$V/*"))
complement          = $(shell \
					    for X in $1; do \
					      if test -z "$$(for Z in $2; do if test "$$Z" = "$$X"; \
					        then echo $$X; fi; done)"; then \
					        echo "$$X"; fi; done; )
    
### Canned
define ante-proc-tags
	@# Process all source files and expand tag references.
	@$(ll) file_target "$<.src" "Replacing tags for" "$<"
	@cp $< $<.src;
	@chmod +rw $<.src
	@KWDF="$(shell $(kwds-file))";\
	 cat $$KWDF | grep -v '^$$' | grep -v '^#'| \
		while read l; do \
			IFS="	";set -- $$l;\
			tag=`echo "$$1" | awk '{gsub("[~/:.]", "\\\\\\\&");print}'`; \
			value=`echo "$$2" | awk '{gsub("[~/:.]", "\\\\\\\&");print}'`; \
			sed -e "s/@$$tag/$$value/g" $<.src > $<.tmp; \
			mv $<.tmp $<.src; \
		done; 
endef

define post-proc-tags
	@# Process all target files and expand tag references.
	@$(ll) file_target "$@" "Replacing tags in" "$@"
	@cp $@ $@.tmp;
	@chmod +rw $@.tmp
	@KWDF="$(shell $(kwds-file))";\
	 cat $$KWDF | grep -v '^$$' | grep -v '^#'| \
		while read l; do \
			IFS="	";set -- $$l;\
			tag=`echo "$$1" | awk '{gsub("[~/:]", "\\\\\\\&");print}'`; \
			value=`echo "$$2" | awk '{gsub("[~/:]", "\\\\\\\&");print}'`; \
			sed -e "s/@$$tag/$$value/g" $@.tmp > $@; \
			mv $@ $@.tmp; \
		done; \
		mv $@.tmp $@;
#			#line=$($(ee) $$l | tr '\t' '\n');
#
endef


default:               

