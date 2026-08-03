`include "iagent.sv"
`include "oagent.sv"
`include "scoreboard.sv"


class environment extends uvm_component;

`uvm_component_utils(environment)
  
iagent ig;
oagent og;
scoreboard scb;

function new(string name, uvm_component parent);
    super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("ENV","Build phase",UVM_LOW);
    ig  = iagent::type_id::create("ig",this);
    og  = oagent::type_id::create("og",this);
  scb = scoreboard::type_id::create("scb",this);
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("ENV","Connect phase",UVM_LOW);
    ig.apiag.connect(scb.imon_ap.analysis_export);
    og.apoag.connect(scb.omon_ap.analysis_export);
endfunction

function void report_phase(uvm_phase phase);
    super.report_phase(phase);
  
    $display("-------------------------");
  
    $display("MATCH    = %0d",scb.match);
    $display("MISMATCH = %0d",scb.mismatch);

    $display("Input Coverage  = %0.2f%%",
              ig.imon.cgrp_in.get_coverage());

    $display("Output Coverage = %0.2f%%",
              og.omon.cgrp_out.get_coverage());

    $display("-------------------------");
endfunction

endclass
