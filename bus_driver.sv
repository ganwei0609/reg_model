`ifndef BUS_DRIVER_SV
`define BUS_DRIVER_SV
class bus_driver extends uvm_driver#(bus_transaction);
	virtual bus_if vif;
	`uvm_component_utils(bus_driver)
	extern function new(string name = "bus_driver", uvm_component parent = null);
	extern virtual function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task drive_one_pkt(bus_transaction tr);
endclass
function bus_driver::new(string name = "bus_driver", uvm_component parent = null);
	super.new(name, parent);
endfunction
function void bus_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(virtual bus_if)::get(this, "", "vif", vif)) begin
		`uvm_fatal("bus_driver", "get interface vif failed")
	end
endfunction
task bus_driver::run_phase(uvm_phase phase);
	vif.bus_cmd_valid <= 1'b0;
	vif.bus_op <= 1'b0;
	vif.bus_addr <= 15'b0;
	vif.bus_wr_data <= 15'b0;
	`uvm_info("bus_driver", $sformatf("path = %s", get_full_name()), UVM_LOW)
	while(!vif.rst_n)
		@(posedge vif.clk);
	`uvm_info("bus_driver", "run_phase begin loop", UVM_LOW)
	while(1) begin
		seq_item_port.get_next_item(req);
		drive_one_pkt(req);
		seq_item_port.item_done();
	end
endtask
task bus_driver::drive_one_pkt(bus_transaction tr);
	`uvm_info("bus_driver", "drive one pkt", UVM_LOW)
	tr.print();
	repeat(1) @(posedge vif.clk);

	vif.bus_cmd_valid <= 1'b1;
	vif.bus_op <= ((tr.bus_op == BUS_RD) ? 0 : 1); 
	vif.bus_addr <= tr.addr;
	vif.bus_wr_data <= ((tr.bus_op == BUS_RD) ? 0 : tr.wr_data);

	@(posedge vif.clk);
	vif.bus_cmd_valid <= 1'b0;
	vif.bus_op <= 1'b0;
	vif.bus_addr <= 15'b0;
	vif.bus_wr_data <= 15'b0;
	
	@(posedge vif.clk);
	if(tr.bus_op == BUS_RD) begin
		tr.rd_data = vif.bus_rd_data;
	end
endtask
`endif