class dst_agent extends uvm_agent;
	
	`uvm_component_utils(dst_agent)
	dst_driver	drvh;
	dst_mon		monh;
	dst_seqr 	seqrh;	
	dst_agent_config d_cfg;	
	extern function new (string name = "dst_agent", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass

	function dst_agent::new (string name = "dst_agent", uvm_component parent);
		super.new(name, parent);
	endfunction

	function void dst_agent::build_phase(uvm_phase phase);
		super.build_phase(phase);
	
	if(!uvm_config_db #(dst_agent_config) :: get( this, "", "dst_agent_config", d_cfg))
		`uvm_fatal("dst_agent", "config falied")

	

	monh = dst_mon :: type_id :: create("monh", this);
	if(d_cfg.is_active)
		begin
			drvh = dst_driver :: type_id :: create("drvh", this);
			seqrh = dst_seqr :: type_id :: create("seqrh", this);
		end
endfunction

	function void dst_agent::connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		drvh.seq_item_port.connect(seqrh.seq_item_export);
	endfunction
