class router_virtual_sequence extends uvm_sequence #(uvm_sequence_item);
	`uvm_object_utils(router_virtual_sequence)
	
	router_virtual_sequencer v_seqrh;
	src_seqr src_seqrh[];
	dst_seqr dst_seqrh[];
	router_env_config e_cfg;
	

	function new(string name = "router_virtual_sequence");
		super.new(name);
	endfunction
	
	task body();
		if(!uvm_config_db #(router_env_config) ::get(null, get_full_name, "router_env_config", e_cfg))
			`uvm_fatal(get_full_name(), "config failed")

		if(!$cast(v_seqrh, m_sequencer))
			`uvm_fatal(get_full_name(), "casting failed")
		
		src_seqrh = new[e_cfg.no_of_src_agent];
		dst_seqrh = new[e_cfg.no_of_dst_agent];
	
		foreach(src_seqrh[i])	
		src_seqrh[i] = v_seqrh.src_seqrh[i];
		foreach(dst_seqrh[i])	
		dst_seqrh[i] = v_seqrh.dst_seqrh[i];
	endtask
endclass
	

	//small pkt v seqs
	class small_pkt_vseqs  extends router_virtual_sequence;
	`uvm_object_utils(small_pkt_vseqs)
	
	function new (string name = "small_pkt_vseqs");
		super.new(name);
	endfunction

		sml_pkt_seqs sml_pkt_seqsh;
		clk_cnt_lt_30 clk_cnt_lt_30h;

	task body();
		bit [1:0] addr;
		if(!uvm_config_db #(bit[1:0])::get(null, get_full_name, "bit[1:0]", addr))
	  		  `uvm_fatal("src sml seqs", "config failed")

		super.body();
			sml_pkt_seqsh = sml_pkt_seqs::type_id::create("sml_pkt_seqsh");
			clk_cnt_lt_30h = clk_cnt_lt_30::type_id::create("clk_cnt_lt_30h");
	//if(!uvm_config_db #(bit[1:0])::get(null, get_full_name, "bit[1:0]", addr))
	  //		  `uvm_fatal("src sml seqs", "config failed")
			
			fork 	
				sml_pkt_seqsh.start(src_seqrh[0]);
				clk_cnt_lt_30h.start(dst_seqrh[addr]);
			join
	endtask
	endclass

	//medium pkt seqs	
	class medium_pkt_vseqs  extends router_virtual_sequence;
	`uvm_object_utils(medium_pkt_vseqs)
	
	function new (string name = "medium_pkt_vseqs");
		super.new(name);
	endfunction

		mdm_pkt_seqs mdm_pkt_seqsh;
		clk_cnt_lt_30 clk_cnt_lt_30h;

	task body();
	bit [1:0] addr;
		super.body();
			if(!uvm_config_db #(bit[1:0])::get(null, get_full_name, "bit[1:0]", addr))
	  		  `uvm_fatal("src mdm seqs", "config failed")
			mdm_pkt_seqsh = mdm_pkt_seqs::type_id::create("mdm_pkt_seqsh");
			clk_cnt_lt_30h = clk_cnt_lt_30::type_id::create("clk_cnt_lt_30h");

			fork 	
				mdm_pkt_seqsh.start(src_seqrh[0]);
				clk_cnt_lt_30h.start(dst_seqrh[addr]);
			join
	endtask
	endclass

	//large pkt v seqs
	class large_pkt_vseqs  extends router_virtual_sequence;
	`uvm_object_utils(large_pkt_vseqs)
	
	function new (string name = "large_pkt_vseqs");
		super.new(name);
	endfunction

		lrg_pkt_seqs lrg_pkt_seqsh;
		clk_cnt_lt_30 clk_cnt_lt_30h;

	task body();
	bit [1:0] addr;
		super.body();
			if(!uvm_config_db #(bit[1:0])::get(null, get_full_name, "bit[1:0]", addr))
	  		  `uvm_fatal("src large seqs", "config failed")
			lrg_pkt_seqsh = lrg_pkt_seqs::type_id::create("lrg_pkt_seqsh");
			clk_cnt_lt_30h = clk_cnt_lt_30::type_id::create("clk_cnt_lt_30h");
			fork 	
				lrg_pkt_seqsh.start(src_seqrh[0]);
				clk_cnt_lt_30h.start(dst_seqrh[addr]);
			join
	endtask
	endclass

	//err pkt v seqs
	class error_pkt_vseqs  extends router_virtual_sequence;
	`uvm_object_utils(error_pkt_vseqs)
	
	function new (string name = "err_pkt_vseqs");
		super.new(name);
	endfunction

		err_pkt_seqs err_pkt_seqsh;
		clk_cnt_lt_30 clk_cnt_lt_30h;

	task body();
	bit [1:0] addr;
		super.body();
			if(!uvm_config_db #(bit[1:0])::get(null, get_full_name, "bit[1:0]", addr))
	  		  `uvm_fatal("src err seqs", "config failed")
			err_pkt_seqsh = err_pkt_seqs::type_id::create("err_pkt_seqsh");
			clk_cnt_lt_30h = clk_cnt_lt_30::type_id::create("clk_cnt_lt_30h");
			fork 	
				err_pkt_seqsh.start(src_seqrh[0]);
				clk_cnt_lt_30h.start(dst_seqrh[addr]);
			join
	endtask
	endclass

		
	
	
