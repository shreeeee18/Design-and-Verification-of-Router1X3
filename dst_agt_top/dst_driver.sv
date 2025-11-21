class dst_driver extends uvm_driver #(dst_xtn);
	
	`uvm_component_utils(dst_driver)
	virtual router_if.DST_DRV_MP vif;
	dst_agent_config d_cfg;
	//event done;
	extern function new (string name = "dst_driver", uvm_component parent);	
	extern function void connect_phase(uvm_phase phase);
  	extern task run_phase(uvm_phase phase);
  	extern task send_to_dut(dst_xtn xtnh);

endclass

	function dst_driver::new (string name = "dst_driver", uvm_component parent);
		super.new(name, parent);
	endfunction

	function void dst_driver::connect_phase(uvm_phase phase);
  		super.connect_phase(phase);
  		if (!uvm_config_db#(dst_agent_config)::get(this, "", "dst_agent_config", d_cfg))
    			`uvm_fatal("DST_DRIVER", "GET failed")

  		vif = d_cfg.vif;
	endfunction

	task dst_driver::run_phase(uvm_phase phase);
			// @(vif.dst_drv_cb);
		forever 
			begin
				seq_item_port.get_next_item(req);
				//req.print;
				//`uvm_info("DST_DRIVER", $sformatf("\n%s", req.sprint), UVM_MEDIUM)
				send_to_dut(req);
				//wait(done.triggered);
				seq_item_port.item_done();
			end
	endtask

	task dst_driver::send_to_dut(dst_xtn xtnh);

			 @(vif.dst_drv_cb);

  while (vif.dst_drv_cb.valid_out !== 1)
	//`uvm_info("DST_DRIVER", $sformatf("\n%b", vif.dst_drv_cb.valid_out), UVM_MEDIUM)
			 @(vif.dst_drv_cb);

  repeat (xtnh.clock_cnt) 
			 @(vif.dst_drv_cb);
  vif.dst_drv_cb.rd_enb <= 1'b1;

  while (vif.dst_drv_cb.valid_out !== 0) 
			 @(vif.dst_drv_cb);

  vif.dst_drv_cb.rd_enb <= 1'b0;
			  `uvm_info("DST_DRIVER", $sformatf("\n%s", xtnh.sprint), UVM_MEDIUM)
		endtask

	

