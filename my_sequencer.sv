`ifndef MY_SEQUENCER_SV
`define MY_SEQUENCER_SV

`include "uvm_macros.svh"
`include "my_sequence.sv"
import uvm_pkg::*;
class my_sequencer extends uvm_sequencer #(my_transaction);
	`uvm_component_utils(my_sequencer)
	extern function new(string name, uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task main_phase(uvm_phase phase); 
endclass

function my_sequencer::new(string name, uvm_component parent);
	super.new(name, parent);
endfunction

function void my_sequencer::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task my_sequencer::main_phase(uvm_phase phase);
	my_sequence my_seq;
	super.main_phase(phase);
	my_seq = new("my_seq");
	my_seq.starting_phase = phase;
	my_seq.start(this);
endtask
`endif