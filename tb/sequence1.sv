
class sequence1 extends uvm_sequence#(packet);
  `uvm_object_utils(sequence1);
  
    packet pkt;
      
  function new(string name="sequence1");
    super.new(name);
  endfunction
    
    task body();
      
      repeat(2) begin
      `uvm_info("SEQUENCE","Running sequence",UVM_MEDIUM);
      pkt = packet::type_id::create("pkt");
      start_item(pkt);
        pkt.c1_legal.constraint_mode(1);
      assert(pkt.randomize() with {
        pkt.Pselx ==1 ; 
        pkt.Pwrite == 1; 
      
      });
      finish_item(pkt);
      `uvm_info("SEQUENCE","sequence done",UVM_MEDIUM);
      end
    endtask
    
endclass
