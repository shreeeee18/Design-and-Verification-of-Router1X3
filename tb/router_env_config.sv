class router_env_config extends uvm_object;
	`uvm_object_utils(router_env_config)
	src_agent_config 	s_cfg[];
	dst_agent_config	d_cfg[];
	
	bit has_src_agent_top;
	bit has_dst_agent_top;
	bit has_scoreboard;	
	int no_of_src_agent;
	int no_of_dst_agent;
	//int count;
	
	extern function new (string name = "router_env_config");	
	//extern function void build_phase(uvm_phase phase);
endclass

	function router_env_config :: new(string name = "router_env_config");
		super.new(name);
	endfunction
	
	
