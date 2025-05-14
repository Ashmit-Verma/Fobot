# Clock signal
set_property PACKAGE_PIN Y9 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

# Reset signal
set_property PACKAGE_PIN P16 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

# Arduino input pins (4-bit input from external Arduino)
set_property PACKAGE_PIN Y11 [get_ports {arduino_input[0]}]
set_property PACKAGE_PIN AA11 [get_ports {arduino_input[1]}]
set_property PACKAGE_PIN Y10 [get_ports {arduino_input[2]}]
set_property PACKAGE_PIN AA9 [get_ports {arduino_input[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {arduino_input[*]}]

# Motor control outputs
set_property PACKAGE_PIN W12 [get_ports {motorL_pwm}];  # "JB1"
set_property PACKAGE_PIN W11 [get_ports {motorL_dir}];  # "JB2"
set_property PACKAGE_PIN V10 [get_ports {motorR_pwm}];  # "JB3"
set_property PACKAGE_PIN W8 [get_ports {motorR_dir}];  # "JB4"
set_property IOSTANDARD LVCMOS33 [get_ports motorL_*]
set_property IOSTANDARD LVCMOS33 [get_ports motorR_*]
