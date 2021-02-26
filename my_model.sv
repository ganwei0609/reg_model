`ifndef MY_MODEL_SV
`define MY_MODEL_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
class my_model extends uvm_component;
	uvm_blocking_get_port #(my_transaction) in_port;
	uvm_analysis_port #(my_transaction) out_port;	
	reg_model p_rm;
	`uvm_component_utils(my_model)
	extern function new(string name, uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task main_phase(uvm_phase phase);
	extern function void invert_tr(my_transaction tr);
endclass

function my_model::new(string name, uvm_component parent);
	super.new(name, parent);
endfunction

function void my_model::build_phase(uvm_phase phase);
	super.build_phase(phase);
	in_port = new("in_port", this);
	out_port = new("out_port", this);
endfunction

task my_model::main_phase(uvm_phase phase);
	my_transaction in_tr, out_tr;
	uvm_status_e status;
	uvm_reg_data_t value;
	super.main_phase(phase);
	`uvm_info("my_model", $sformatf("path = %s", get_full_name()), UVM_LOW)	
	//p_rm.invert.read(status, value, UVM_FRONTDOOR);
	`uvm_info("my_model", $sformatf("value = %d", value), UVM_LOW)		
	while(1) begin
		in_port.get(in_tr);
		`uvm_info("my_model", "get one transaction", UVM_LOW)
		out_tr = new("out_tr");
		out_tr.copy(in_tr);
		`uvm_info("my_model", "get one transaction, copy and print it:", UVM_LOW)
		out_tr.print();
		if(value) begin
			invert_tr(out_tr);
		end
		out_port.write(out_tr);
	end
endtask 

function void my_model::invert_tr(my_transaction tr);

endfunction
`endif