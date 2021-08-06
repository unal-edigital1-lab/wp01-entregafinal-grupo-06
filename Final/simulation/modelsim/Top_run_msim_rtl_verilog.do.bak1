transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/equip/Documents/GitHub/wp01-testvga-grupo-6/Final {C:/Users/equip/Documents/GitHub/wp01-testvga-grupo-6/Final/Top.v}
vlog -vlog01compat -work work +incdir+C:/Users/equip/Documents/GitHub/wp01-testvga-grupo-6/Final {C:/Users/equip/Documents/GitHub/wp01-testvga-grupo-6/Final/pwm_basico.v}
vlog -vlog01compat -work work +incdir+C:/Users/equip/Documents/GitHub/wp01-testvga-grupo-6/Final {C:/Users/equip/Documents/GitHub/wp01-testvga-grupo-6/Final/Display.v}
vlog -vlog01compat -work work +incdir+C:/Users/equip/Documents/GitHub/wp01-testvga-grupo-6/Final {C:/Users/equip/Documents/GitHub/wp01-testvga-grupo-6/Final/BCDtoSSeg.v}

vlog -vlog01compat -work work +incdir+C:/Users/equip/Documents/GitHub/wp01-testvga-grupo-6/Final {C:/Users/equip/Documents/GitHub/wp01-testvga-grupo-6/Final/Top_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  Top_tb

add wave *
view structure
view signals
run -all
