`ifndef MY_SCOREBOARD_SV
`define MY_SCOREBOARD_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class my_scoreboard extends uvm_scoreboard;
	my_transaction expect_queue[$];
	uvm_blocking_get_port #(my_transaction) exp_port;
	uvm_blocking_get_port #(my_transaction) act_port;
	`uvm_component_utils(my_scoreboard)
	
	extern function new(string name, uvm_component parent = null);
	extern function void build_phase(uvm_phase phase);
	extern virtual task main_phase(uvm_phase phase);
	
endclass

function my_scoreboard::new(string name, uvm_component parent = null);
	super.new(name, parent);
endfunction

function void my_scoreboard::build_phase(uvm_phase phase);
	super.build_phase(phase);
	exp_port = new("exp_port", this);
	act_port = new("act_port", this);
endfunction

task my_scoreboard::main_phase(uvm_phase phase);
	my_transaction get_expect, get_actual, tmp_tran;
	bit result;
	fork 
		while(1) begin
			exp_port.get(get_expect);
			expect_queue.push_back(get_expect);
		end

		while(1) begin
			act_port.get(get_actual);
			if(expect_queue.size() > 0) begin
				tmp_tran = expect_queue.pop_front();
				result = get_actual.compare(tmp_tran);
				if(result) begin
					`uvm_info("my_scoreboard", "compare successful", UVM_LOW);
				end
				else begin
					tmp_tran.print();
					get_actual.print();
					`uvm_fatal("my_scoreboard", "compare failed");					
				end
			end
			else begin
				`uvm_error("my_scoreboard", "recieve from dut, while expect_queue is empty");
			end
		
		end
	join
endtask

`endif