class src_seqr extends uvm_sequencer #(src_xtn);
	
	`uvm_component_utils(src_seqr)

	extern function new (string name = "src_seqr", uvm_component parent);
	
endclass

	function src_seqr::new (string name = "src_seqr", uvm_component parent);
		super.new(name, parent);
	endfunction

