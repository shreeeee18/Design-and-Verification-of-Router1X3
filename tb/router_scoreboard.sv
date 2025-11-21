class router_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(router_scoreboard)

    router_env_config e_cfg;
    
    uvm_tlm_analysis_fifo #(src_xtn) s_fifoh[];
    uvm_tlm_analysis_fifo #(dst_xtn) d_fifoh[];

    src_xtn src_xtnh;
    dst_xtn dst_xtnh;

    int no_of_success_pkt, no_of_corrupt_pkt;

    covergroup src_cg;
        ADDR: coverpoint src_xtnh.header [1:0]{
            bins addrs0 = {0};
            bins addrs1 = {1};
            bins addrs2 = {2};
        }

        PAYLOAD_LENGTH: coverpoint src_xtnh.header[7:2]{
            bins small_packet_bins = {[1:14]};
            bins medium_packet_bins = {[15:30]};
            bins large_packet_bins = {[31:63]};
        }

        ERROR: coverpoint src_xtnh.error{
            bins no_error = {0};
            bins error1 = {1};
        }     
        
        cross ADDR,PAYLOAD_LENGTH, ERROR;
    endgroup

    covergroup dst_cg;
        ADDR: coverpoint dst_xtnh.header [1:0]{
            bins addrs0 = {0};
            bins addrs1 = {1};
            bins addrs2 = {2};
        }

        PAYLOAD_LENGTH: coverpoint dst_xtnh.header[7:2]{
            bins small_packet_bins = {[1:14]};
            bins medium_packet_bins = {[15:30]};
            bins large_packet_bins = {[31:63]};
        }   
        
        cross ADDR,PAYLOAD_LENGTH;
    endgroup


    function new (string name = "router_scoreboard", uvm_component parent);
        super.new(name, parent);
        src_cg = new;
        dst_cg = new;
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(router_env_config)::get(this, "", "router_env_config", e_cfg))
            `uvm_fatal("router_sb", "config failed")
            
            s_fifoh = new[e_cfg.no_of_src_agent];
            foreach(s_fifoh[i])
             begin
                s_fifoh[i] = new($sformatf("s_fifoh[%0d]",i), this);
             end

            d_fifoh =new[e_cfg.no_of_dst_agent];
            foreach(d_fifoh[i])
             begin
                d_fifoh[i] = new($sformatf("d_fifoh[%0d]",i), this);
             end
    endfunction

    task run_phase(uvm_phase phase);
        forever 
            begin
                fork
                    begin
                        s_fifoh[0].get(src_xtnh);
                        src_xtnh.print();
                    end

                    begin
                        fork :A
                            begin   
                                d_fifoh[0].get(dst_xtnh);
                                dst_xtnh.print();
                            end

                            begin   
                                d_fifoh[1].get(dst_xtnh);
                                dst_xtnh.print();
                            end

                            begin   
                                d_fifoh[2].get(dst_xtnh);
                                dst_xtnh.print();
                            end
                        join_any
                        disable A;
                    end
+                join
                
                 compare(src_xtnh, dst_xtnh);

            end
    endtask


    /*function logic [7:0] parity_ref_model(src_xtn src_xtnh);
         logic [7:0] parity;
        parity = src_xtnh.header;
    foreach (src_xtnh.payload[i]) begin
            parity = parity ^ src_xtnh.payload[i];
         end
      return parity;
    endfunction*/

                
        task compare (src_xtn src_xtnh, dst_xtn dst_xtnh);

            if(src_xtnh.header == dst_xtnh.header  && src_xtnh.payload == dst_xtnh.payload &&  src_xtnh.parity == dst_xtnh.parity)      
            no_of_success_pkt++;
            
            else
             begin
                $display("========================== Corrupt Packet ==========================");
                `uvm_warning("ROUTER_SB", $sformatf("SRC TXN\n%s", src_xtnh.sprint))
                `uvm_warning("ROUTER_SB", $sformatf("DST TXN\n%s", dst_xtnh.sprint))
                $display("====================================================================");                
                no_of_corrupt_pkt++;
             end
             src_cg.sample();
             dst_cg.sample();
        endtask

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            $display("Number of success packets : %0d", no_of_success_pkt);
            $display("Number of corrupt packets : %0d", no_of_corrupt_pkt);
        endfunction 

 
endclass
