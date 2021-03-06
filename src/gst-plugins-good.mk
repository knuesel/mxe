# This file is part of MXE.
# See index.html for further information.

PKG             := gst-plugins-good
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.4
$(PKG)_CHECKSUM := b2c1691bd13d4567788dcb3af49a99401f057112
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://gstreamer.freedesktop.org/src/$(PKG)/$($(PKG)_FILE)
# $(PKG)_DEPS     := gcc glib libxml2 gstreamer gst-plugins-base liboil libshout cairo flac gtk2 jpeg libpng speex taglib wavpack
$(PKG)_DEPS     := gcc glib libxml2 gstreamer gst-plugins-base liboil cairo jpeg libpng

$(PKG)_UPDATE = $(subst gstreamer/refs,gst-plugins-good/refs,$(gstreamer_UPDATE))

define $(PKG)_BUILD
    find '$(1)' -name Makefile.in \
        -exec $(SED) -i 's,glib-mkenums,$(PREFIX)/$(TARGET)/bin/glib-mkenums,g'       {} \; \
        -exec $(SED) -i 's,glib-genmarshal,$(PREFIX)/$(TARGET)/bin/glib-genmarshal,g' {} \;
    # The value for WAVE_FORMAT_DOLBY_AC3_SPDIF comes from vlc and mplayer:
    #   http://www.videolan.org/developers/vlc/doc/doxygen/html/vlc__codecs_8h-source.html
    #   http://lists.mplayerhq.hu/pipermail/mplayer-cvslog/2004-August/019283.html
    cd '$(1)' && ./configure \
	$(MXE_CONFIGURE_OPTS) \
        --disable-debug \
        --disable-examples \
        --disable-aalib \
        --disable-x \
        --mandir='$(1)/sink' \
        --docdir='$(1)/sink' \
        --with-html-dir='$(1)/sink'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install CFLAGS='-DWAVE_FORMAT_DOLBY_AC3_SPDIF=0x0092'
endef
