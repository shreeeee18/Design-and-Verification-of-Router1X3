class src_xtn extends uvm_sequence_item;
	`uvm_object_utils(src_xtn)
		
	bit error;
	rand logic [7:0] header, payload[];
	rand logic [7:0] parity;
	
	constraint address { header [1:0]!= 3; }
	constraint hdr { header [7:2]!= 0; }
	constraint plsize { payload.size == header[7:2]; }

	extern function void post_randomize();
	extern function new(string name = "src_xtn");
	extern virtual function void do_print(uvm_printer printer);
	
endclass
	
function src_xtn::new (string name = "src_xtn");
	super.new(name);
endfunction

function void src_xtn::do_print(uvm_printer printer);
	super.do_print(printer);
	printer.print_field("header", this.header, $bits(this.header), UVM_DEC);
	foreach(payload[i])begin	
	printer.print_field($sformatf("payload[%0d]", i), this.payload[i], $bits(this.payload[i]), UVM_DEC); end
	printer.print_field("parity", this.parity, $bits(this.parity), UVM_DEC);	
	printer.print_field("error", this.error, $bits(this.error), UVM_DEC);	
endfunction

function void src_xtn::post_randomize();
	parity = header;
	foreach(payload[i]) begin
		parity = parity ^ payload[i];
	end
endfunction
