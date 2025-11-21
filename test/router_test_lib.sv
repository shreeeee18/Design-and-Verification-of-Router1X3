class router_test_lib extends uvm_test;
	
	`uvm_component_utils(router_test_lib)
	
	src_agent_config s_cfg[];
	dst_agent_config d_cfg[];
	router_env_config e_cfg;
	router_tb envh;
	
	bit has_src_agent_top = 1;
	bit has_dst_agent_top = 1;
	bit has_scoreboard = 1;	
	int no_of_src_agent = 1;
	int no_of_dst_agent = 3;
	int count = 100;
		
	extern function new (string name = "router_test_lib", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void start_of_simulation_phase(uvm_phase phase);
endclass

	function router_test_lib::new(string name = "router_test_lib", uvm_component parent);
		super.new(name, parent);
	endfunction

	function void router_test_lib::build_phase(uvm_phase phase);
		super.build_phase(phase);
		e_cfg = router_env_config :: type_id :: create("e_cfg");
			e_cfg.has_src_agent_top = has_src_agent_top;
			e_cfg.has_dst_agent_top = has_dst_agent_top;
			e_cfg.has_scoreboard = has_scoreboard;	
			e_cfg.no_of_src_agent = no_of_src_agent;
			e_cfg.no_of_dst_agent = no_of_dst_agent;
			//e_cfg.count = count;
	s_cfg = new[no_of_src_agent];
	e_cfg.s_cfg = new [no_of_src_agent];
	foreach(s_cfg[i])
		begin
		s_cfg[i] = src_agent_config::type_id::create($sformatf("s_cfg[%0d]", i));
		if(!uvm_config_db #(virtual router_if )::get(this, "", $sformatf("src_in%0d", i),s_cfg[i].vif))
			`uvm_fatal("test_lib", "config failed")
		s_cfg[i].is_active  = UVM_ACTIVE;
		e_cfg.s_cfg[i] = s_cfg[i];  
		end

	d_cfg = new[no_of_dst_agent];
	e_cfg.d_cfg = new [no_of_dst_agent];
	foreach(d_cfg[i])
		begin
		d_cfg[i] = dst_agent_config::type_id::create($sformatf("d_cfg[%0d]", i));
		if(!uvm_config_db #(virtual router_if )::get(this, "", $sformatf("dst_in%0d", i),d_cfg[i].vif))
			`uvm_fatal("test_lib", "config failed")
		d_cfg[i].is_active  = UVM_ACTIVE;
		e_cfg.d_cfg[i] = d_cfg[i];  
		end

	uvm_config_db #(router_env_config) :: set (this, "*", "router_env_config", e_cfg);


	envh =  router_tb::type_id::create("envh", this);
	
	
	endfunction 
		
	function void router_test_lib::start_of_simulation_phase(uvm_phase phase);
		super.start_of_simulation_phase(phase);
		uvm_top.print_topology;
	endfunction

//small packet test 
	class sml_pkt_test extends router_test_lib;
			  //sml_pkt_seqs sml_pkt_seqsh;
			  //clk_cnt_lt_30 clk_cnt_lt_30h;
			  //clk_cnt_gt_30 clk_cnt_gt_30h;
			small_pkt_vseqs small_pkt_vseqsh;

			  `uvm_component_utils(sml_pkt_test)
			  bit [1:0] addr;
			  extern function new (string name = "sml_pkt_test", uvm_component parent);
			  extern task run_phase(uvm_phase phase);
			  extern function void build_phase(uvm_phase phase);

	endclass
		
		function sml_pkt_test:: new (string name = "sml_pkt_test", uvm_component parent);
			super.new(name, parent);
		endfunction

		function void sml_pkt_test::build_phase(uvm_phase phase);
				  super.build_phase(phase);
		endfunction

		task sml_pkt_test::run_phase(uvm_phase phase);
		repeat(count)
 			begin
				small_pkt_vseqsh = small_pkt_vseqs::type_id::create("small_pkt_vseqsh");
				//sml_pkt_seqsh = sml_pkt_seqs::type_id::create("sml_pkt_seqsh");
				//clk_cnt_lt_30h = clk_cnt_lt_30::type_id::create("clk_cnt_lt_30h");
				//clk_cnt_gt_30h = clk_cnt_gt_30::type_id::create("clk_cnt_gt_30h");
				addr = {$random} %3;
				uvm_config_db #(bit[1:0])::set(this, "*", "bit[1:0]", addr);
				phase.raise_objection(this);
				//fork
				//	sml_pkt_seqsh.start(envh.sagt_top.agt[0].seqrh);
				//	clk_cnt_lt_30h.start(envh.dagt_top.agt[addr].seqrh);
					//clk_cnt_gt_30h.start(envh.dagt_top.agt[addr].seqrh);
				//join
				small_pkt_vseqsh.start(envh.v_seqrh);
				#60;
				phase.drop_objection(this); 
 			end
		endtask

//medium packet test

	class mdm_pkt_test extends router_test_lib;

			  //mdm_pkt_seqs mdm_pkt_seqsh;
			  //clk_cnt_lt_30 clk_cnt_lt_30h;
			  medium_pkt_vseqs medium_pkt_vseqsh;

			  `uvm_component_utils(mdm_pkt_test)

			  bit [1:0] addr;
			  extern function new (string name = "mdm_pkt_test", uvm_component parent);
			  extern task run_phase(uvm_phase phase);
			  extern function void build_phase(uvm_phase phase);

	endclass
		
		function mdm_pkt_test:: new (string name = "mdm_pkt_test", uvm_component parent);
			super.new(name, parent);
		endfunction

		function void mdm_pkt_test::build_phase(uvm_phase phase);
				  super.build_phase(phase);
		endfunction

		task mdm_pkt_test::run_phase(uvm_phase phase);
			repeat(count)
				begin
					//mdm_pkt_seqsh = mdm_pkt_seqs::type_id::create("mdm_pkt_seqsh");
					//clk_cnt_lt_30h = clk_cnt_lt_30::type_id::create("clk_cnt_lt_30h");
					medium_pkt_vseqsh = medium_pkt_vseqs::type_id::create("medium_pkt_vseqs");
					addr = {$random} %3;
					uvm_config_db #(bit[1:0])::set(this, "*", "bit[1:0]", addr);
					phase.raise_objection(this);
						//fork
						//	mdm_pkt_seqsh.start(envh.sagt_top.agt[0].seqrh);
						//	clk_cnt_lt_30h.start(envh.dagt_top.agt[addr].seqrh);
						//join
					medium_pkt_vseqsh.start(envh.v_seqrh);
					#60;
					phase.drop_objection(this); end
		endtask

//large packet 
class lrg_pkt_test extends router_test_lib;
			large_pkt_vseqs large_pkt_vseqsh;
			  lrg_pkt_seqs lrg_pkt_seqsh;
			  clk_cnt_lt_30 clk_cnt_lt_30h;
			  `uvm_component_utils(lrg_pkt_test)
			  bit [1:0] addr;
			  extern function new (string name = "lrg_pkt_test", uvm_component parent);
			  extern task run_phase(uvm_phase phase);
			  extern function void build_phase(uvm_phase phase);

	endclass
		
		function lrg_pkt_test:: new (string name = "lrg_pkt_test", uvm_component parent);
			super.new(name, parent);
		endfunction

		function void lrg_pkt_test::build_phase(uvm_phase phase);
				  super.build_phase(phase);
		endfunction

		task lrg_pkt_test::run_phase(uvm_phase phase);
			repeat(count) 
				begin
					//lrg_pkt_seqsh = lrg_pkt_seqs::type_id::create("lrg_pkt_seqsh");
					//clk_cnt_lt_30h = clk_cnt_lt_30::type_id::create("clk_cnt_lt_30h");
				large_pkt_vseqsh = large_pkt_vseqs::type_id::create("large_pkt_vseqs");

					addr = {$random} %3;
					uvm_config_db #(bit[1:0])::set(this, "*", "bit[1:0]", addr);
					phase.raise_objection(this);
						//fork
							//lrg_pkt_seqsh.start(envh.sagt_top.agt[0].seqrh);
							//clk_cnt_lt_30h.start(envh.dagt_top.agt[addr].seqrh);
						//join
					large_pkt_vseqsh.start(envh.v_seqrh);
					#60;
					phase.drop_objection(this); 
	 			end
		endtask

// error packet test
class err_pkt_test extends router_test_lib;
			  //err_pkt_seqs err_pkt_seqsh;
			  //clk_cnt_lt_30 clk_cnt_lt_30h;
			  error_pkt_vseqs error_pkt_vseqsh;
			  `uvm_component_utils(err_pkt_test)
			  bit [1:0] addr;
			  extern function new (string name = "err_pkt_test", uvm_component parent);
			  extern task run_phase(uvm_phase phase);
			  extern function void build_phase(uvm_phase phase);

	endclass
		
		function err_pkt_test:: new (string name = "err_pkt_test", uvm_component parent);
			super.new(name, parent);
		endfunction

		function void err_pkt_test::build_phase(uvm_phase phase);
				  super.build_phase(phase);
		endfunction

		task err_pkt_test::run_phase(uvm_phase phase);
			repeat(count)
 				begin
					//err_pkt_seqsh = err_pkt_seqs::type_id::create("err_pkt_seqsh");
					//clk_cnt_lt_30h = clk_cnt_lt_30::type_id::create("clk_cnt_lt_30h");
					error_pkt_vseqsh = error_pkt_vseqs::type_id::create("error_pkt_vseqsh");
					addr = {$random} %3;
					uvm_config_db #(bit[1:0])::set(this, "*", "bit[1:0]", addr);
					phase.raise_objection(this);
						//fork
							//err_pkt_seqsh.start(envh.sagt_top.agt[0].seqrh);
							//clk_cnt_lt_30h.start(envh.dagt_top.agt[addr].seqrh);
						//join
					error_pkt_vseqsh.start(envh.v_seqrh);
					#60;
					phase.drop_objection(this); end
		endtask



