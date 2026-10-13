# Run inside the dev shell: nix develop
#
#   make test [T=name]      unit tests + programs (all, or only T)
#   make unit [T=name]      unit tests (tb/**/tb_<name>.v)
#   make prog [T=name]      programs in tests/programs
#   make trace T=name       program T with the pipeline state cycle by cycle
#   make wave T=name        program T dumping a VCD for GTKWave
#   make lint               Verilator --lint-only on the processor
#   make paper              build the paper (latex/main.tex -> build/paper/main.pdf)
#
# SIM=verilator switches the simulator (default: icarus), e.g. make test SIM=verilator

SIM ?= icarus
RUN := lua scripts/test.lua
SOURCES := $(shell find src -name '*.v')
LINT_FLAGS := -Wall -Wno-DECLFILENAME -Wno-UNUSEDSIGNAL -Wno-UNUSEDPARAM -Wno-PINCONNECTEMPTY

.PHONY: test unit prog trace wave lint paper clean

test:
	$(RUN) all --sim=$(SIM) $(T)

unit:
	$(RUN) unit --sim=$(SIM) $(T)

prog:
	$(RUN) prog --sim=$(SIM) $(T)

trace:
	$(RUN) prog --sim=$(SIM) --trace $(T)

wave:
	$(RUN) prog --sim=$(SIM) --wave $(T)

lint:
	verilator --lint-only $(LINT_FLAGS) -Isrc/core --top-module rv32e_cpu $(SOURCES)

paper:
	cd latex && latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=../build/paper main.tex

clean:
	rm -rf build
