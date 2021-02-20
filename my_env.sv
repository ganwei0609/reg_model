`ifndef MY_ENV_SV
`define MY_ENV_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class my_env extends uvm_env;
	my_agent i_agt;
	my_agent o_agt;
	my_scoreboard scb;
	
	uvm_tlm_analysis_fifo #(my_transaction) agt_scb_fifo;

	extern function new(string name, uvm_component parent);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
	`uvm_component_utils(my_env);
endclass

function my_env::new(string name, uvm_component parent);
		super.new(name, parent);
endfunction

function void my_env::build_phase(uvm_phase phase);
	super.build_phase(phase);
	i_agt = my_agent::type_id::create("i_agt", this);
	o_agt = my_agent::type_id::create("o_agt", this);
	i_agt.is_active = UVM_ACTIVE;
	o_agt.is_active = UVM_ACTIVE;
	
	scb = my_scoreboard::type_id::create("scb", this);
	agt_scb_fifo = new("agt_scb_fifo", this);
endfunction

function void my_env::connect_phase(uvm_phase phase);
	super.build_phase(phase);
	o_agt.ap.connect(agt_scb_fifo.analysis_export);
	
endfunction
`endif

