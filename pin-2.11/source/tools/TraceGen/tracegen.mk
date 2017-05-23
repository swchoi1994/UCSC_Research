SHELL = /bin/sh
.PHONY: all depend clean
.SUFFIXES: .cc .o

default: all

TARGET = ia32e
TOOLS_DIR = ..
include $(TOOLS_DIR)/makefile.gnu.config

LIBS = -L/usr/local/lib -lsnappy
INCS = -I/usr/local/include

ifeq ($(TAG),dbg)
  DBG = -Wall
  OPT = -ggdb -g -O0
else
  DBG = -DNDEBUG
  OPT = -O3
endif

CXXFLAGS_COMMON = -Wno-unknown-pragmas $(DBG) $(OPT) 
#CXX = g++ -m32
#CC  = gcc -m32
CXX = g++
CC  = gcc
PINFLAGS = 

#SRCS_COMMON  = MTS.cc PTSComponent.cc PTSCache.cc PTSXbar.cc PTSDirectory.cc \
#               PTSMemoryController.cc PTSTLB.cc

ifneq ($(EXTENGINELIB),)
  SRCS = $(SRCS_COMMON)
  CXXFLAGS = $(CXXFLAGS_COMMON) -DEXTENGINE
else
  SRCS = $(SRCS_COMMON)
  CXXFLAGS = $(CXXFLAGS_COMMON)
endif

OBJS = $(patsubst %.cc,obj_$(TAG)/%.o,$(SRCS))
MYPIN_CXXFLAGS = $(subst -I../,-I$(TOOLS_DIR)/,$(PIN_CXXFLAGS))
MYPIN_LDFLAGS  = $(subst -L../,-L$(TOOLS_DIR)/,$(PIN_LDFLAGS))

all: obj_$(TAG)/tracegen
	cp -f obj_$(TAG)/tracegen tracegen

obj_$(TAG)/tracegen : $(OBJS) obj_$(TAG)/tracegen.o 
	$(CXX) $(OBJS) $@.o $(MYPIN_LDFLAGS) -o $@ $(PIN_LIBS) $(LIBS) $(EXTENGINELIB)

obj_$(TAG)/%.o : %.cc
	$(CXX) -c $(CXXFLAGS) $(MYPIN_CXXFLAGS) $(INCS) -o $@ $<

clean:
	-rm -f *.o tracegen pin.log

