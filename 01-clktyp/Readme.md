# 01-clktyp: VHDL Clock Generator

This repository contains the code for a clock generator in VHDL. The clock generator has the following specifications:

## Entity

The entity `clktyp` is defined with a single port `clk` of type `std_logic` which serves as the output clock signal.

## Architecture

The architecture `dataflow` implements the functionality of the clock generator. The clock signal starts with a `'1'` value for 2 ns and then alternates between `'1'` and `'0'` with a 5 ns period. This creates a clock frequency of 200 MHz, with a 50% duty cycle. The clock signal is generated using a process that continually loops and alternates the value of `clk`.

## Usage

To use this code, include the entity and architecture in your project and connect the `clk` port to the desired location. 
