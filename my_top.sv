`ifndef MY_TOP_SV
`define MY_TOP_SV

module test_top;
	bit SystemClock;
	bit reset;
	my_if input_if(SystemClock, reset);
	my_if output_if(SystemClock, reset);
	bus_if b_if(SystemClock, reset);

	
	my_dut dut(
		.clk				(SystemClock), 
		.rst_n				(reset), 
		.bus_cmd_valid		(b_if.bus_cmd_valid), 
		.bus_op				(b_if.bus_op), 
		.bus_addr			(b_if.bus_addr), 
		.bus_wr_data		(b_if.bus_wr_data), 
		.bus_rd_data		(b_if.bus_rd_data), 
		.rxd				(input_if.rxd), 
		.rx_dv				(input_if.rx_dv), 
		.txd				(output_if.txd), 
		.tx_en				(output_if.tx_en)
	);

	
	initial begin
		SystemClock = 1'b0;
		forever begin
			#100;
			SystemClock = ~SystemClock;
		end

	end
	initial begin
		reset = 1'b0;
		repeat(10) @(posedge SystemClock);
		reset = 1'b1;
	end	
	initial begin                                 
		uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.env.i_agt.drv", "vif", input_if);
		uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.env.i_agt.mon", "vif", input_if);
		uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.env.o_agt.mon", "vif", output_if);
		uvm_config_db#(virtual bus_if)::set(null, "uvm_test_top.env.bus_agt.drv", "vif", b_if);
		uvm_config_db#(virtual bus_if)::set(null, "uvm_test_top.env.bus_agt.mon", "vif", b_if);		
		
	end
	
	initial begin 
		run_test();
	end
	
	initial begin
		$display("test start!\n");
		#200ms;
		$display("test finished!\n");
	end

	initial begin
		$fsdbAutoSwitchDumpfile(4096, "tb_auto.fsdb", 200);
		$fsdbDumpvars(0, test_top, "+mda");
		$fsdbDumpvars(0, test_top, "+all");
		$fsdbDumpvars(0, test_top);
		$fsdbDumpon;
	end

endmodule
`endif
