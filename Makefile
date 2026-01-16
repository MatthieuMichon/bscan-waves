GIT_COMMIT_SHORT := $(shell git rev-parse --short=8 HEAD)
PART ?= xc7z020clg484-1
VVD_MODE ?= batch
VVD_FLAGS := -notrace -nojournal -mode $(VVD_MODE) -script ../vivado.tcl
VVD_TASK ?= all

SV_SOURCES := $(filter-out shell.sv, $(wildcard *.sv))

.PHONY: synth
synth:
	mkdir -p vivado_build
	cd vivado_build && vivado $(VVD_FLAGS) -tclargs PART=$(PART) GIT_COMMIT=$(GIT_COMMIT_SHORT) TASK=$(VVD_TASK) INPUT_FILE=$(INPUT_FILE)

.PHONY: clean
clean:
	$(RM) -r .Xil vivado_build
	$(RM) *.jou *.wdb *.pb
