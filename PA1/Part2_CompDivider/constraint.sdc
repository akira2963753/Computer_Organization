current_design CompDivider

#Clock Rate
set_units -time ns
create_clock [get_ports clk] -name core_clock -period 5

#Delay
set_input_delay 0.092 -clock core_clock [all_inputs]

#Delay
set_output_delay 0.092 -clock core_clock [all_outputs]
