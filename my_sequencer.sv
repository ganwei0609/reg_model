`ifndef MY_SEQUENCER_SV
`define MY_SEQUENCER_SV

`include "uvm_macros.svh"
`include "my_sequence.sv"
import uvm_pkg::*;
class my_sequencer extends uvm_sequencer #(my_transaction);
	`uvm_component_utils(my_sequencer)
	extern function new(string name, uvm_component parent);
endclass

function my_sequencer::new(string name, uvm_component parent);
	super.new(name, parent);
endfunction

`endif