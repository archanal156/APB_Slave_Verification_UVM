interface apb_int(input bit Pclk ,Prst);
  
  logic [31:0] Paddr;
  logic Pselx;
  logic Penable;
  logic Pwrite;
  logic [31:0] Pwdata;
  logic Pready;
  logic Pslverr;
  logic [31:0] Prdata;
  
  clocking drv@(posedge Pclk);
    output Paddr, Pselx, Penable, Pwrite, Pwdata;
    
    input Pready;
    input Pslverr;
    input Prdata;
  endclocking
  
  clocking imon@(posedge Pclk);
    input Paddr, Pselx, Penable, Pwrite, Pwdata;
    input Pready;
    input Prdata;
    input Pslverr;
  endclocking
  
  clocking omon@(posedge Pclk);
    input Pready, Pslverr, Prdata;
    input Pselx;
    input Penable;
  endclocking
  
 modport drv_cb (clocking drv);
 modport imon_cb (clocking imon);
 modport omon_cb (clocking omon);
   
   endinterface
   
