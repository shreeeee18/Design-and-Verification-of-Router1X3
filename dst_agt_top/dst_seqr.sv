class dst_seqr extends uvm_sequencer #(dst_xtn);
	
	`uvm_component_utils(dst_seqr)

	extern function new (string name = "dst_seqr", uvm_component parent);
	
endclass

	function dst_seqr::new (string name = "dst_seqr", uvm_component parent);
		super.new(name, parent);
	endfunction


