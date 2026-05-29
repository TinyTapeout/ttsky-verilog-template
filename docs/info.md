# How it works

This project is inspired by an [analog clock for the console](https://kmandla.wordpress.com/2009/12/26/an-analog-clock-for-the-console/) from Linux.

A VGA clock display implemented in Verilog for the Tiny Tapeout demoscene competition.

The design renders a circular analog clock face at 640×480 resolution. The background color changes based on the current hour:

| Period  | Time Range    | Background Color |
| ------- | ------------- | ---------------- |
| Night   | 00:00 ~ 05:59 | Dark navy        |
| Morning | 06:00 ~ 11:59 | Bright sky blue  |
| Daytime | 12:00 ~ 17:59 | Light sky blue   |
| Evening | 18:00 ~ 23:59 | Sunset orange    |

A sun appears during morning and daytime, and a moon appears during evening and night. Both move across the sky in an arc according to the current hour. The clock face has hour and minute markers, and three hands for hours, minutes, and seconds.

![Clock overview](https://github.com/user-attachments/assets/d2815694-c233-44a9-bb5f-411908e2a7ae)

Night

![Night](https://github.com/user-attachments/assets/61dc92d9-8d26-423e-9745-2993ff123806)

Morning

![Morning](https://github.com/user-attachments/assets/e1f03b34-7b61-4073-b21f-7957b879666e)

Daytime

![Daytime](https://github.com/user-attachments/assets/66857fdb-abab-4fcd-8c97-f436cd0347a5)

Evening

![Evening](https://github.com/user-attachments/assets/bdd4147a-72b8-4092-be3b-e9ec841ed3b9)

From top to bottom, the indicators show hour, minute, and second adjustment mode.

![Adjustment indicators](https://github.com/user-attachments/assets/2179bb9b-34b8-4cc4-9233-fc4375b41064)

The box on the lower right lets the user know that the clock is in setup mode.

![Setup mode box](https://github.com/user-attachments/assets/19bbe36c-d4c5-4080-a595-86273b413ecc)

This is the sun.

![Sun](https://github.com/user-attachments/assets/d1254a20-470d-4ff9-8714-d2e25d91a751)

This is the moon.

# How to test

Connect a VGA monitor to the output pins. Power on the design, and the clock will start running from 00:00:00.

To adjust the time, connect a Gamepad PMOD to the input pins. Press Start to enter time adjustment mode. Use Up/Down to increment or decrement the selected field. Press Select to cycle between hour, minute, and second adjustment. Press Start again to exit adjustment mode.

![Gamepad PMOD](https://github.com/user-attachments/assets/3966c2bd-14b4-44a3-84d9-ecbb02daa7ef)

If you are using the Tiny Tapeout VGA Playground, use the PMOD key controls to set the time.

![VGA Playground keys](https://github.com/user-attachments/assets/e9e2a594-78be-477a-adea-e8f360df3180)

Press and release the Start button to enter clock setup mode.

You can toggle between hour, minute, and second adjustment using the Sel button.

![Second adjustment](https://github.com/user-attachments/assets/542b7c09-4563-4ae4-9292-a07a574b186f)

By default, setup mode adjusts the seconds.

![Minute adjustment](https://github.com/user-attachments/assets/a7005954-dc15-4384-9627-edfadca4eb1c)

This is minute adjustment mode.

![Hour adjustment](https://github.com/user-attachments/assets/b0d85fce-0d81-475a-9868-4feeab6aa4d7)

Lastly, this is hour adjustment mode.

Here is the link to test it out:

[VGA Playground](https://vga-playground.com/?repo=https%3A%2F%2Fgithub.com%2Felectron65%2Fttsky-electron65&ref=dd5cec8e141130985bbc8143fcac65022de57dd9)

# External hardware

* VGA monitor
* Gamepad PMOD

# External links

* [Clockywock concept](https://kmandla.wordpress.com/2009/12/26/an-analog-clock-for-the-console/)
* [Website](https://www.kojw.com)
* [LinkedIn](https://www.linkedin.com/in/jong-wan-ko-673149256)
