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
	int unsigned sequence_count = 0;
	//if(starting_phase != null) begin
	//	starting_phase.raise_objection(this);
	//end
	//else begin
	//	`uvm_info("my_sequence", "starting_phase == null", UVM_LOW);
	//end
		repeat(10) begin
			`uvm_info("my_sequence", $sformatf("send sequence %d", sequence_count), UVM_LOW);
			`uvm_do(tr);
			`uvm_info("my_sequence", $sformatf("path=%s", get_full_name()), UVM_LOW);
			tr.print();
			sequence_count++;
		end
		#100;
	
	//if(starting_phase != null) begin
	//	starting_phase.drop_objection(this);
	//end

endtask
`endif