`ifndef MY_CASE0_SV
`define MY_CASE0_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class my_sequence0 extends uvm_sequence #(my_transaction);
	my_transaction trans;
	`uvm_object_utils(my_sequence0)
	extern function new(string name = "my_sequence0");
	extern virtual task pre_body();
	extern virtual task post_body();
	extern virtual task body();
endclass
function my_sequence0::new(string name = "my_sequence0");
	super.new(name);
endfunction
	
task my_sequence0::pre_body();
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

task my_sequence0::post_body();
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
	
task my_sequence0::body();
	int unsigned sequence_count = 0;
	repeat(20) begin
		`uvm_info("my_sequence0", $sformatf("send sequence %d", sequence_count), UVM_LOW);
		`uvm_do(trans);			
		//`uvm_do_with(trans, {trans.bus_op == BUS_WR;})
		sequence_count++;
	end
	#1ms;
endtask

class case0_cfg_vseq extends uvm_sequence;
	`uvm_object_utils(case0_cfg_vseq)
	`uvm_declare_p_sequencer(my_vsqr)
	bit[31:0] counter;
	bit invert;
	extern function new(string name = "case0_cfg_vseq");
	extern virtual task body();
endclass

function case0_cfg_vseq::new(string name = "case0_cfg_vseq");
	super.new(name);
endfunction
task case0_cfg_vseq::body();
	uvm_status_e status;
	uvm_reg_data_t value;
	uvm_phase phase;
	//uvm_reg_mem_hdl_paths_req ck_seq;
	//uvm_reg_hw_reset_req reset_seq;	
	//uvm_reg_access_req access_seq;
	
`ifdef SVT_UVM_12_OR_HIGHER
	`uvm_info("case0_cfg_vseq", "SVT_UVM_12_OR_HIGHER", UVM_LOW)
	phase = get_starting_phase();
`else
	phase = starting_phase;
`endif
	if (phase == null) begin
		`uvm_info("case0_cfg_vseq", "pre_body  phase == null", UVM_LOW);	
	end
	else begin
		phase.raise_objection(this);
	end
	
	//ck_seq = new("ck_seq");
	//ck_seq.reg_model = p_sequencer.p_rm;
	//ck_seq.start(null);

	//reset_seq = new("reset_seq");
	//reset_seq.reg_model = p_sequencer.p_rm;
	//reset_seq.start(null);

	//access_seq = new("access_seq");
	//access_seq.reg_model = p_sequencer.p_rm;
	//access_seq.start(null);
	
	`uvm_info("case0_cfg_vseq", "start1", UVM_LOW)
	invert = 0;
	counter = 0;
	p_sequencer.cov.cov_counter_grp.sample(counter);
	p_sequencer.cov.cov_invert_grp.sample(invert);
	
	p_sequencer.p_rm.invert.read(status, value, UVM_FRONTDOOR);
	`uvm_info("case0_cfg_vseq", $sformatf("invert initial value is %0h", value), UVM_LOW)
	p_sequencer.p_rm.invert.write(status, 1, UVM_FRONTDOOR);
	`uvm_info("case0_cfg_vseq", "write 1", UVM_LOW)
	p_sequencer.p_rm.invert.read(status, value, UVM_FRONTDOOR);
	`uvm_info("case0_cfg_vseq", $sformatf("invert value(after write) is %0h", value), UVM_LOW)

	value = p_sequencer.p_rm.invert.get();
	`uvm_info("case0_cfg_vseq", $sformatf("desired value before set is %0h", value), UVM_LOW)	
	value = p_sequencer.p_rm.invert.get_mirrored_value();
	`uvm_info("case0_cfg_vseq", $sformatf("mirrored value before set is %0h", value), UVM_LOW)	
	
	p_sequencer.p_rm.invert.set(16'h0);
	value = p_sequencer.p_rm.invert.get();
	`uvm_info("case0_cfg_vseq", $sformatf("desired value after set is %0h", value), UVM_LOW)
	value = p_sequencer.p_rm.invert.get_mirrored_value();
	`uvm_info("case0_cfg_vseq", $sformatf("mirrored value after set is %0h", value), UVM_LOW)	
	
	p_sequencer.p_rm.invert.update(status, UVM_FRONTDOOR);
	value = p_sequencer.p_rm.invert.get();
	`uvm_info("case0_cfg_vseq", $sformatf("desired value after update is %0h", value), UVM_LOW)
	value = p_sequencer.p_rm.invert.get_mirrored_value();
	`uvm_info("case0_cfg_vseq", $sformatf("mirrored value after update is %0h", value), UVM_LOW)		
	
	p_sequencer.p_rm.invert.peek(status, value);
	`uvm_info("case0_cfg_vseq", $sformatf("peek value after update is %0h", value), UVM_LOW)	
	
	
	//backdoor access
	p_sequencer.p_rm.counter_low.peek(status, value);
	counter[15:0] = value;
	p_sequencer.p_rm.counter_high.peek(status, value);
	counter[31:16] = value;	
	`uvm_info("case0_cfg_vseq", $sformatf("counter before set is %0h", counter), UVM_LOW)

	p_sequencer.p_rm.counter_low.poke(status, 16'haaaa);
	p_sequencer.p_rm.counter_high.poke(status, 16'hbbbb);
	`uvm_info("case0_cfg_vseq", "count set", UVM_LOW)	

	p_sequencer.p_rm.counter_low.peek(status, value);
	counter[15:0] = value;
	p_sequencer.p_rm.counter_high.peek(status, value);
	counter[31:16] = value;	
	`uvm_info("case0_cfg_vseq", $sformatf("counter after set is %0h", counter), UVM_LOW)	
	
`ifdef SVT_UVM_12_OR_HIGHER
	phase = get_starting_phase();
`else
	phase = starting_phase;
`endif
	if (phase!=null) begin
		phase.drop_objection(this);
		`uvm_info("case_cfg_vseq", "phase drop success", UVM_LOW);	
	end
	else begin
		`uvm_info("case0_vseq", "phase == null", UVM_LOW);	
	end	
endtask


class case0_vseq extends uvm_sequence;
	`uvm_object_utils(case0_vseq)
	`uvm_declare_p_sequencer(my_vsqr)
	extern function new(string name = "case0_vseq");
	extern virtual task pre_body();
	extern virtual task post_body();
	extern virtual task body();
endclass
function case0_vseq::new(string name = "case0_vseq");
	super.new();
endfunction
task case0_vseq::pre_body();
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
		`uvm_info("case0_vseq", "pre_body  phase == null", UVM_LOW);	
	end
endtask: pre_body	
task case0_vseq::post_body();
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
		`uvm_info("case0_vseq", "post_body  phase == null", UVM_LOW);	
	end		
endtask: post_body
task case0_vseq::body();
	my_sequence0 dseq;
	`uvm_info("case0_vseq", "body start", UVM_LOW);		
	dseq = my_sequence0::type_id::create("dseq");
	dseq.start(p_sequencer.p_my_sqr);
endtask

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
	`uvm_info("my_case0", $sformatf("path = %s", get_full_name()), UVM_LOW)
	uvm_config_db#(uvm_object_wrapper)::set(this, "v_sqr.configure_phase", "default_sequence", case0_cfg_vseq::type_id::get());
	uvm_config_db#(uvm_object_wrapper)::set(this, "v_sqr.main_phase", "default_sequence", case0_vseq::type_id::get());
endfunction

`endif


