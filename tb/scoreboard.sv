class scoreboard extends uvm_scoreboard;

`uvm_component_utils(scoreboard)


uvm_tlm_analysis_fifo #(packet) imon_ap;
uvm_tlm_analysis_fifo #(packet) omon_ap;


int match;
int mismatch;

packet exp_pkt;
packet act_pkt;

function new(string name, uvm_component parent);
    super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    imon_ap = new("imon_ap",this);
    omon_ap = new("omon_ap",this);
endfunction

task run_phase(uvm_phase phase);
forever begin
    imon_ap.get(exp_pkt);
    omon_ap.get(act_pkt);
    if(exp_pkt.Pwrite == 0)
    begin

        if((exp_pkt.exp_Prdata === act_pkt.Prdata) &&
           (act_pkt.Pready === 1'b1))
        begin
            match++;
            `uvm_info("SCB",
            $sformatf("READ MATCH EXP=%0d GOT=%0d",
            exp_pkt.exp_Prdata,
            act_pkt.Prdata),
            UVM_LOW)
        end

        else
        begin
            mismatch++;
            `uvm_error("SCB","READ DATA MISMATCH")
        end
    end


    else
    begin
        if(act_pkt.Pready === 1'b1)
        begin
            match++;
            `uvm_info("SCB",
            "WRITE SUCCESS",
            UVM_LOW)
        end

        else
        begin
            mismatch++;
        end
    end

end
endtask

endclass
