`ifndef MY_CASE0_SV
`define MY_CASE0_SV
class my_sequence0 extends uvm_sequence#(my_transaction);
	my_transaction trans;
	`uvm_object_utils(my_sequence0)
	function new(string name = "my_sequence0");
		super.new(name);
	endfunction
	
	virtual task pre_body();
		uvm_phase phase;
		super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
		phase = get_starting_phase();
`else
		phase = starting_phase;
`endif
		if (phase!=null) begin
			phase.raise_objection(this);
		end
		else begin
			`uvm_info("my_sequence0", "pre_body  phase == null", UVM_LOW);	
		end
	endtask: pre_body	

	virtual task post_body();
		uvm_phase phase;
		super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
		phase = get_starting_phase();
`else
		phase = starting_phase;
`endif
		if (phase!=null) begin
			phase.drop_objection(this);
		end
		else begin
			`uvm_info("my_sequence0", "post_body  phase == null", UVM_LOW);	
		end		
  endtask: post_body
	
	virtual task body();
		int unsigned sequence_count = 0;
		repeat(20) begin
			`uvm_do(trans);			
			//`uvm_do_with(trans, {trans.bus_op == BUS_WR;})
			`uvm_info("my_sequence0", $sformatf("send sequence %d", sequence_count), UVM_LOW);
			sequence_count++;
		end
		#1ms;
	endtask
endclass

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
	uvm_config_db#(uvm_object_wrapper)::set(this, "env.i_agt.sqr.main_phase", "default_sequence", my_sequence0::type_id::get());
endfunction

`endif


