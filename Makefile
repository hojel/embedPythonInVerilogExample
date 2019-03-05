CDS_INST_DIR := $(shell xmroot)
PYTHON_ROOT  = $(HOME)/venv/python
CC = gcc
INCLUDE  = -I$(CDS_INST_DIR)/tools/include
INCLUDE  += -I$(PYTHON_ROOT)/include/python2.7
OPT      = -Wall -fpic -shared
CFLAGS   = $(OPT) $(INCLUDE)
LIBS     = -lc -lssl -lpthread -lm -ldl -lutil
LIBS     += -L$(PYTHON_ROOT)/lib -lpython2.7

SHLIB = libdpi.so
CSRCS = pythonEmbedded.c
VSRCS = pythonEmbedded.sv

run:: $(SHLIB)
	xrun -sv $(VSRCS) -sv_lib $(SHLIB)

sim:: xcelium.d $(SHLIB)
	xmsim -messages worklib.top

xcelium.d: $(VSRCS)
	xmvlog -messages -sv $(VSRCS)
	xmelab -messages -access +RWC worklib.top
	touch $@

$(SHLIB): $(CSRCS)
	$(CC) $(CFLAGS) -o $@ $^ $(LIBS)

clean::
	$(RM) $(SHLIB)
	$(RM) -r xcelium.d
	$(RM) xm*.log
