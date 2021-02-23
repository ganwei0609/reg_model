`ifndef MY_ENV_SV
`define MY_ENV_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class my_env extends uvm_env;
	my_agent i_agt;
	my_agent o_agt;
	my_scoreboard scb;
	
	uvm_tlm_analysis_fifo #(my_transaction) i_agt_scb_fifo;
	uvm_tlm_analysis_fifo #(my_transaction) o_agt_scb_fifo;

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
	o_agt.is_active = UVM_PASSIVE;
	
	scb = my_scoreboard::type_id::create("scb", this);
	i_agt_scb_fifo = new("i_agt_scb_fifo", this);
	o_agt_scb_fifo = new("o_agt_scb_fifo", this);
	
endfunction

function void my_env::connect_phase(uvm_phase phase);
	super.build_phase(phase);
	uvm_top.print_topology();
	i_agt.ap.connect(i_agt_scb_fifo.analysis_export);
	scb.exp_port.connect(i_agt_scb_fifo.blocking_get_export);	
	o_agt.ap.connect(o_agt_scb_fifo.analysis_export);
	scb.act_port.connect(o_agt_scb_fifo.blocking_get_export);
	//i_agt.ap.connect(scb.exp_port);
	//o_agt.ap.connect(scb.act_port);
	
endfunction
`endif

