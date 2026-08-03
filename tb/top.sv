import uvm_pkg::*;
`include "uvm_macros.svh"

`include "interface.sv"

`include "test.sv"


module testbench();
  
  reg Pclk,Prst;
  
  always #5 Pclk = ~Pclk;
  
  initial begin 
    Pclk = 1'b0; Prst = 1'b0;
    $display("rst on");
    @(posedge Pclk);  Prst = 1'b1;
    $display("Rst off");
  end
  
  apb_int a1(.Pclk(Pclk),.Prst(Prst));
  
  apb_design a2(.Pclk(a1.Pclk), .Prst(a1.Prst), .Paddr(a1.Paddr), .Pselx(a1.Pselx), .Penable(a1.Penable), .Pwrite(a1.Pwrite), .Pwdata(a1.Pwdata) ,.Pready(a1.Pready), .Pslverr(a1.Pslverr), .Prdata(a1.Prdata));
  
  initial begin
    uvm_config_db #(virtual apb_int)::set(null,"*","key",a1);
    $display("Running test1 ");
    run_test("test1");
    #500;
    $finish;
    end
  
   initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  
endmodule
  
