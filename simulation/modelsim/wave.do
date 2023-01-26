onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Yellow -itemcolor Yellow /sram_controller_tb/clk
add wave -noupdate /sram_controller_tb/clk_en
add wave -noupdate /sram_controller_tb/iData
add wave -noupdate /sram_controller_tb/DUT/Data_reg
add wave -noupdate -color Cyan /sram_controller_tb/SRAM_data
add wave -noupdate /sram_controller_tb/R_W
add wave -noupdate /sram_controller_tb/oWE
add wave -noupdate /sram_controller_tb/oOE
add wave -noupdate /sram_controller_tb/DUT/mem_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {117638 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 233
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {58688 ps} {150823 ps}
