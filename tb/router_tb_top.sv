module router_tb_top;
  import uvm_pkg::*;
  import router_pkg::*;

  logic clock = 0;

  always #5 clock = ~clock;

  router_if src_in0 (clock);
  router_if dst_in0 (clock);
  router_if dst_in1 (clock);
  router_if dst_in2 (clock);

  router_top DUV (
      clock,
      src_in0.resetn,
      dst_in0.rd_enb,
      dst_in1.rd_enb,
      dst_in2.rd_enb,
      src_in0.data_in,
      src_in0.pkt_valid,
      dst_in0.data_out,
      dst_in1.data_out,
      dst_in2.data_out,
      dst_in0.vld_out,
      dst_in1.vld_out,
      dst_in2.vld_out,
      src_in0.error,
      src_in0.busy
  );

/*property stable_data;
  @(posedge clock) $rose(src_in0.busy) |=> $stable(src_in0.data_in);
endproperty

property busy_check;
  @(posedge clock) $rose(src_in0.pkt_valid) |-> src_in0.busy;
endproperty

property packet_valid;
  @(posedge clock) $rose(src_in0.pkt_valid) |-> ##3 (dst_in0.valid_out || dst_in1.valid_out || dst_in2.valid_out);
endproperty

property read_enable0_high;
  @(posedge clock) $rose(dst_in0.valid_out) |-> ##[0:29] (dst_in0.rd_enb);
endproperty

property read_enable1_high;
  @(posedge clock) $rose(dst_in1.valid_out) |-> ##[0:29] (dst_in1.rd_enb);
endproperty

property read_enable2_high;
  @(posedge clock) $rose(dst_in2.valid_out) |-> ##[0:29] (dst_in2.rd_enb);
endproperty

property read_enable0_low;
  @(posedge clock) $fell(dst_in0.valid_out) |-> $fell(dst_in0.rd_enb);
endproperty

property read_enable1_low;
  @(posedge clock) $fell(dst_in1.valid_out) |-> $fell(dst_in1.rd_enb);
endproperty

property read_enable2_low;
  @(posedge clock) $fell(dst_in2.valid_out) |-> $fell(dst_in2.rd_enb);
endproperty

assert property(stable_data);
assert property(busy_check);
assert property(packet_valid);
assert property(read_enable0_high);
assert property(read_enable1_high);
assert property(read_enable2_high);
assert property(read_enable0_low);
assert property(read_enable1_low);
assert property(read_enable2_low);*/

/*sequence seq_reset;
    (data_out_0 == 0 && data_out_1 == 0 && data_out_2 == 0 && vld_out_0 == 0 && vld_out_1 == 0 && vld_out_2 == 0);
  endsequence : seq_reset
  
  property prty_reset;
    @(posedge clock) !resetn |=> seq_reset;
  endproperty : prty_reset

  property prty_busy_header;
    @(posedge clock) disable iff(!resetn) ($rose(pkt_valid)) |=> $rose(busy) ##1 $fell(busy);
  endproperty : prty_busy_header

  property prty_busy_parity;
    @(posedge clock) disable iff(!resetn) ($fell(pkt_valid)) |-> ##[0:1] $rose(busy);
  endproperty : prty_busy_parity

  property prty_stable_data;
    @(posedge clock) disable iff(!resetn) (busy) |=> (data_in == $past(data_in));
  endproperty : prty_stable_data

  property prty_valid_out;
    @(posedge clock) disable iff(!resetn) $rose(pkt_valid) |=> ##2 (vld_out_0 | vld_out_1 | vld_out_2);
  endproperty : prty_valid_out

  property prty_read_enb_0_high;
    @(posedge clock) disable iff(!resetn) $rose(vld_out_0) |=> ##[0:29] read_enb_0;
  endproperty : prty_read_enb_0_high

  property prty_read_enb_0_low;
    @(posedge clock) disable iff(!resetn) vld_out_0 ##1 !vld_out_0 |=> $fell(read_enb_0);
  endproperty : prty_read_enb_0_low

  property prty_read_enb_1_high;
    @(posedge clock) disable iff(!resetn) $rose(vld_out_1) |=> ##[0:29] read_enb_1;
  endproperty : prty_read_enb_1_high

  property prty_read_enb_1_low;
    @(posedge clock) disable iff(!resetn) vld_out_1 ##1 !vld_out_1 |=> $fell(read_enb_1);
  endproperty : prty_read_enb_1_low

  property prty_read_enb_2_high;
    @(posedge clock) disable iff(!resetn) $rose(vld_out_2) |=> ##[0:29] read_enb_2;
  endproperty : prty_read_enb_2_high

  property prty_read_enb_2_low;
    @(posedge clock) disable iff(!resetn) vld_out_2 ##1 !vld_out_2 |=> $fell(read_enb_2);
  endproperty : prty_read_enb_2_low

  RESET: assert property(prty_reset);
  BUSY_HEADER: assert property(prty_busy_header);
  BUSY_PARITY: assert property(prty_busy_parity);
  STABLE_DATA: assert property(prty_stable_data);
  VALID_OUT: assert property(prty_valid_out);
  READ_ENB_0_HIGH: assert property(prty_read_enb_0_high);
  READ_ENB_0_LOW: assert property(prty_read_enb_0_low);
  READ_ENB_1_HIGH: assert property(prty_read_enb_1_high);
  READ_ENB_1_LOW: assert property(prty_read_enb_1_low);
  READ_ENB_2_HIGH: assert property(prty_read_enb_2_high);
  READ_ENB_2_LOW: assert property(prty_read_enb_2_low);*/

  initial begin
    uvm_config_db#(virtual router_if)::set(null, "*", "src_in0", src_in0);
    uvm_config_db#(virtual router_if)::set(null, "*", "dst_in0", dst_in0);
    uvm_config_db#(virtual router_if)::set(null, "*", "dst_in1", dst_in1);
    uvm_config_db#(virtual router_if)::set(null, "*", "dst_in2", dst_in2);
    run_test("");

  end
endmodule
