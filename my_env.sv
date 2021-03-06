`ifndef MY_ENV_SV
`define MY_ENV_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class my_env extends uvm_env;
	my_agent i_agt;
	my_agent o_agt;
	bus_agent bus_agt;
	my_scoreboard scb;
	my_model mdl;
	my_cov cov;
	ral_block_ganwei_reg_map p_rm;
	uvm_tlm_analysis_fifo #(my_transaction) i_agt_mdl_fifo;
	uvm_tlm_analysis_fifo #(my_transaction) mdl_scb_fifo;
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
	i_agt.is_active = UVM_ACTIVE;
	o_agt = my_agent::type_id::create("o_agt", this);
	o_agt.is_active = UVM_PASSIVE;
	bus_agt = bus_agent::type_id::create("bus_agt", this);
	bus_agt.is_active = UVM_ACTIVE;
	
	scb = my_scoreboard::type_id::create("scb", this);
	mdl = my_model::type_id::create("mdl", this);
	cov = my_cov::type_id::create("cov", this);
	
	i_agt_mdl_fifo = new("i_agt_mdl_fifo", this);
	mdl_scb_fifo = new("mdl_scb_fifo", this);
	o_agt_scb_fifo = new("o_agt_scb_fifo", this);
		
endfunction

function void my_env::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	i_agt.ap.connect(i_agt_mdl_fifo.analysis_export);
	mdl.in_port.connect(i_agt_mdl_fifo.blocking_get_export);
	
	mdl.out_port.connect(mdl_scb_fifo.analysis_export);	
	scb.exp_port.connect(mdl_scb_fifo.blocking_get_export);
	
	o_agt.ap.connect(o_agt_scb_fifo.analysis_export);
	scb.act_port.connect(o_agt_scb_fifo.blocking_get_export);
	
	mdl.p_rm = this.p_rm;
	//i_agt.ap.connect(scb.exp_port);
	//o_agt.ap.connect(scb.act_port);
	
endfunction
`endif

