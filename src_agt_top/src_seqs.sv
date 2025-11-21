class src_seqs extends uvm_sequence #(src_xtn);
	`uvm_object_utils(src_seqs)
	//router_env_config e_cfg;

    extern function new(string name ="src_seqs");
endclass

function src_seqs::new(string name = "src_seqs");
		  super.new(name);
endfunction

//samll packet

class sml_pkt_seqs extends src_seqs;
	`uvm_object_utils(sml_pkt_seqs)
	extern function new(string name ="sml_pkt_seqs");
	extern task body();
endclass	

function sml_pkt_seqs::new(string name = "sml_pkt_seqs");
		  super.new(name);
endfunction

task sml_pkt_seqs::body();
	bit [1:0] addr;
	if(!uvm_config_db #(bit[1:0])::get(null, get_full_name, "bit[1:0]", addr))
	  		  `uvm_fatal("src sml seqs", "config failed")

	   	  req=src_xtn::type_id::create("src_driver");
	   	start_item(req);
   		assert(req.randomize() with {
		header [7:2] <14; 
		header [1:0] == addr;
		});
	finish_item(req);
endtask


//medium packet
class mdm_pkt_seqs extends src_seqs;
	`uvm_object_utils(mdm_pkt_seqs)
	extern function new(string name ="mdm_pkt_seqs");
	extern task body();
endclass	

function mdm_pkt_seqs::new(string name = "mdm_pkt_seqs");
		  super.new(name);
endfunction

task mdm_pkt_seqs::body();
	bit [1:0] addr;
	if(!uvm_config_db #(bit[1:0])::get(null, get_full_name, "bit[1:0]", addr))
	  		  `uvm_fatal("src mdm seqs", "config failed")

	   	req=src_xtn::type_id::create("req");
	   	start_item(req);
   		assert(req.randomize() with {
		header [7:2] inside {[14:30]}; 
		header [1:0] == addr;
		});
		finish_item(req);
endtask

//large packet
class lrg_pkt_seqs extends src_seqs;
	`uvm_object_utils(lrg_pkt_seqs)
	extern function new(string name ="lrg_pkt_seqs");
	extern task body();
endclass	

function lrg_pkt_seqs::new(string name = "lrg_pkt_seqs");
		  super.new(name);
endfunction

task lrg_pkt_seqs::body();
	bit [1:0] addr;
	if(!uvm_config_db #(bit[1:0])::get(null, get_full_name, "bit[1:0]", addr))
	  		  `uvm_fatal("src lrg seqs", "config failed")

	   	   req=src_xtn::type_id::create("req");
	   	start_item(req);
		assert(req.randomize() with {
		header [7:2] >30; 
		header [1:0] == addr;
		});
	finish_item(req);
endtask

//error packet 

class err_pkt_seqs extends src_seqs;
	`uvm_object_utils(err_pkt_seqs)
	extern function new(string name ="err_pkt_seqs");
	extern task body();
endclass	

function err_pkt_seqs::new(string name = "err_pkt_seqs");
		  super.new(name);
endfunction

task err_pkt_seqs::body();
	bit [1:0] addr;
	if(!uvm_config_db #(bit[1:0])::get(null, get_full_name, "bit[1:0]", addr))
	  		  `uvm_fatal("src err seqs", "config failed")

   	  	req=src_xtn::type_id::create("req");
	   	start_item(req);
  		assert(req.randomize() with { header [1:0] == addr;});
		req.parity = 400;
		finish_item(req);
endtask

