#-------------------------------------------------------------------------------------------------------
comp  : clean vcs
#-------------------------------------------------------------------------------------------------------
vcs   :
	vcs  \
              -timescale=1ns/1ps \
              -fsdb  -full64  -R  +vc  +v2k  -sverilog  -debug_acc+dmptf -debug_region+cell+encrypt -LDFLAGS -Wl,--no-as-needed  \
              +UVM_OBJECTION_TRACE +UVM_CONFIG_DB_TRACE +UVM_TESTNAME=my_case0 -P ${LD_LIBRARY_PATH}/novas.tab  ${LD_LIBRARY_PATH}/pli.a -l vcs.log -ntb_opts uvm-1.2 -timescale=1ns/1ps -f vcs.conf 
#-------------------------------------------------------------------------------------------------------
verdi  :
	verdi -f vcs.conf -ssf tb_auto_000.fsdb -f filelist.f &
#-------------------------------------------------------------------------------------------------------
clean  :
	 rm  -rf  *~  core  csrc  simv*  vc_hdrs.h  ucli.key  urg* *.log  novas.* *.fsdb* verdiLog  64* DVEfiles *.vpd
#-------------------------------------------------------------------------------------------------------
