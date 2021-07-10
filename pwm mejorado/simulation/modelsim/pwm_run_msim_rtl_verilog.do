transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/nicov/OneDrive/Escritorio/Labs\ digitales/Nuevopwm {C:/Users/nicov/OneDrive/Escritorio/Labs digitales/Nuevopwm/pwm.v}
vlog -vlog01compat -work work +incdir+C:/Users/nicov/OneDrive/Escritorio/Labs\ digitales/Nuevopwm {C:/Users/nicov/OneDrive/Escritorio/Labs digitales/Nuevopwm/timer_input.v}

