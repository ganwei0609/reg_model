`ifndef RAL_GANWEI_REG_MAP
`define RAL_GANWEI_REG_MAP

import uvm_pkg::*;

class ral_reg_counter_high extends uvm_reg;
	rand uvm_reg_field counter_high;

	function new(string name = "counter_high");
		super.new(name, 16,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.counter_high = uvm_reg_field::type_id::create("counter_high",,get_full_name());
      this.counter_high.configure(this, 16, 0, "RW", 0, 16'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_counter_high)

endclass : ral_reg_counter_high


class ral_reg_counter_low extends uvm_reg;
	rand uvm_reg_field counter_low;

	function new(string name = "counter_low");
		super.new(name, 16,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.counter_low = uvm_reg_field::type_id::create("counter_low",,get_full_name());
      this.counter_low.configure(this, 16, 0, "RW", 0, 16'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_counter_low)

endclass : ral_reg_counter_low


class ral_reg_invert extends uvm_reg;
	rand uvm_reg_field invert;

	function new(string name = "invert");
		super.new(name, 8,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.invert = uvm_reg_field::type_id::create("invert",,get_full_name());
      this.invert.configure(this, 1, 0, "RW", 0, 1'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_invert)

endclass : ral_reg_invert


class ral_block_ganwei_reg_map extends uvm_reg_block;
	rand ral_reg_counter_high counter_high;
	rand ral_reg_counter_low counter_low;
	rand ral_reg_invert invert;
	rand uvm_reg_field counter_high_counter_high;
	rand uvm_reg_field counter_low_counter_low;
	rand uvm_reg_field invert_invert;

	function new(string name = "ganwei_reg_map");
		super.new(name, build_coverage(UVM_NO_COVERAGE));
	endfunction: new

   virtual function void build();
      this.default_map = create_map("", 0, 4, UVM_LITTLE_ENDIAN, 0);
      this.counter_high = ral_reg_counter_high::type_id::create("counter_high",,get_full_name());
      this.counter_high.configure(this, null, "counter[31:16]");
      this.counter_high.build();
      this.default_map.add_reg(this.counter_high, `UVM_REG_ADDR_WIDTH'h5, "RW", 0);
		this.counter_high_counter_high = this.counter_high.counter_high;
      this.counter_low = ral_reg_counter_low::type_id::create("counter_low",,get_full_name());
      this.counter_low.configure(this, null, "counter[15:0]");
      this.counter_low.build();
      this.default_map.add_reg(this.counter_low, `UVM_REG_ADDR_WIDTH'h6, "RW", 0);
		this.counter_low_counter_low = this.counter_low.counter_low;
      this.invert = ral_reg_invert::type_id::create("invert",,get_full_name());
      this.invert.configure(this, null, "invert");
      this.invert.build();
      this.default_map.add_reg(this.invert, `UVM_REG_ADDR_WIDTH'h9, "RW", 0);
		this.invert_invert = this.invert.invert;
   endfunction : build

	`uvm_object_utils(ral_block_ganwei_reg_map)

endclass : ral_block_ganwei_reg_map



`endif
