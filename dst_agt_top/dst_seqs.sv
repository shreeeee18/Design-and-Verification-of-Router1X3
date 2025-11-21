class dst_seqs extends uvm_sequence #(dst_xtn);
	`uvm_object_utils(dst_seqs)

	extern function new(string name = "dst_seqs");
endclass

	function dst_seqs::new(string name = "dst_seqs");
		super.new(name);
	endfunction

class clk_cnt_lt_30 extends dst_seqs;
	`uvm_object_utils(clk_cnt_lt_30)

	extern function new (string name = "clk_cnt_lt_30");

	extern task body();
endclass
	
	function clk_cnt_lt_30::new(string name = "clk_cnt_lt_30");
		super.new(name);
	endfunction

	task clk_cnt_lt_30::body();
		req = dst_xtn::type_id::create("dst_driver");
		start_item(req);
		assert(req.randomize() with {clock_cnt inside {[0:29]};});
		finish_item(req);
	endtask


class clk_cnt_gt_30 extends dst_seqs;
	`uvm_object_utils(clk_cnt_gt_30)

	extern  function new (string name = "clk_cnt_gt_30");

	extern task body();
endclass
	
	function clk_cnt_gt_30::new(string name = "clk_cnt_gt_30");
		super.new(name);
	endfunction

	task clk_cnt_gt_30::body();
		req = dst_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {clock_cnt inside {[30:40]};});
		finish_item(req);
	endtask

