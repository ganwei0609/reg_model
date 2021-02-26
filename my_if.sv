`ifndef MY_IF_SV
`define MY_IF_SV

interface my_if(input clk, input rst_n);
	logic bus_cmd_valid;
	logic bus_op;
	logic[15:0] bus_addr;
	logic[15:0] bus_wr_data;
	logic[15:0] bus_rd_data;
	logic[7:0] rxd;
	logic rx_dv;
	logic[7:0] txd;
	logic tx_en;
endinterface
`endif