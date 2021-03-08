/*================================================================
*   Copyright (C) 2021 IEucd Inc. All rights reserved.
*   
*   文件名称：my_cov.sv
*   创 建 者：Artosyn ganwei0609@126.com
*   创建日期：2021年03月07日
*   描    述：
*
================================================================*/
`ifndef __MY_COV_SV__
`define __MY_COV_SV__
class my_cov extends uvm_component;
	covergroup cov_counter_grp with function sample(int unsigned counter);
		COUNTER_LOW	: coverpoint counter[15:0] {
			bins counter_low[100] = {[0 : ((2**16) - 1)]};
		}
		COUNTER_HIGH : coverpoint counter[31:16] { 
			bins counter_high[100] = {[(2**16) : ((2**32) - 1)]};
		}
	endgroup
	
	covergroup cov_invert_grp with function sample(bit invert);
		INVERT : coverpoint invert{
			bins invert[2] = {0, 1};
		}
	endgroup
	extern function new(string name = "my_cov", uvm_component parent = null);
	`uvm_component_utils(my_cov)
endclass

function my_cov::new(string name = "my_cov", uvm_component parent = null);
	super.new(name, parent);
	cov_counter_grp = new();
	cov_invert_grp = new();
endfunction
`endif
