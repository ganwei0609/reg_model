`ifndef MY_TRANSACTION_SV
`define MY_TRANSACTION_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class my_transaction extends uvm_sequence_item;
	rand bit[15:0] rd_data;
	rand bit[15:0] wr_data;
	rand bit[15:0] addr;
	rand bus_op_e bus_op;
	constraint addr_cons{
		addr == 16'h9;
	}

	extern function new(string name = "my_transaction");
	`uvm_object_utils_begin(my_transaction)
		`uvm_field_int(rd_data, UVM_ALL_ON)
		`uvm_field_int(wr_data, UVM_ALL_ON)	
		`uvm_field_int(addr, UVM_ALL_ON)	
		`uvm_field_int(bus_op, UVM_ALL_ON)	
	`uvm_object_utils_end
endclass

function my_transaction::new(string name = "my_transaction");
	super.new(name);
endfunction
`endif
