class packet extends uvm_sequence_item;
  `uvm_object_utils(packet);
   
  function new(string name="packet");
    super.new(name);
  endfunction
  
  rand bit [31:0] Paddr;
  rand bit Pselx, Penable, Pwrite;
  rand bit [31:0] Pwdata;
  
  logic [31:0] exp_Prdata,Prdata;
  logic exp_Pready,Pready;
  logic Pslverr;
  
  constraint c1_legal{
    Pselx inside {0,1};
    Penable inside {0,1};
    Pwrite inside {0,1};
    Paddr inside {[32'h0000_0000 : 32'hFFFF_FFFF]};
    Pwdata inside {[32'h0000_0000 : 32'hFFFF_FFFF]};
  }
    

endclass
