transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/andre/Documents/GitHub/wp01-testvga-grupo-6/PWM {C:/Users/andre/Documents/GitHub/wp01-testvga-grupo-6/PWM/pwm_basico.v}

vlog -vlog01compat -work work +incdir+C:/Users/andre/Documents/GitHub/wp01-testvga-grupo-6/PWM {C:/Users/andre/Documents/GitHub/wp01-testvga-grupo-6/PWM/pwm_basico_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  pwm_basico_tb

add wave *
view structure
view signals
run -all
