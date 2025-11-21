class src_driver extends uvm_driver #(src_xtn);
	
	`uvm_component_utils(src_driver)
	virtual router_if.SRC_DRV_MP vif;
	src_agent_config s_cfg;
		
	extern function new (string name = "src_driver", uvm_component parent);	
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut;

endclass

	function src_driver::new (string name = "src_driver", uvm_component parent);
		super.new(name, parent);
	endfunction
	
	function void src_driver::build_phase(uvm_phase phase);	
		super.build_phase(phase);
		if(!uvm_config_db #(src_agent_config)::get(this, "", "src_agent_config", s_cfg))
			`uvm_fatal("src_driver", "config failed")
	endfunction	
	
	function void src_driver::connect_phase(uvm_phase phase);
		super.connect_phase(phase);
			//if(s_cfg.is_active)
				vif = s_cfg.vif;
	endfunction
	
	task src_driver::run_phase(uvm_phase phase);
	@(vif.src_drv_cb);
	vif.src_drv_cb.resetn <= 1'b0;
	@(vif.src_drv_cb);
	@(vif.src_drv_cb);
	vif.src_drv_cb.resetn <= 1'b1;

		forever 
			begin
				seq_item_port.get_next_item(req);	
				//req.print();
				send_to_dut;
				seq_item_port.item_done();
			end
	endtask

	task src_driver::send_to_dut;
		@(vif.src_drv_cb);
		while(vif.src_drv_cb.busy !== 0)
		@(vif.src_drv_cb);
		vif.src_drv_cb.pkt_valid <= 1'b1;
		vif.src_drv_cb.data_in <= req.header;
		@(vif.src_drv_cb);

		foreach(req.payload[i])
			begin
				while(vif.src_drv_cb.busy !== 0)
				@(vif.src_drv_cb);
				vif.src_drv_cb.data_in <= req.payload[i];
				@(vif.src_drv_cb);
			end
			
		while(vif.src_drv_cb.busy !== 0)
		@(vif.src_drv_cb);

		vif.src_drv_cb.pkt_valid <= 1'b0;
		vif.src_drv_cb.data_in <= req.parity;
		
		repeat(2)
			
				@(vif.src_drv_cb);
			req.error = vif.src_drv_cb.error;
			
	`uvm_info("SRC_DRIVER",$sformatf("printing from driver \n %s", req.sprint()),UVM_LOW) 
	endtask

