`ifndef MY_TOP_SV
`define MY_TOP_SV

module test_top;
	bit SystemClock;
	bit reset;
	my_if my_dut_if();
	
	my_dut dut(
		.clk				(my_dut_if.clk), 
		.rst_n				(my_dut_if.rst_n), 
		.bus_cmd_valid		(my_dut_if.bus_cmd_valid), 
		.bus_op				(my_dut_if.bus_op), 
		.bus_addr			(my_dut_if.bus_addr), 
		.bus_wr_data		(my_dut_if.bus_wr_data), 
		.bus_rd_data		(my_dut_if.bus_rd_data), 
		.rxd				(my_dut_if.rxd), 
		.rx_dv				(my_dut_if.rx_dv), 
		.txd				(my_dut_if.txd), 
		.tx_en				(my_dut_if.tx_en)
	);
	assign my_dut_if.clk = SystemClock;
	assign my_dut_if.rst_n = reset;
	
	initial begin
		SystemClock = 1'b0;
		forever begin
			#100;
			SystemClock = ~SystemClock;
		end

	end
	
	initial begin                                 
		uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.env.i_agt.drv", "vif", my_dut_if);
		uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.env.i_agt.mon", "vif", my_dut_if);
		uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.env.o_agt.mon", "vif", my_dut_if);
	end
	
	initial begin 
		run_test();
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
