class router_tb extends uvm_env;
	`uvm_component_utils(router_tb)
	src_agent_top sagt_top;
	dst_agent_top dagt_top;
	router_scoreboard sb_h;
	router_env_config e_cfg;
	
	router_virtual_sequencer v_seqrh;
	
	extern function new (string name = "router_tb", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		foreach(v_seqrh.src_seqrh[i])
			v_seqrh.src_seqrh[i] = sagt_top.agt[i].seqrh;
		foreach(v_seqrh.dst_seqrh[i])
			v_seqrh.dst_seqrh[i] = dagt_top.agt[i].seqrh;
		
		foreach(sagt_top.agt[i])
			sagt_top.agt[i].monh.src_mon2sb.connect(sb_h.s_fifoh[i].analysis_export);
		foreach(dagt_top.agt[i])
			dagt_top.agt[i].monh.dst_mon2sb.connect(sb_h.d_fifoh[i].analysis_export);
		
	endfunction
	
endclass

	function router_tb::new (string name = "router_tb", uvm_component parent);
		super.new(name, parent);	
	endfunction

	function void router_tb::build_phase(uvm_phase phase);	
		super.build_phase(phase);
	if(!uvm_config_db #(router_env_config) :: get(this, "","router_env_config", e_cfg))
		`uvm_fatal("router_env", "config failed")
	

		if(e_cfg.has_src_agent_top)
		sagt_top = src_agent_top::type_id::create("sagt_top", this);
		if(e_cfg.has_dst_agent_top)
		dagt_top = dst_agent_top::type_id::create("dagt_top", this);

		if(e_cfg.has_scoreboard)
		sb_h = router_scoreboard::type_id::create("sb_h", this);


		v_seqrh = router_virtual_sequencer::type_id::create("v_seqrh", this);
	
		uvm_config_db #(router_env_config) :: set(this, "sagt_top","router_env_config", e_cfg);
		uvm_config_db #(router_env_config) :: set(this, "dagt_top","router_env_config", e_cfg);
	endfunction
	
	
	
