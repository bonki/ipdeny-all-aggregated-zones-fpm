# Copyright (C) 2016 Adrian Frühwirth
# License: WTFPL

PACKAGE_NAME = ipdeny-all-aggregated-zones
NAME = ipdeny
VERSION = $(shell date +%Y%m%d)
URL = http://ipdeny.com/ipblocks/data/aggregated/
TEMP_DIR = temp

TARGET ?= $(shell which rpm dpkg | head -n 1 | sed -e 's%^.*/%%' -e 's%dpkg%deb%g')
ifeq ($(TARGET),deb)
	OUTFILE = $(PACKAGE_NAME)_$(VERSION)_all.deb
endif
ifeq ($(TARGET),rpm)
	OUTFILE = $(PACKAGE_NAME)-$(VERSION).noarch.rpm
endif

###############################################################################

.PHONY: all clean temp-clean install install-clean depinstall deb-install deb-depinstall rpm-install rpm-depinstall

all: $(OUTFILE)

clean: temp-clean $(TARGET)-clean

temp-clean:
	@rm -rf '$(TEMP_DIR)'

install: $(TARGET)-install

install-clean: $(TARGET)-install clean

depinstall: $(TARGET)-depinstall

temp:
	@rm -f '$(OUTFILE)'
	@mkdir -p '$(TEMP_DIR)'
# fix permissions of TEMP_DIR so fpm will do the right thing
# (this directory will essentially become /usr/share/ipdeny and should be 0755)
	@chmod 0755 '$(TEMP_DIR)'
	@wget -r -e robots=off -l1 -A '*.zone' --no-directories -P '$(TEMP_DIR)' -N -q --show-progress --no-parent '$(URL)'

$(TARGET)-clean:
	@rm -f *.$(TARGET)

$(OUTFILE): temp
	@fpm -s dir -t '$(TARGET)' -n '$(PACKAGE_NAME)' -v '$(VERSION)' -a all --prefix '/usr/share/$(NAME)' -C '$(TEMP_DIR)'

###############################################################################

deb-install: $(OUTFILE)
	@sudo dpkg -i '$(OUTFILE)'

deb-depinstall:
	@sudo apt-get install ruby
	@sudo gem install fpm

rpm-install: $(OUTFILE)
	@sudo yum install '$(OUTFILE)'

rpm-depinstall:
	@sudo yum install ruby
	@sudo gem install fpm

