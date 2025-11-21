class src_agent_top extends uvm_env;
	
	`uvm_component_utils(src_agent_top)
		
	src_agent agt[];
	router_env_config e_cfg;
	
	extern function new (string name = "src_agent_top", uvm_component parent);

	extern function void build_phase(uvm_phase phase);
		
endclass

	function src_agent_top::new(string name = "src_agent_top", uvm_component parent);
		super.new(name, parent);
	endfunction

	function void src_agent_top::build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(router_env_config)::get(this, "sagt_top","router_env_config", e_cfg))
			`uvm_fatal("src_agent_top", "config_failed")
	agt=new[e_cfg.no_of_src_agent];
	foreach(agt[i])
		begin
			agt[i] = src_agent::type_id::create($sformatf("agt[%0d]", i), this);
			uvm_config_db #(src_agent_config)::set(this, "*","src_agent_config", e_cfg.s_cfg[i]);

		end
	endfunction	
