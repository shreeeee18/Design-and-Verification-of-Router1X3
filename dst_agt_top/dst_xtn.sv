class dst_xtn extends uvm_sequence_item;
	`uvm_object_utils(dst_xtn)
		
	logic [7:0] header, payload[];
	logic [7:0] parity;
	rand int clock_cnt;
	
	extern function new(string name = "dst_xtn");
	extern virtual function void do_print(uvm_printer printer);
	
endclass
	
function dst_xtn::new (string name = "dst_xtn");
	super.new(name);
endfunction

function void dst_xtn::do_print(uvm_printer printer);
	super.do_print(printer);
	printer.print_field("header", this.header, $bits(this.header), UVM_DEC);
	foreach(payload[i])begin	
	printer.print_field($sformatf("payload[%0d]", i), this.payload[i], $bits(this.payload[i]), UVM_DEC); end
	printer.print_field("parity", this.parity, $bits(this.parity), UVM_DEC);	
	printer.print_field("clock_cnt", this.clock_cnt, $bits(this.clock_cnt), UVM_DEC);	
endfunction

	
