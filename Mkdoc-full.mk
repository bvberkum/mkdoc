# Non-recursive makefile

# Id: mkdoc/0.0.2-test+20150804-0404 Mkdoc-full.mk


# Expand to root Makefile. CURDIR and MAKEFILE_LIST are GNU Make internals
# The incomprehensible expression is to retrieve the last value of MAKEFILE_LIST.
location             = $(CURDIR)/$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))

# Global list of all makefiles
MK                  := $(location)

# Set level to warning and above
VERBOSE             ?= 4
ifneq ($(V), )
VERBOSE             := $(V)
endif

DIR                 := $(CURDIR)
MK_DIR              := $(shell dirname $$(realpath $(location)))
PREFIX              ?= $(MK_DIR)/usr

-include                \
                       $(CURDIR)/.make.env

export MK_SHARE     ?= $(PREFIX)/share/mkdoc/
#MK_CONF             := /etc/mkdoc/ $(HOME)/.mkdoc/
export MK_BUILD     := /var/mkdoc/

export PROJECT      ?= mkdoc
export DOMAIN       ?= mpe
export VERSION      := 0.0.2-test+20150804-0404# mkdoc

export MKDOC_VERSION := 0.0.2-test+20150804-0404# mkdoc

# FIXME: rewrite to MK_BUILD
export BUILD        ?= .build/

# Start keeping present directory
DIR                 := .
#DIR                 := $(CURDIR)

#      ------------ -- 

d                   := $(DIR)
MK_$d               := Mkdoc-full

#      ------------ -- 

ifeq ($(MAKECMDGOALS),info)
$(info Heads up, running 'make info V=$(VERBOSE)', use lower values for less info. )
endif


include                $(MK_SHARE)Core/Main.mk


ifeq ($(MAKECMDGOALS),info)
$(info $(shell $(ll) info info "OK loaded $(MK_SHARE)Core/Main.mk"))
endif

$(call chat,header,mkdoc,Core script loaded)

# Check wether this filename (target of the Makefile symlink) corresponds to MK_$d
ifneq ($(shell [ -L "$(MK)" ] && basename $$(readlink $(MK)) .mk),$(MK_$d))
$(call chat,warn,mkdoc,Do not link Makefile but rather $(MK_$d))
endif

#      ------------ -- 

# log-line script is now available for pretty print, do some chatter now:
$(call chat,info,$(MK_$d),Chattiness set to $(VERBOSE))
$(call chat,debug,$(MK_$d),DIR=$(DIR))
$(call chat,debug,$(MK_$d),BUILD=$(BUILD))
$(call chat,debug,$(MK_$d),MK_SHARE=$(MK_SHARE))
$(call chat,debug,$(MK_$d),MK_BUILD=$(MK_BUILD))

#      ------------ -- 

$(call chat,debug,mkdoc,Reading package main include files)

include                \
                       $(MK_SHARE)markdown/Main.mk \
                       $(MK_SHARE)docutils/Main.mk \
                       $(MK_SHARE)bookmarklet/Main.mk \
                       $(MK_SHARE)vc/Main.mk \
                       $(MK_SHARE)tidy/Main.mk \
                       $(MK_SHARE)haxe/Main.mk \
                       $(MK_SHARE)plotutils/Main.mk \
                       $(MK_SHARE)graphviz/Main.mk \
                       $(MK_SHARE)python/Main.mk

$(call chat,debug,mkdoc,Done loading packages main file)
$(call chat,debug,mkdoc)

#      ------------ -- 

$(call chat,header,mkdoc,Reading default rules from packages)

#
include                \
                       $(MK_SHARE)bookmarklet/Rules.default.mk \
                       $(MK_SHARE)graphviz/Rules.default.mk \
                       $(MK_SHARE)rubber/Rules.default.mk \
                       $(MK_SHARE)markdown/Rules.default.mk \
                       $(MK_SHARE)docutils/Rules.default.mk \
                       $(MK_SHARE)haxe/Rules.default.mk \
                       $(MK_SHARE)plotutils/Rules.default.mk \
                       $(MK_SHARE)python/Rules.default.mk
#					   $(MK_SHARE)Core/Rules.archive.mk

$(call chat,debug,mkdoc,Done loading packages rules files)
$(call chat,debug,mkdoc)

#      ------------ -- 

$(call chat,header,mkdoc,Reading local rules)

# Include specific rules and set SRC, DEP, TRGT and CLN variables.
# Looks at
# - Rules.mk
# - Rules.shared.mk
# - Rules.<PROJECT>.mk
# - Rules.<HOST>.mk
#
include                $(call rules,$(DIR)/) 

#      ------------ -- 

$(call chat,header,mkdoc,Reading standard rules)

# Now set some standard targets
#
include                $(MK_SHARE)Core/Rules.default.mk

#      ------------ -- 

$(call chat,debug,mkdoc)
$(call chat,OK,mkdoc,starting 'make $(MAKECMDGOALS)')
$(call chat,debug,mkdoc)

# vim:ft=make:
