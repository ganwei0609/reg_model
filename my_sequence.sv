`ifndef MY_SEQUENCE_SV
`define MY_SEQUENCE_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class my_sequence extends uvm_sequence #(my_transaction);
	`uvm_object_utils(my_sequence)
	my_transaction tr;
	extern function new(string name = "my_sequence");
	extern virtual task body();
endclass

function my_sequence::new(string name = "my_sequence");
	super.new(name);
endfunction

task my_sequence::body();
	if(starting_phase != null) begin
		starting_phase.raise_objection(this);
	end
		repeat(10) begin
			`uvm_do(tr);
		end
		#100;
	
	if(starting_phase != null) begin
		starting_phase.drop_objection(this);
	end

endtask
`endif