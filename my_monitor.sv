`ifndef MY_MONITOR_SV
`define MY_MONITOR_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
class my_monitor extends uvm_monitor;
	virtual my_if vif;
	uvm_analysis_port #(my_transaction) ap;

	extern function new(string name, uvm_component parent);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual task main_phase(uvm_phase phase);
	extern task receive_one_pkt(ref my_transaction get_pkt);
	`uvm_component_utils(my_monitor)
endclass

function my_monitor::new(string name, uvm_component parent);
	super.new(name, parent);
endfunction

function void my_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(virtual my_if)::get(this, "", "vif", vif)) begin
		`uvm_fatal("my_monitor", "get interface failed")
	end
	ap = new("ap", this);
endfunction

task my_monitor::main_phase(uvm_phase phase);
	logic valid;
	logic[7:0] data;
	my_transaction tr;
	super.main_phase(phase);
	while(1) begin
		tr = new();
		receive_one_pkt(tr);
		`uvm_info("my_monitor", $sformatf("path=%s", get_full_name()), UVM_LOW);		
		ap.write(tr);
	end
endtask

task my_monitor::receive_one_pkt(ref my_transaction get_pkt);
	while(1) begin
		repeat(1) @(posedge vif.clk);
		if(vif.bus_cmd_valid == 1) begin
			if(vif.bus_op == BUS_RD) begin
				get_pkt.bus_op = BUS_RD;		
			end
			else begin
				get_pkt.bus_op = BUS_WR;		
			end
	
			get_pkt.addr = vif.bus_addr;
			if(vif.bus_op == BUS_RD) begin
				@(posedge vif.clk);
				get_pkt.rd_data = vif.bus_rd_data;
			end
			else begin
				get_pkt.wr_data = vif.bus_wr_data;
			end
			`uvm_info("my_monitor", "end recieve one pkt", UVM_LOW);
			break;
		end
	end
endtask
`endif