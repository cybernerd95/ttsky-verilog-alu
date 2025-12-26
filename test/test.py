# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_alu(dut):
    dut._log.info("Starting ALU test")

    # Create clock (required by TinyTapeout framework)
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Reset sequence
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 1)

    # -------------------------
    # TEST 1: ADD (A=3, B=1)
    # opcode = 000
    # -------------------------
    A = 3
    B = 1
    opcode = 0b000

    ui_in = (opcode << 5) | (B << 4) | A
    dut.ui_in.value = ui_in

    await ClockCycles(dut.clk, 1)

    result = int(dut.uo_out.value) & 0xF
    carry  = (int(dut.uo_out.value) >> 4) & 0x1

    dut._log.info(f"ADD Result={result}, Carry={carry}")
    assert result == 4
    assert carry == 0

    # -------------------------
    # TEST 2: SUB (A=5, B=1)
    # opcode = 001
    # -------------------------
    A = 5
    B = 1
    opcode = 0b001

    ui_in = (opcode << 5) | (B << 4) | A
    dut.ui_in.value = ui_in

    await ClockCycles(dut.clk, 1)

    result = int(dut.uo_out.value) & 0xF
    dut._log.info(f"SUB Result={result}")
    assert result == 4

    # -------------------------
    # TEST 3: AND (A=6, B=1)
    # opcode = 010
    # -------------------------
    A = 6
    B = 1
    opcode = 0b010

    ui_in = (opcode << 5) | (B << 4) | A
    dut.ui_in.value = ui_in

    await ClockCycles(dut.clk, 1)

    result = int(dut.uo_out.value) & 0xF
    dut._log.info(f"AND Result={result}")
    assert result == (A & B)

    # -------------------------
    # TEST 4: ZERO FLAG CHECK
    # A=0, B=0, ADD
    # -------------------------
    A = 0
    B = 0
    opcode = 0b000

    ui_in = (opcode << 5) | (B << 4) | A
    dut.ui_in.value = ui_in

    await ClockCycles(dut.clk, 1)

    zero = (int(dut.uo_out.value) >> 5) & 0x1
    dut._log.info(f"ZERO flag={zero}")
    assert zero == 1

    dut._log.info("ALU test PASSED ✅")
