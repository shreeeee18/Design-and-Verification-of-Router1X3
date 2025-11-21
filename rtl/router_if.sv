interface router_if (input clock);
	
	logic resetn, pkt_valid, error, busy, rd_enb, valid_out;
	logic [7:0] data_in, data_out;
		
clocking src_drv_cb @(posedge clock);
	default input #1 output #1;
		output 	resetn;
		output 	data_in;
		output 	pkt_valid;	
		input 	busy;
		input 	error;
endclocking

clocking src_mon_cb @(posedge clock);
	default input #1 output #1;
		input 	resetn;
		input 	pkt_valid;
		input 	data_in;
		input 	busy;
		input 	error;
endclocking

clocking dst_drv_cb @(posedge clock);
	default input#1 output#1;
		input 	valid_out;
		output	rd_enb;
endclocking

clocking dst_mon_cb @(posedge clock);
	default input #1 output #1;
		input 	data_out;
		input 	valid_out;
		input 	rd_enb;
		
endclocking

	modport SRC_DRV_MP (clocking src_drv_cb);
	modport SRC_MON_MP (clocking src_mon_cb);
	modport DST_DRV_MP (clocking dst_drv_cb);
	modport DST_MON_MP (clocking dst_mon_cb);
	

endinterface
