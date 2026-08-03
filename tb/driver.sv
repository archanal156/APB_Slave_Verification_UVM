class driver extends uvm_driver #(packet);

  `uvm_component_utils(driver)

  virtual apb_int vif;

  packet pkt;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual apb_int)::get(this,"","key",vif))
      `uvm_error("DRV","config db not set")
  endfunction



  task run_phase(uvm_phase phase);

    `uvm_info("DRIVER","start run phase",UVM_MEDIUM)

    forever begin

      seq_item_port.get_next_item(pkt);

      @(vif.drv);  //setup phase
 
      vif.drv.Pselx   <= pkt.Pselx;
      vif.drv.Paddr   <= pkt.Paddr;
      vif.drv.Pwrite  <= pkt.Pwrite;
      vif.drv.Pwdata  <= pkt.Pwdata;
      vif.drv.Penable <= 1'b0;

      @(vif.drv);  //access phase

      vif.drv.Penable <= 1'b1;


      do begin
        @(vif.drv);
      end while(!vif.drv.Pready);  //waiting for Slave to be ready == wait states

      @(vif.drv);

      vif.drv.Pselx   <= 1'b0;
      vif.drv.Penable <= 1'b0;

      seq_item_port.item_done();
    end
  endtask

endclass
