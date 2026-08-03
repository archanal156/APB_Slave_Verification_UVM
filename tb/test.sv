`include "packet.sv"
`include "sequence1.sv"
`include "environment.sv"

class test1 extends uvm_test;
  
  `uvm_component_utils(test1)
  
  virtual apb_int vif;
  
  function new(string name, uvm_component parent);
        super.new(name,parent);
  endfunction
  
  sequence1 seq;
  environment env;
  
  function void build_phase(uvm_phase phase);
    `uvm_info("TEST","start build phase",UVM_MEDIUM);
    super.build_phase(phase);
    seq = sequence1::type_id::create("seq");
    env = environment::type_id::create("env",this);
    if(!uvm_config_db #(virtual apb_int)::get(this,"","key",vif))
      `uvm_info("TEST","config db not set", UVM_LOW);
    `uvm_info("TEST","end build phase",UVM_MEDIUM);
  endfunction
  
  virtual function void end_of_elaboration_phase(uvm_phase phase);
     super.end_of_elaboration_phase(phase);
     uvm_top.print_topology();
   endfunction
  
  task run_phase(uvm_phase phase);
    `uvm_info("TEST","start run phase",UVM_MEDIUM);
    phase.raise_objection(this);
    seq.start(env.ig.sqr);
    phase.drop_objection(this);
    `uvm_info("TEST","end run phase",UVM_MEDIUM);
  endtask
  
endclass
