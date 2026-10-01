# arty_a7_100t.xdc -- constraints for arty_top.v on the Digilent Arty A7-100T
# (xc7a100tcsg324-1). Pin locations taken from Digilent's official master
# constraint file (Arty-A7-100-Master.xdc, Rev. D/E):
#   https://github.com/Digilent/digilent-xdc/blob/master/Arty-A7-100-Master.xdc
# Only the pins arty_top.v actually uses are enabled here (clock, 4 standard
# LEDs, first 2 pushbuttons) -- everything else on that board (switches,
# RGB LEDs, UART, Pmods, DDR3, etc.) is left unconstrained since this design
# doesn't use them.

## Clock signal (100 MHz onboard oscillator)
set_property -dict { PACKAGE_PIN E3 IOSTANDARD LVCMOS33 } [get_ports { CLK100MHZ }];
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { CLK100MHZ }];

## LEDs (4 standard, non-RGB)
set_property -dict { PACKAGE_PIN H5  IOSTANDARD LVCMOS33 } [get_ports { LED[0] }];
set_property -dict { PACKAGE_PIN J5  IOSTANDARD LVCMOS33 } [get_ports { LED[1] }];
set_property -dict { PACKAGE_PIN T9  IOSTANDARD LVCMOS33 } [get_ports { LED[2] }];
set_property -dict { PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports { LED[3] }];

## Buttons (BTN[0] = start, BTN[1] = reset; active-high when pressed)
set_property -dict { PACKAGE_PIN D9 IOSTANDARD LVCMOS33 } [get_ports { BTN[0] }];
set_property -dict { PACKAGE_PIN C9 IOSTANDARD LVCMOS33 } [get_ports { BTN[1] }];

## Configuration options, since this board loads the bitstream via JTAG/QSPI
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

## Exposed UART pins for USB-Serial Bridge: 

## ok for future reference: 
set_property -dict { PACKAGE_PIN A9 IOSTANDARD LVCMOS33 } [get_ports { uart_rx }];    ## data comes OUT of the FTDI chip and going IN to the FPGA
set_property -dict { PACKAGE_PIN D10  IOSTANDARD LVCMOS33 } [get_ports { uart_tx }];     ## Data coming OUT of the FPGA and going IN to the FTDI chip

