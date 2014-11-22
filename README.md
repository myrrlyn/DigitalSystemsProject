DigitalSystemsProject
=====================

Digital Systems final project -- Verilog to govern an Altera FPGA board

## Project Overview

This project is intended to create a default-execution program with possible
user input that performs a small light show with the onboard LEDs of an Altera
FPGA board. It will use a clock, finite state machine, and list of pre-defined
states to create a pseudo-random display that can switch between light patterns
at random-appearing intervals and order. It will be able to instruct the green
LEDs, red LEDs, and seven-segment displays either separately or in unison.

### Milestone Goals

* Create at least two distinct light states

* Implement the basic state machine to select and execute from possible routines

* Implement a variable-length clock to serve as master control for the state
    machine

* Implement user input to select the next routine displayed

### Features

* Selection of defined states for light display

* Variable duration time of display state

* Possible user selection of display
