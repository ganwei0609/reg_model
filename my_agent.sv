`ifndef MY_AGENT_SV
`define MY_AGENT_SV
class my_agent extends uvm_agent;
	my_sequencer sqr;
	my_driver drv;
	my_monitor mon;
	uvm_analysis_port#(my_transaction) ap;
	
	extern function new(string name, uvm_component parent);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
	
	`uvm_component_utils(my_agent)
endclass

function my_agent::new(string name, uvm_component parent);
		super.new(name, parent);
endfunction
	
function void my_agent::build_phase(uvm_phase phase);
	`uvm_info("my_agent", $sformatf("path = %s, is_active = %d", get_full_name(), is_active), UVM_LOW);
	if(is_active == UVM_ACTIVE) begin
		`uvm_info("my_agent", $sformatf("path = %s, UVM_ACTIVE", get_full_name()), UVM_LOW);
		sqr = my_sequencer::type_id::create("sqr", this);
		drv = my_driver::type_id::create("drv", this);
	end
	mon = my_monitor::type_id::create("mon", this);
endfunction

function void my_agent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	if(is_active == UVM_ACTIVE) begin
		drv.seq_item_port.connect(sqr.seq_item_export);
	end
	this.ap = mon.ap;

endfunction
`endif


