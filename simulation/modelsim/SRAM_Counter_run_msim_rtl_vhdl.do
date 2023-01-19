transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/schumae/Documents/EE316_Junior_Lab_SRAM_Counter/concat_zero_to_input.vhd}
vcom -93 -work work {C:/Users/schumae/Documents/EE316_Junior_Lab_SRAM_Counter/counter.vhd}
vcom -93 -work work {C:/Users/schumae/Documents/EE316_Junior_Lab_SRAM_Counter/keypad_int.vhd}
vcom -93 -work work {C:/Users/schumae/Documents/EE316_Junior_Lab_SRAM_Counter/sram_ctrl.vhd}
vcom -93 -work work {C:/Users/schumae/Documents/EE316_Junior_Lab_SRAM_Counter/driver_7_degemnt.vhd}
vcom -93 -work work {C:/Users/schumae/Documents/EE316_Junior_Lab_SRAM_Counter/controller_7_segment.vhd}
vcom -93 -work work {C:/Users/schumae/Documents/EE316_Junior_Lab_SRAM_Counter/ROM.vhd}
vcom -93 -work work {C:/Users/schumae/Documents/EE316_Junior_Lab_SRAM_Counter/test_display.vhd}

