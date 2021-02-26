`ifndef BUS_MONITOR_SV
`define BUS_MONITOR_SV
class bus_monitor extends uvm_monitor;
	virtual bus_if vif;
	uvm_analysis_port #(bus_transaction) ap;
	`uvm_component_utils(bus_monitor)
	extern function new(string name = "uvm_monitor", uvm_component parent = null);
	extern function void build_phase(uvm_phase phase);
	extern task main_phase(uvm_phase phase);
	extern task collect_one_pkt(bus_transaction tr);
endclass
function bus_monitor::new(string name = "uvm_monitor", uvm_component parent = null);
	super.new(name, parent);
endfunction 

function void bus_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(virtual bus_if)::get(this, "", "vif", vif)) begin
		`uvm_fatal("bus_monitor", "get interface failed")
	end
	ap = new("ap", this);
	
endfunction
task bus_monitor::main_phase(uvm_phase phase);
	bus_transaction trans;
	while(!vif.rst_n)
		@(posedge vif.clk);	
	while(1) begin
		trans = new("trans");
		collect_one_pkt(trans);
		ap.write(trans);
	end
endtask
task bus_monitor::collect_one_pkt(bus_transaction tr);
	while(1) begin
		@(posedge vif.clk);
		if(vif.bus_cmd_valid != 1'b0) begin
			break;
		end
	end
	tr.bus_op = ((vif.bus_op == 0) ? BUS_RD : BUS_WR);
	tr.addr = vif.bus_addr;
	tr.wr_data = vif.bus_wr_data;
	@(posedge vif.clk);
	tr.rd_data = vif.bus_rd_data;
	`uvm_info("bus_monitor", "end collect one pkt", UVM_LOW)
endtask
`endif
