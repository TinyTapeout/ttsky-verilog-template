# Simon Memory Game Chip

This project implements a simple Simon Says memory game in Verilog. The design uses a 16x8 RAM to store a sequence of values, a finite state machine to control the game, and comparison logic to check the player's input.

The goal of the project is to demonstrate a small digital system that combines memory, control logic, counters, and basic user interaction.

## How it works

The circuit has two main modes: programming mode and game mode.

In programming mode, the RAM is loaded with a sequence of values. The signal `prog_mode` enables this mode, `we` enables writing, `prog_addr` selects the memory position, and `prog_data` provides the value to be stored.

In game mode, the circuit reads the stored sequence from RAM and shows each value through the `led_out` output. The player must repeat the sequence using the `player_input` pins and confirm each input with the `enter` signal.

The finite state machine controls the game flow. It starts in an idle state, shows the stored sequence, waits for the player's input, checks the answer, and either increases the level or activates the error signal. If the player completes the full sequence, the `win` signal is activated.

The main outputs are:

- `led_out`: shows the current value of the sequence.
- `show_valid`: indicates that the value shown in `led_out` is valid.
- `correct`: indicates a correct player input.
- `error`: indicates an incorrect player input.
- `win`: indicates that the player completed the sequence.
- `level`: shows the current game level.

## How to test

The project is tested using the Cocotb testbench located in the `test` folder.

The test performs the following steps:

1. Resets the design.
2. Programs the RAM with a short sequence: `0, 1, 2, 3`.
3. Starts the game.
4. Sends the correct input for level 1.
5. Sends the correct inputs for level 2.
6. Sends an incorrect input at level 3.
7. Checks that the `error` output is activated after the wrong answer.

The test verifies that the memory can be programmed, that the game can start, that correct answers do not activate the error signal, and that an incorrect answer activates the error signal.

To run the test locally, use the Tiny Tapeout test workflow or run the test from the `test` directory with the provided Makefile.

## External hardware

This design can be tested using simple switches and LEDs.

Suggested usage:

- Use switches for `prog_mode`, `we`, `start`, `enter`, and `player_input`.
- Use LEDs to observe `led_out`, `show_valid`, `correct`, `error`, and `win`.
- Use the bidirectional pins to provide programming data and observe the current level.

## Inputs and outputs

### Inputs

- `ui_in[0]`: `prog_mode`
- `ui_in[1]`: `we`
- `ui_in[2]`: `start`
- `ui_in[3]`: `enter`
- `ui_in[5:4]`: `player_input`

### Outputs

- `uo_out[1:0]`: `led_out`
- `uo_out[2]`: `show_valid`
- `uo_out[3]`: `correct`
- `uo_out[4]`: `error`
- `uo_out[5]`: `win`
- `uo_out[7:6]`: state debug output

### Bidirectional pins

- `uio_in[3:0]`: programming address
- `uio_in[7:0]`: programming data
- `uio_out[4:0]`: current level
