`ifndef MY_TEST_SV
`define MY_TESGT_SV
class my_test extends uvm_test #(my_transaction);
	`uvm_component_utils(my_test)
	my_env env;
	extern function new(string name = "my_test", uvm_component parent = null);
	extern virtual function void build_phase(uvm_phase phase);
	extern task main_phase(uvm_phase phase);
	extern function void final_phase(uvm_phase phase);

endclass

function my_test::new(string name = "my_test", uvm_component parent = null);
	super.new(name, parent);
	env = new("env", this);
endfunction

function void my_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
	set_report_max_quit_count(30);
endfunction

task my_test::main_phase(uvm_phase phase);
	`uvm_info("main_phase", "Entered ...",UVM_LOW)
    `uvm_info("main_phase",$sformatf("Setting the drain time in the main_phase of the base test to 6000000"),UVM_NONE) 
    phase.phase_done.set_drain_time(this, (6000000));
    `uvm_info("main_phase", "Exited ...",UVM_LOW)
endtask // main_phase

/**
* Calculate the pass or fail status for the test in the final phase method of the
* test. If a UVM_FATAL, UVM_ERROR, or a UVM_WARNING message has been generated the
* test will fail.
*/
function void my_test::final_phase(uvm_phase phase);
	uvm_report_server svr;
    `uvm_info("final_phase", "Entered ...",UVM_LOW)

    super.final_phase(phase);
    svr = uvm_report_server::get_server();
    if (svr.get_severity_count(UVM_FATAL) + 
		svr.get_severity_count(UVM_ERROR) + 
		svr.get_severity_count(UVM_WARNING) > 0)
		`uvm_info("final_phase", "\nSvtTestEpilog: Failed\n", UVM_LOW)
    else
		`uvm_info("final_phase", "\nSvtTestEpilog: Passed\n", UVM_LOW)
		`uvm_info("final_phase", "Exited ...",UVM_LOW)
  endfunction
`endif
