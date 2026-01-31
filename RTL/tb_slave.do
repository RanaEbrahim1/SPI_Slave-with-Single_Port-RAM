vlib work      
vlog ram.v slave.v top_module.v tb_slave.v  
vsim -voptargs=+acc work.slave_tb
add wave *
run -all
#quit -sim
