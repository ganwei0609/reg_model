`ifndef MY_TEST_SV
`define MY_TESGT_SV
class my_test extends uvm_test #(my_transaction);
	`uvm_component_utils(my_test)
	my_env env;
	extern function new(string name = "my_test", uvm_component parent = null);
	extern virtual function void build_phase(uvm_phase phase);
endclass

function my_test::new(string name = "my_test", uvm_component parent = null);
	super.new(name, parent);
	env = new("env", this);
endfunction

function void my_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction
`endif
