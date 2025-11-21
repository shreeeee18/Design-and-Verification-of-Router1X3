help:
	@echo
	@echo "========================== Makefile Help ==========================="
	@echo
	@echo "| Target      | Description                                       |"
	@echo "|-------------|---------------------------------------------------|"
	@echo "| cmp         | Compile the design and testbench                  |"
	@echo "| sim1        | Run the first simulation with coverage enabled    |"
	@echo "| sim2        | Run the second simulation with coverage enabled   |"
	@echo "| sim3        | Run the third simulation with coverage enabled    |"
	@echo "| view_wave1  | Open the waveform viewer for the first simulation |"
	@echo "| view_wave2  | Open the waveform viewer for the second simulation|"
	@echo "| view_wave3  | Open the waveform viewer for the third simulation |"
	@echo "| cov         | Open the coverage HTML report                     |"
	@echo "| clean       | Remove generated files                            |"
	@echo "| regress     | Run all simulations and generate reports          |"
	@echo
	@echo "===================================================================="

SIMULATOR = Questa

FSDB_PATH=/home/cad/eda/SYNOPSYS/VERDI_2022/verdi/T-2022.06-SP1/share/PLI/VCS/LINUX64

WORK = work
RTL = ../rtl/*
PKG = ../test/router_pkg.sv
INCDIR = +incdir+../test +incdir+../tb +incdir+../src_agt_top +incdir+../dst_agt_top
TOP = ../tb/router_tb_top.sv
VSIMOPT = -vopt -voptargs=+acc 
VSIMCOV= -coverage -sva
VSIMBATCH1= -c -do " log -r /* ;coverage save -onexit router_cov1;run -all; exit"
VSIMBATCH2= -c -do " log -r /* ;coverage save -onexit router_cov2;run -all; exit"
VSIMBATCH3= -c -do " log -r /* ;coverage save -onexit router_cov3;run -all; exit"
VSIMBATCH4= -c -do " log -r /* ;coverage save -onexit router_cov4;run -all; exit"

clean : clean_$(SIMULATOR)
cmp : cmp_$(SIMULATOR)
sim1 : sim1_$(SIMULATOR)
sim2 : sim2_$(SIMULATOR)
sim3 : sim3_$(SIMULATOR)
sim4 : sim4_$(SIMULATOR)
view_wave1 : view_wave1_$(SIMULATOR)
view_wave2 : view_wave2_$(SIMULATOR)
view_wave3 : view_wave3_$(SIMULATOR)
view_wave4 : view_wave4_$(SIMULATOR)
report : report_$(SIMULATOR)
regress : regress_$(SIMULATOR)
cov : cov_$(SIMULATOR)

# ----------------------------- Start of Definitions for Mentor's Questa Specific Targets -------------------------------#

cmp_Questa :
	@vlib $(WORK)
	@vmap work $(WORK) 
	@vlog $(RTL) $(PKG) $(TOP) $(INCDIR)

sim1_Questa : clean cmp
	@vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH1) -wlf wave_file1.wlf -l test1.log -sv_seed random work.router_tb_top +UVM_TESTNAME=sml_pkt_test
	@vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html router_cov1

sim2_Questa : cmp
	@vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH2) -wlf wave_file2.wlf -l test2.log -sv_seed random work.router_tb_top +UVM_TESTNAME=mdm_pkt_test
	@vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html router_cov2

sim3_Questa : clean cmp
	@vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH3) -wlf wave_file3.wlf -l test3.log -sv_seed random work.router_tb_top +UVM_TESTNAME=lrg_pkt_test
	@vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html router_cov3

sim4_Questa : clean cmp
	@vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH4) -wlf wave_file4.wlf -l test4.log -sv_seed random work.router_tb_top +UVM_TESTNAME=err_pkt_test
	@vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html router_cov4


view_wave1_Questa :
	@vsim -view wave_file1.wlf

view_wave2_Questa :
	@vsim -view wave_file2.wlf

view_wave3_Questa :
	@vsim -view wave_file3.wlf

view_wave4_Questa :
	@vsim -view wave_file4.wlf

report_Questa:
	@vcover merge router_cov1 router_cov2 router_cov3 router_cov4
	@vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html router_cov1

regress_Questa: sim1_Questa sim2_Questa sim3_Questa sim4_Questa report_Questa cov_Questa

cov_Questa:
	@cmd /c start covhtmlreport/index.html
	@firefox covhtmlreport/index.html &   # For Linux

clean_Questa:
	@rm -rf transcript* *log* fcover* covhtml* router_cov* *.wlf modelsim.ini work vsim*
	@clear

# ----------------------------- End of Definitions for Mentor's Questa Specific Targets -------------------------------#

# ----------------------------- Start of Definitions for Synopsys's VCS Specific Targets -------------------------------#

cmp_VCS:
	@vcs -l vcs.log -timescale=1ns/1ps -sverilog -ntb_opts uvm -debug_access+all -full64 -kdb  -lca -P $(FSDB_PATH)/novas.tab $(FSDB_PATH)/pli.a $(RTL) $(PKG) $(TOP) $(INCDIR)
		      
sim1_VCS: clean cmp_VCS
	@./simv -a vcs.log +fsdbfile+wave1.fsdb -cm_dir ./router_cov1 +ntb_random_seed_automatic +UVM_TESTNAME=sml_pkt_test
	@urg -dir router_cov1.vdb -format both -report urgReport1

sim2_VCS: clean cmp_VCS
	@./simv -a vcs.log +fsdbfile+wave2.fsdb -cm_dir ./router_cov2 +ntb_random_seed_automatic +UVM_TESTNAME=mdm_pkt_test
	@urg -dir router_cov2.vdb -format both -report urgReport2

sim3_VCS: clean cmp_VCS
	@./simv -a vcs.log +fsdbfile+wave3.fsdb -cm_dir ./router_cov3 +ntb_random_seed_automatic +UVM_TESTNAME=lrg_pkt_test
	@urg -dir router_cov3.vdb -format both -report urgReport3

view_wave1_VCS: 
	@verdi -ssf wave1.fsdb

view_wave2_VCS: 
	@verdi -ssf wave2.fsdb

view_wave3_VCS: 
	@verdi -ssf wave3.fsdb

report_VCS:
	@urg -dir router_cov1.vdb router_cov2.vdb router_cov3.vdb -dbname merged_dir/merged_test -format both -report urgReport

regress_VCS: cmp_VCS sim1_VCS sim2_VCS sim3_VCS report_VCS

cov_VCS:
	@verdi -cov -covdir merged_dir.vdb

clean_VCS:
	@rm -rf simv* csrc* *.tmp *.vpd *.vdb *.key *.log *hdrs.h urgReport* *.fsdb novas* verdi*
	@clear

# ----------------------------- END of Definitions for Synopsys's VCS Specific Targets -------------------------------#
