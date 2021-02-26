`ifndef MY_REG_ADAPTER_SV
`define MY_REG_ADAPTER_SV
class my_adapter extends uvm_reg_adapter;
	string tID = get_type_name();
	`uvm_object_utils(my_adapter)
	extern function new(string name = "my_adapter");
	extern function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
	extern function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
endclass

function my_adapter::new(string name = "my_adapter");
	super.new(name);
endfunction

function uvm_sequence_item my_adapter::reg2bus(const ref uvm_reg_bus_op rw);
	bus_transaction tr;
	`uvm_info("my_adapter", $sformatf("reg2bus:path=%s", get_full_name()), UVM_LOW);
	tr = new("tr");
	tr.addr = rw.addr;
	tr.bus_op = ((rw.kind == UVM_READ) ? BUS_RD : BUS_WR);
	if(tr.bus_op == BUS_WR) begin
		tr.wr_data = rw.data;
	end
	`uvm_info("my_adapter", $sformatf("reg2bus:path=%s", get_full_name()), UVM_LOW);	
	return tr;
endfunction

function void my_adapter::bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
	bus_transaction tr;
	`uvm_info("my_adapter", $sformatf("bus2reg:path=%s", get_full_name()), UVM_LOW);	
	if(!$cast(tr, bus_item)) begin
		`uvm_fatal(tID, "bus_item is not the correct type")
	end
	rw.kind  = ((tr.bus_op == BUS_RD) ? UVM_READ : UVM_WRITE);
	rw.addr = tr.addr;
	rw.byte_en = 'h3;
	rw.data = ((tr.bus_op == BUS_RD) ? tr.rd_data : tr.wr_data);
	rw.status = UVM_IS_OK;
	`uvm_info("my_adapter", $sformatf("bus2reg:path=%s", get_full_name()), UVM_LOW);	
endfunction
`endif