`ifndef MY_DRIVER_SV
`define MY_DRIVER_SV

`include "uvm_macros.svh"
import uvm_pkg::*;


class my_driver extends uvm_driver #(my_transaction);
	`uvm_component_utils(my_driver)
	virtual my_if vif;
	uvm_analysis_port #(my_transaction) ap;
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction
	
	extern function void build_phase(uvm_phase phase);
	extern task main_phase(uvm_phase phase);
	extern task drive_one_pkt(my_transaction tr);

endclass

function void my_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(virtual my_if)::get(this, "", "my_if", vif)) begin
		`uvm_fatal("my_driver", "driver get interface failed");
	end
	ap = new("ap", this);
endfunction


task my_driver::main_phase(uvm_phase phase);
	while(1) begin
		seq_item_port.get_next_item(req);
		drive_one_pkt(req);
		ap.write(req);
		seq_item_port.item_done();
	end
endtask


task my_driver::drive_one_pkt(my_transaction tr);
	`uvm_info("my_driver", "begin to drive one pkt", UVM_LOW);
	repeat(1) @(posedge vif.clk);
	vif.bus_cmd_valid <= 1'b1;
	if(tr.bus_op == BUS_RD) begin
		vif.bus_op <= BUS_RD;
	end
	else begin
		vif.bus_op <= BUS_WR;	
	end

	vif.bus_addr <= tr.addr;
	if(tr.bus_op == BUS_RD) begin
		vif.bus_wr_data <= 0;
	end
	else begin
		vif.bus_wr_data <= tr.wr_data;	
	end
	
	@(posedge vif.clk);
	vif.bus_cmd_valid <= 1'b0;
	vif.bus_op <= 1'b0;
	vif.bus_addr <= 16'b0;
	vif.bus_wr_data <= 16'b0;

	@(posedge vif.clk);
	if(tr.bus_op == BUS_RD) begin
		tr.rd_data <= vif.bus_rd_data;
		$display("@%0t, rd_data is %0h", $time, tr.rd_data);
	end
	`uvm_info("bus_driver", "end drive one pkt", UVM_LOW);
endtask

`endif
