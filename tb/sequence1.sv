class sequence1 extends uvm_sequence #(packet);

  `uvm_object_utils(sequence1)
  
  packet pkt;

  function new(string name="sequence1");
    super.new(name);
  endfunction

  task body();

    repeat(10)
    begin

      `uvm_info("SEQ","Generating APB transaction",UVM_MEDIUM)
      
      pkt = packet::type_id::create("pkt");
      
      start_item(pkt);
      
      if(!pkt.randomize() with {
          Pselx == 1;
          Paddr inside {[0:31]};
          Pwrite dist {
             1 := 50,
             0 := 50
          };
      })
      begin
          `uvm_error("SEQ","Randomization failed")
      end
      
      finish_item(pkt);
    end
  endtask
endclass
