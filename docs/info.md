# How it works

A VGA clock display implemented in Verilog for Tiny Tapeout.

The design renders a circular analog clock face at 640×480 resolution. The background color changes based on the current hour:

| Period  | Time Range    | Background Color |
|---------|---------------|------------------|
| Night   | 00:00 ~ 05:59 | Dark navy        |
| Morning | 06:00 ~ 11:59 | Bright sky blue  |
| Daytime | 12:00 ~ 17:59 | Light sky blue   |
| Evening | 18:00 ~ 23:59 | Sunset orange    |

A sun appears during morning and daytime, and a moon appears during evening and night. Both move across the sky in an arc according to the current hour. The clock face has hour and minute markers, and three hands for hours, minutes, and seconds.

# How to test

Connect a VGA monitor to the output pins. Power on the design and the clock will start running from 00:00:00.

To adjust the time, connect a Gamepad PMOD to the input pins. Press Start to enter time adjustment mode. Use Up/Down to increment or decrement the selected field. Press Select to cycle between hour, minute, and second adjustment. Press Start again to exit adjustment mode.

# External hardware

- VGA monitor
- Gamepad PMOD
