`ifndef MY_VSQR_SV
`define MY_VSQR_SV
class my_vsqr extends uvm_sequencer;
	my_sequencer p_my_sqr;
	bus_sequencer p_bus_sqr;
	ral_block_ganwei_reg_map p_rm;
	my_cov cov;
	
	`uvm_component_utils(my_vsqr)
	extern function new(string name, uvm_component parent);
endclass

function my_vsqr::new(string name, uvm_component parent);
	super.new(name, parent);
endfunction

`endif