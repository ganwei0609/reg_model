`ifndef MY_REG_BLOCK_SV
`define MY_REG_BLOCK_SV
class reg_model extends uvm_reg_block;
	rand reg_invert invert;
	`uvm_object_utils(reg_model)
	extern function new(input string name = "reg_model");
	extern function void build();
endclass

function reg_model::new(input string name = "reg_model");
	super.new(name, UVM_NO_COVERAGE);
endfunction

function void reg_model::build();
	//name
	//base addr
	//bus width(bytes)
	//UVM_BIG_ENDIAN  UVM_LITTLE_ENDIAN
	//support addressing by byte
	`uvm_info("reg_model", "build start", UVM_LOW);	
	default_map = create_map("default_map", 0, 2, UVM_BIG_ENDIAN, 0);
	invert = reg_invert::type_id::create("invert", , get_full_name());
	
	//uvm_reg_block's pointer
	//reg_file's pointer
	//register backdoor access path
	invert.configure(this, null, "");
	invert.build();
	default_map.add_reg(invert, 'h9, "RW");
	`uvm_info("reg_model", "build OK", UVM_LOW);	
endfunction
`endif