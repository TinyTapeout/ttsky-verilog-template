# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

TOPLEVEL_LANG = verilog

VERILOG_SOURCES = $(PWD)/tb.v \
                  $(PWD)/../src/tt_um_memory_game.v \
                  $(PWD)/../src/memory_game.v \
                  $(PWD)/../src/ram.v

TOPLEVEL = tb
MODULE = test

include $(shell cocotb-config --makefiles)/Makefile.sim
