# This file is part of MXE.
# See index.html for further information.

PKG             := gst-plugins-bad
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.4
$(PKG)_CHECKSUM := 7263f9877faffe6249bec7c68de4993f66678cfc
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://gstreamer.freedesktop.org/src/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc glib libxml2 gstreamer gst-plugins-base liboil

$(PKG)_UPDATE = $(subst gstreamer/refs,gst-plugins-bad/refs,$(gstreamer_UPDATE))

define $(PKG)_BUILD
    find '$(1)' -name Makefile.in \
        -exec $(SED) -i 's,glib-mkenums,$(PREFIX)/$(TARGET)/bin/glib-mkenums,g'       {} \; \
        -exec $(SED) -i 's,glib-genmarshal,$(PREFIX)/$(TARGET)/bin/glib-genmarshal,g' {} \;
    cd '$(1)' && ./configure \
	$(MXE_CONFIGURE_OPTS) \
        --disable-debug \
        --disable-examples \
        --disable-x \
	--disable-winks \
        --mandir='$(1)/sink' \
        --docdir='$(1)/sink' \
        --with-html-dir='$(1)/sink'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
