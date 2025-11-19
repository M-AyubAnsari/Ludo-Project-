## Clock Signal

set_property PACKAGE_PIN W5 [get_ports clk_100MHz]
set_property IOSTANDARD LVCMOS33 [get_ports clk_100MHz]
create_clock -period 10.0 [get_ports clk_100MHz]

## Reset Button (Center button on Basys 3 - active-high)
set_property PACKAGE_PIN U18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

# H-sync

set_property PACKAGE_PIN P19 [get_ports h_sync]
set_property IOSTANDARD LVCMOS33 [get_ports h_sync]

# V-sync
set_property PACKAGE_PIN R19 [get_ports v_sync]
set_property IOSTANDARD LVCMOS33 [get_ports v_sync]

# Red [3:0]

set_property PACKAGE_PIN G19 [get_ports {red[0]}]
set_property PACKAGE_PIN H19 [get_ports {red[1]}]
set_property PACKAGE_PIN J19 [get_ports {red[2]}]
set_property PACKAGE_PIN N19 [get_ports {red[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {red[*]}]

# Green [3:0]

set_property PACKAGE_PIN J17 [get_ports {green[0]}]
set_property PACKAGE_PIN H17 [get_ports {green[1]}]
set_property PACKAGE_PIN G17 [get_ports {green[2]}]
set_property PACKAGE_PIN D17 [get_ports {green[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {green[*]}]

# Blue [3:0]

set_property PACKAGE_PIN N18 [get_ports {blue[0]}]
set_property PACKAGE_PIN L18 [get_ports {blue[1]}]
set_property PACKAGE_PIN K18 [get_ports {blue[2]}]
set_property PACKAGE_PIN J18 [get_ports {blue[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {blue[*]}]

## Configuration (prevents warnings)
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
