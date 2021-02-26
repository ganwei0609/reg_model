`ifndef MY_REG_MODEL_SV
`define MY_REG_MODEL_SV
class reg_invert extends uvm_reg;
	rand uvm_reg_field reg_data;
	`uvm_object_utils(reg_invert)
	
	extern function new(input string name = "reg_invert");
	extern function void build();
endclass

function reg_invert::new(input string name = "reg_invert");
	super.new(name, 16, UVM_NO_COVERAGE);
endfunction

function void reg_invert::build();
	reg_data = uvm_reg_field::type_id::create("reg_data");	
	//parent
	//bit with
	//start bit
	//access
	//volatile
	//reset value
	//has reset
	//is rand
	//separate access
	reg_data.configure(this, 1, 0, "RW", 1, 0, 1, 1, 0);
endfunction

`endif