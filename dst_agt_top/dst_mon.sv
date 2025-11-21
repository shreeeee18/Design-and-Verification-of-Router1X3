class dst_mon extends uvm_monitor;	
	
	`uvm_component_utils(dst_mon);
		
	virtual router_if.DST_MON_MP vif;
		
	dst_agent_config d_cfg;
	
	uvm_analysis_port #(dst_xtn) dst_mon2sb;
			
	extern function new (string name = "dst_mon", uvm_component parent);
			
	extern function void connect_phase(uvm_phase phase);	

	extern task run_phase (uvm_phase phase);
		
	extern task collect_data();
endclass
	
	function dst_mon:: new (string name = "dst_mon", uvm_component parent);
		super.new(name, parent);
		dst_mon2sb = new("dst_mon2sb", this);
	endfunction
		
	function void dst_mon::connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if (!uvm_config_db#(dst_agent_config)::get(this, "", "dst_agent_config", d_cfg))
    			`uvm_fatal("DST_DRIVER", "GET failed")

  		vif = d_cfg.vif;
	endfunction

	task dst_mon::run_phase(uvm_phase phase);
		forever
			collect_data();
	endtask

	task dst_mon::collect_data();
		dst_xtn dst_monitor;
		dst_monitor = dst_xtn::type_id::create("dst_monitor");
		
		while(vif.dst_mon_cb.rd_enb !== 1)
			@(vif.dst_mon_cb);
			@(vif.dst_mon_cb);
			
		dst_monitor.header = vif.dst_mon_cb.data_out;
		dst_monitor.payload = new[dst_monitor.header[7:2]];	
			@(vif.dst_mon_cb);

		foreach(dst_monitor.payload[i])
			begin
		
				while(vif.dst_mon_cb.rd_enb !== 1)
					@(vif.dst_mon_cb);

				dst_monitor.payload[i] = vif.dst_mon_cb.data_out;
					@(vif.dst_mon_cb);
			end

	while(vif.dst_mon_cb.rd_enb !== 1)
		@(vif.dst_mon_cb);

	dst_monitor.parity = vif.dst_mon_cb.data_out;
	@(vif.dst_mon_cb);
	
	dst_mon2sb.write(dst_monitor);
	`uvm_info("DST_MONITOR", $sformatf("\n%b", dst_monitor.sprint), UVM_MEDIUM)

	endtask

			

	
			 
			 
			 
			 
			 

