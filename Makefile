CHAINPREFIX := /opt/mipsel-linux-uclibc
CROSS_COMPILE := $(CHAINPREFIX)/usr/bin/mipsel-linux-

CC = $(CROSS_COMPILE)gcc
STRIP = $(CROSS_COMPILE)strip
CXX = $(CROSS_COMPILE)g++

SYSROOT     := $(shell $(CC) --print-sysroot)
SDL_CFLAGS  := $(shell $(SYSROOT)/usr/bin/sdl-config --cflags)
SDL_LIBS    := $(shell $(SYSROOT)/usr/bin/sdl-config --libs)

CFLAGS     := --std=c89 --pedantic -Wall $(SDL_CFLAGS) -DHOME_DIR -DNETWORKING
LDFLAGS    := $(SDL_LIBS) -lm

SRCDIRS      = . backend

TARGET       ?= shifty.elf
MACHINE      ?= $(shell $(CC) -dumpmachine)
# DESTDIR      ?= $(SYSROOT)
OUTDIR       ?= shifty
# output/$(MACHINE)

ifdef DEBUG
#  CFLAGS += -DDEBUG -ggdb3 -Wall
  CFLAGS += -ggdb3 -Wextra
  OUTDIR := $(OUTDIR)-debug
  TARGET := $(TARGET)-debug
else
  CFLAGS += -O2
endif

# BINDIR       := $(OUTDIR)/bin
BINDIR       := $(OUTDIR)
SRCDIR       := src
OBJDIR       := $(OUTDIR)/obj
#IGNORED_FILES:= $(SRCDIR)/
SRC          := $(filter-out $(IGNORED_FILES),$(foreach dir,$(SRCDIRS),$(sort $(wildcard $(addprefix $(SRCDIR)/,$(dir))/*.c))))
OBJ          := $(patsubst $(SRCDIR)/%.c,$(OBJDIR)/%.o,$(SRC))

.PHONY: all clean

all:	$(TARGET)

$(TARGET): $(OBJ) | $(BINDIR)
	$(CC) $(CFLAGS) $^ $(LDFLAGS) -o $(BINDIR)/$@
ifndef DEBUG
	$(STRIP) $(BINDIR)/$@
endif

$(OBJ): $(OBJDIR)/%.o: $(SRCDIR)/%.c | $(OBJDIR)
	mkdir -p $(@D)
	$(CC) -c $(CFLAGS) $< -o $@ -I include

$(BINDIR) $(OBJDIR):
	mkdir -p $@

ipk: $(TARGET)
	@rm -rf /tmp/.shifty-ipk/ && mkdir -p /tmp/.shifty-ipk/root/home/retrofw/games/shifty /tmp/.shifty-ipk/root/home/retrofw/apps/gmenu2x/sections/games
	@cp -r shifty/shifty.elf shifty/shifty.png shifty/data /tmp/.shifty-ipk/root/home/retrofw/games/shifty
	@cp shifty/shifty.lnk /tmp/.shifty-ipk/root/home/retrofw/apps/gmenu2x/sections/games
	@sed "s/^Version:.*/Version: $$(date +%Y%m%d)/" shifty/control > /tmp/.shifty-ipk/control
	@cp shifty/conffiles /tmp/.shifty-ipk/
	@tar --owner=0 --group=0 -czvf /tmp/.shifty-ipk/control.tar.gz -C /tmp/.shifty-ipk/ control conffiles
	@tar --owner=0 --group=0 -czvf /tmp/.shifty-ipk/data.tar.gz -C /tmp/.shifty-ipk/root/ .
	@echo 2.0 > /tmp/.shifty-ipk/debian-binary
	@ar r shifty/shifty.ipk /tmp/.shifty-ipk/control.tar.gz /tmp/.shifty-ipk/data.tar.gz /tmp/.shifty-ipk/debian-binary

clean:
	rm -Rf $(OUTDIR)
