#-------------------------------------------------------------------------------------------------------
comp  : clean vcs
#-------------------------------------------------------------------------------------------------------
vcs   :
	vcs  \
              -timescale=1ns/1ps \
              -debug_all -debug_acc+dmptf -debug_region+cell+encrypt -full64  -R  +vc  +v2k  -sverilog -LDFLAGS -Wl,--no-as-needed  \
              -cm line+tgl+cond+fsm+assert+branch \
			  +define+UVM_OBJECT_DO_NOT_NEED_CONSTRUCTOR +define+SVT_UVM_12_OR_HIGHER +define+UVM_NO_DEPRECATED +UVM_TESTNAME=my_case0 -P ${LD_LIBRARY_PATH}/novas.tab  ${LD_LIBRARY_PATH}/pli.a -l vcs.log -ntb_opts uvm-1.2 -timescale=1ns/1ps -f vcs.conf 
##+UVM_OBJECTION_TRACE +UVM_CONFIG_DB_TRACE 			  
#-------------------------------------------------------------------------------------------------------
verdi  :
	verdi -f vcs.conf -ssf tb_auto_000.fsdb -f filelist.f &
#-------------------------------------------------------------------------------------------------------
clean  :
	 rm  -rf csrc simv* ucli.key *.log  novas.* *.fsdb* verdiLog
#-------------------------------------------------------------------------------------------------------
