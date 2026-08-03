class imonitor extends uvm_component;
  
  virtual apb_int vif;
  packet pkt;
  uvm_analysis_port #(packet) ap;
  
  int ass_a[*];
  
  `uvm_component_utils(imonitor);
  
  covergroup cgrp_in;
    
    cp_penable : coverpoint pkt.Penable {bins b3={0,1};}
    cp_pwrite  : coverpoint pkt.Pwrite {bins b4[]={0,1};}
    cp_pselx   : coverpoint pkt.Pselx {bins b5={0,1};}
    
  endgroup
  
   function new(string name, uvm_component parent);
        super.new(name,parent);
     cgrp_in = new();
  endfunction
  
  function void build_phase(uvm_phase phase);
    `uvm_info("MONIN","start build phase",UVM_MEDIUM);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual apb_int)::get(this," ","key",vif))
      `uvm_error("IMON","config db not set")
    ap = new("ap",this);
    `uvm_info("MONIN","end build phase",UVM_MEDIUM);
  endfunction
  
    virtual task run_phase(uvm_phase phase);
    `uvm_info("MONIN", "start run phase",UVM_MEDIUM);
    forever begin

      @(vif.imon); //setup phase
      if(vif.imon.Pselx && !vif.imon.Penable) begin
        pkt = packet::type_id::create("pkt");

        pkt.Paddr   = vif.imon.Paddr;
        pkt.Pselx   = vif.imon.Pselx;
        pkt.Penable = vif.imon.Penable;
        pkt.Pwrite  = vif.imon.Pwrite;
        pkt.Pwdata  = vif.imon.Pwdata;

        @(vif.imon); //access phase

        while(!vif.imon.Pready) begin //wait states
          @(vif.imon);
        end

        // Reference model
        if(pkt.Pwrite) begin
          ass_a[pkt.Paddr] = pkt.Pwdata;
          pkt.exp_Prdata = '0;
        end
        
        else begin
          if(ass_a.exists(pkt.Paddr))
            pkt.exp_Prdata = ass_a[pkt.Paddr];
          else
            pkt.exp_Prdata = '0;
        end

        pkt.exp_Pready = vif.imon.Pready;
        `uvm_info("IMON",
        $sformatf("ADDR=%0d WRITE=%0b WDATA=%0d EXP_RDATA=%0d",
        pkt.Paddr,
        pkt.Pwrite,
        pkt.Pwdata,
        pkt.exp_Prdata),
        UVM_LOW)

        cgrp_in.sample();
        ap.write(pkt);

      end
    end
 endtask

endclass
