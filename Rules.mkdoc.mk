# Id: mkdoc/0.0.1 Rules.mkdoc.mk


# Rules available to other projects?
include $(DIR)/Rules.mkdoc.shared.mk


# Get all special targets in a row
empty :=
space := $(empty) $(empty)
usage::
	@echo 'usage:'
	@echo '# make [$(subst $(space),|,$(STRGT))]'


# Track embedded task notes
TODO.list: $(SRC)
	-grep -srI 'TODO\|FIXME\|XXX' $^ | grep -v 'grep..srI..TODO' | grep -v 'TODO.list' > $@


# Updates files with embedded project/version lines
STRGT += sync-file-ids
sync-file-ids:
	./bin/cli-version.sh update


# Install: simply copy files to MK_SHARE 
MK_SHARE            := /usr/local/share/mkdoc/

INSTALL             += $(MK_SHARE)

$(MK_SHARE):
	sudo cp -vr usr/share/mkdoc/ $@


# Provide uninstall too

STRGT += uninstall
uninstall::
	test -n "$(MK_SHARE)"
	test -e "$(MK_SHARE)"
	P=$$(dirname $(MK_SHARE))/$$(basename $(MK_SHARE)); \
	[ "$P" != "/" ] && sudo rm -rfv $$P

