`include "sequencer.sv"
`include "driver.sv"
`include "imonitor.sv"

class iagent extends uvm_agent;
  
  `uvm_component_utils(iagent);
  
  virtual apb_int vif;
  
  uvm_analysis_port #(packet) apiag;
  
  driver drv;
  sequencer sqr;
  imonitor imon;
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("IAG","Build phase",UVM_LOW);
    drv = driver::type_id::create("drv",this);
    sqr = sequencer::type_id::create("sqr",this);
    imon = imonitor::type_id::create("imon",this);
    apiag = new("apiag",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("IAG","Connect phase",UVM_LOW);
    drv.seq_item_port.connect(sqr.seq_item_export);
    imon.ap.connect(apiag);
  endfunction
  
endclass
    
