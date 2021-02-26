`ifndef BUS_SEQUENCER_SV
`define BUS_SEQUENCER_SV
class bus_sequencer extends uvm_sequencer #(bus_transaction);
	`uvm_component_utils(bus_sequencer)
	extern function new(string name, uvm_component parent);
endclass

function bus_sequencer::new(string name, uvm_component parent);
	super.new(name, parent);
endfunction
`endif


