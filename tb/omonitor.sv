class omonitor extends uvm_monitor;
  
  `uvm_component_utils(omonitor);
  
  uvm_analysis_port #(packet) ap;
  
  virtual apb_int vif;
  
  packet pkt;
  
  covergroup cgrp_out;
    cp_pready : coverpoint pkt.Pready { bins b1[]={0,1};}
    cp_prdata : coverpoint pkt.Prdata { bins b2={[0:31]};}
  endgroup
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
    cgrp_out = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("OMON","Build phase start",UVM_LOW);
    if(!uvm_config_db #(virtual apb_int)::get(this," ","key",vif))
      `uvm_error("OMON","config db not set");
    ap = new("ap",this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
     forever begin
      @(vif.omon);
       if(vif.omon.Pselx &&  vif.omon.Penable &&  vif.omon.Pready) begin

        pkt = packet::type_id::create("pkt");
         
        pkt.Prdata  = vif.omon.Prdata;
        pkt.Pslverr = vif.omon.Pslverr;
        pkt.Pready  = vif.omon.Pready;


        `uvm_info("OMON",
        $sformatf("Prdata=%0d Pready=%0b Pslverr=%0b",
        pkt.Prdata,
        pkt.Pready,
        pkt.Pslverr),
        UVM_LOW)

        cgrp_out.sample();
        ap.write(pkt);
      end
    end
  endtask
  
endclass
                
