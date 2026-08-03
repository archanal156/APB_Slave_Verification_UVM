`include "omonitor.sv"

class oagent extends uvm_agent;
  
  `uvm_component_utils(oagent);
  
  uvm_analysis_port #(packet) apoag;
    
  omonitor omon;

  
    function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("OAG","Build phase start",UVM_LOW);
    super.build_phase(phase);
    omon = omonitor::type_id::create("omon",this);
    apoag = new("apoag",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("OAG","Connect phase",UVM_LOW);
    omon.ap.connect(apoag);
  endfunction
  
  
endclass
