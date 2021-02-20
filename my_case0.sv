`ifndef MY_CASE0_SV
`define MY_CASE0_SV
class my_case0 extends my_test;
	extern function new(string name = "my_case0", uvm_component parent = null);
	extern virtual function void build_phase(uvm_phase phase);
	`uvm_component_utils(my_case0)
endclass

function my_case0::new(string name = "my_case0", uvm_component parent = null);
	super.new(name, parent);
endfunction

function void my_case0::build_phase(uvm_phase phase);
	super.build_phase(phase);
	uvm_config_db#(uvm_object_wrapper)::set(this, "env.i_agent.sqr.main_phase", "default_phase", my_case0::type_id::get());	
endfunction
`endif


