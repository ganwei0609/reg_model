`ifndef MY_SCOREBOARD_SV
`define MY_SCOREBOARD_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
//`uvm_analysis_imp_decl(_i_agt)
//`uvm_analysis_imp_decl(_o_agt)
class my_scoreboard extends uvm_scoreboard;
	my_transaction expect_queue[$];
	uvm_blocking_get_port #(my_transaction) exp_port;
	uvm_blocking_get_port #(my_transaction) act_port;
	//uvm_analysis_imp_i_agt#(my_transaction, my_scoreboard) exp_port;	
	//uvm_analysis_imp_o_agt#(my_transaction, my_scoreboard) act_port;	
	
	`uvm_component_utils(my_scoreboard)
	
	extern function new(string name, uvm_component parent = null);
	extern function void build_phase(uvm_phase phase);
	extern virtual task main_phase(uvm_phase phase);
	//extern function void write_i_agt(my_transaction tr);	
	//extern function void write_o_agt(my_transaction tr);	
endclass
//function void my_scoreboard::write_i_agt(my_transaction tr);
//	`uvm_info("my_scoreboard", "write_i_agt", UVM_LOW);	
//	tr.print();
//endfunction
//function void my_scoreboard::write_o_agt(my_transaction tr);
//	`uvm_info("my_scoreboard", "write_o_agt", UVM_LOW);	
//	tr.print();	
//endfunction

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
	super.main_phase(phase);
	`uvm_info("my_scoreboard", $sformatf("path=%s", get_full_name()), UVM_LOW);
	fork 
		repeat(10) begin
			#100ms;
			`uvm_info("my_scoreboard", $sformatf("path=%s, size = %d", get_full_name(), exp_port.size()), UVM_LOW);
		end
		while(1) begin
			exp_port.get(get_expect);
			`uvm_info("my_scoreboard", "get_expect", UVM_LOW);			
			expect_queue.push_back(get_expect);
			`uvm_info("my_scoreboard", "get_expect", UVM_LOW);
		end

		while(1) begin
			act_port.get(get_actual);
			`uvm_info("my_scoreboard", $sformatf("size=%d", expect_queue.size()), UVM_LOW);
			if(expect_queue.size() > 0) begin
				tmp_tran = expect_queue.pop_front();
				`uvm_info("my_scoreboard", $sformatf("path=%s", get_full_name()), UVM_LOW);
				get_actual.print();
				tmp_tran.print();
				result = get_actual.compare(tmp_tran);
				if(result) begin
					`uvm_info("my_scoreboard", "compare successful", UVM_LOW);
				end
				else begin
					`uvm_info("my_scoreboard", $sformatf("path=%s", get_full_name()), UVM_LOW);
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