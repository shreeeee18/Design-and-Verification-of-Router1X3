class src_mon extends uvm_monitor;	
	
	`uvm_component_utils(src_mon);
	src_agent_config s_cfg;
	virtual router_if.SRC_MON_MP vif;
	uvm_analysis_port #(src_xtn) src_mon2sb;
	//src_src_monitor data_sent;
	extern function new (string name = "src_mon", uvm_component parent);
	extern function void connect_phase(uvm_phase phase);
	extern function void build_phase(uvm_phase phase); 
	extern task run_phase(uvm_phase phase);
	extern task collect_data();

endclass
	
	function src_mon:: new (string name = "src_mon", uvm_component parent);
		super.new(name, parent);
		src_mon2sb = new("src_mon2sb", this);
	endfunction

	function void src_mon::build_phase(uvm_phase phase);
		super.build_phase(phase);
			if(!uvm_config_db #(src_agent_config)::get(this, "", "src_agent_config", s_cfg))
				`uvm_fatal("src_mon", "config failed")
	endfunction

	function void src_mon::connect_phase(uvm_phase phase);
		super.connect_phase(phase);
			vif = s_cfg.vif;
	endfunction

	task src_mon::run_phase(uvm_phase phase);
		forever 
			collect_data();
	endtask
	
	task src_mon::collect_data();
	src_xtn src_monitor;
		src_monitor = src_xtn::type_id::create("src_monitor");
		while(vif.src_mon_cb.busy !== 0)	
			@(vif.src_mon_cb);
		while(vif.src_mon_cb.pkt_valid !== 1)
			@(vif.src_mon_cb);
	
		src_monitor.header = vif.src_mon_cb.data_in;

		src_monitor.payload = new[src_monitor.header[7:2]];
			@(vif.src_mon_cb);
			
			foreach(src_monitor.payload[i])
			begin
				while(vif.src_mon_cb.busy !== 0)
				@(vif.src_mon_cb);
				while(vif.src_mon_cb.pkt_valid !== 1)
				@(vif.src_mon_cb);
				src_monitor.payload[i] = vif.src_mon_cb.data_in;
				@(vif.src_mon_cb);
			end

			while(vif.src_mon_cb.busy !== 0)	
			@(vif.src_mon_cb);
			while(vif.src_mon_cb.pkt_valid !== 0)
			@(vif.src_mon_cb);
			
			src_monitor.parity = vif.src_mon_cb.data_in;
			repeat(2) 
			@(vif.src_mon_cb);
			src_monitor.error = vif.src_mon_cb.error;
			src_mon2sb.write(src_monitor);
			`uvm_info("SRC_MONITOR",$sformatf("printing from monitor \n %s", src_monitor.sprint()),UVM_LOW) 
	endtask
