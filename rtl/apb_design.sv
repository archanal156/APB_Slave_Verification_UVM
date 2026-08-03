// Code your design here
module apb_design (Pclk,Prst,Paddr,Pselx,Penable,Pwrite,Pwdata,Pready,Pslverr,Prdata);
	
  //inputs
  input Pclk;
  input Prst;
  input [31:0]Paddr;
  input Pselx;
  input Penable;
  input Pwrite;
  input [31:0]Pwdata;
  
  //outputs
  output reg Pready;
  output reg  Pslverr;
  output reg [31:0]Prdata;

  //state encoding
  parameter [1:0] IDLE=2'b00;
  parameter [1:0] SETUP=2'b01;
  parameter [1:0] ACCESS=2'b10;
  
  
  //internal memory
  reg [31:0]mem[31:0];

  
  //current star next stae declaration
  reg [1:0] cs,ns;
  
  
  //sequential logic
  always @(posedge Pclk) begin
    if(!Prst) cs <= IDLE;
    else
     cs <= ns;
  end
  
  
  //combinational logic
   always @(*) begin
    ns = cs;

    case (cs)

      IDLE: begin
        if (Pselx && !Penable)
          ns = SETUP;
      end

      SETUP: begin
        if (Pselx && Penable)
          ns = ACCESS;
        else if (!Pselx)
          ns = IDLE;
      end

      ACCESS: begin
        if (!Pselx)
          ns = IDLE;
        else if (Pselx && !Penable)
          ns = SETUP;      // Back-to-back transfer
      end

      default: ns = IDLE;

    endcase
  end
  
    always @(posedge Pclk or negedge Prst) begin

    if (!Prst) begin
      Pready  <= 1'b0;
      Pslverr <= 1'b0;
      Prdata  <= 32'd0;
    end
    else begin

      // Default outputs every cycle
      Pready  <= 1'b0;
      Pslverr <= 1'b0;

      if (cs == ACCESS && Pselx && Penable) begin

        Pready <= 1'b1;

        if (Pwrite)
          mem[Paddr[4:0]] <= Pwdata;
        else
          Prdata <= mem[Paddr[4:0]];

      end

    end

  end
endmodule
