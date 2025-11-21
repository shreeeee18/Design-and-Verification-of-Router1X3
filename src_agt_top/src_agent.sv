class src_agent extends uvm_agent;
	
	`uvm_component_utils(src_agent)
	src_driver	drvh;
	src_mon		monh;
	src_seqr 	seqrh;
	src_agent_config s_cfg;		
	extern function new (string name = "src_agent", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass

	function src_agent::new (string name = "src_agent", uvm_component parent);
		super.new(name, parent);
	endfunction

	function void src_agent::build_phase(uvm_phase phase);
		super.build_phase(phase);
	
	if(!uvm_config_db #(src_agent_config) :: get(this, "","src_agent_config",s_cfg))
		`uvm_fatal("src_agent", "config_failed")


	monh = src_mon :: type_id :: create("monh", this);
	if(s_cfg.is_active)
		begin
			drvh = src_driver :: type_id :: create("drvh", this);
			seqrh = src_seqr :: type_id :: create("seqrh", this);
		end
endfunction
	
	function void src_agent::connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		drvh.seq_item_port.connect(seqrh.seq_item_export);
	endfunction
