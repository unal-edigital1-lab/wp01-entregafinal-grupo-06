transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/equip/Downloads/Prueba {C:/Users/equip/Downloads/Prueba/pwm_basico.v}

vlog -vlog01compat -work work +incdir+C:/Users/equip/Downloads/Prueba {C:/Users/equip/Downloads/Prueba/pwm_basico_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  pwm_basico_tb

add wave *
view structure
view signals
run -all
