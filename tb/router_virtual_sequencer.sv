class router_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);	
	`uvm_component_utils(router_virtual_sequencer)
	src_seqr src_seqrh[];
	dst_seqr dst_seqrh[];
	
	router_env_config e_cfg;	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(router_env_config) ::get(this, "", "router_env_config", e_cfg))
			`uvm_fatal(get_full_name(), "config failed")

		
		src_seqrh = new[e_cfg.no_of_src_agent];
		dst_seqrh = new[e_cfg.no_of_dst_agent];
	endfunction

extern function new (string name = "router_virtual_sequencer", uvm_component parent);
endclass

	function router_virtual_sequencer::new (string name = "router_virtual_sequencer", uvm_component parent);
		super.new(name, parent);
	endfunction
	
	

