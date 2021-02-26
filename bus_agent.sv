`ifndef BUS_AGENT_SV
`define BUS_AGENT_SV
class bus_agent extends uvm_agent;
	bus_sequencer sqr;
	bus_driver drv;
	bus_monitor mon;
	uvm_analysis_port #(bus_transaction) ap;
	
	`uvm_component_utils(bus_agent)
	extern function new(string name, uvm_component parent);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
endclass

function bus_agent::new(string name, uvm_component parent);
	super.new(name, parent);
endfunction
function void bus_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(is_active == UVM_ACTIVE) begin
		sqr = bus_sequencer::type_id::create("sqr", this);
		drv = bus_driver::type_id::create("drv", this);
	end
	mon = bus_monitor::type_id::create("mon", this);
endfunction

function void bus_agent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	if(is_active == UVM_ACTIVE) begin
		drv.seq_item_port.connect(sqr.seq_item_export);
	end
	ap = mon.ap;
endfunction
`endif