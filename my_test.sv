`ifndef MY_TEST_SV
`define MY_TESGT_SV
class my_test extends uvm_test #(my_transaction);
	`uvm_component_utils(my_test)
	my_env env;
	reg_model rm;
	my_vsqr v_sqr;
	my_adapter reg_sqr_adapter;
	
	extern function new(string name = "my_test", uvm_component parent = null);
	extern virtual function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern function void final_phase(uvm_phase phase);

endclass

function my_test::new(string name = "my_test", uvm_component parent = null);
	super.new(name, parent);
endfunction

function void my_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
	env = my_env::type_id::create("env", this);	
	v_sqr = my_vsqr::type_id::create("v_sqr", this);
	rm = reg_model::type_id::create("rm", this);
	//parent block
	//backdoor access path
	rm.configure(null, "");
	rm.build();
	rm.lock_model();
	rm.reset();
	reg_sqr_adapter = my_adapter::type_id::create("req_sqr_adapter", this);	
	env.p_rm = this.rm;
	//set_report_max_quit_count(30);
endfunction

function void my_test::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	v_sqr.p_my_sqr = env.i_agt.sqr;
	v_sqr.p_bus_sqr = env.bus_agt.sqr;
	v_sqr.p_rm = this.rm;
	rm.default_map.set_sequencer(env.bus_agt.sqr, reg_sqr_adapter);
	rm.default_map.set_auto_predict(1);
	uvm_top.print_topology();	
endfunction

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
