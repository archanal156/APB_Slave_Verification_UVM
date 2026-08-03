# APB Slave Verification (UVM)

A UVM-based verification environment for an AMBA APB Slave, featuring
constrained-random stimulus, a reference model, functional coverage, and a
self-checking scoreboard.


- **driver** – drives APB SETUP/ACCESS phases onto the interface from
  randomized `packet` items.
- **imonitor** – samples the input side, builds a reference model of
  expected read data, and publishes expected packets.
- **omonitor** – samples the output side (`Prdata`, `Pready`, `Pslverr`)
  from the DUT.
- **scoreboard** – compares expected vs. actual packets and tracks
  match/mismatch counts.
- **sequence1** – generates constrained-random APB transactions
  (address range, write/read distribution).

## Directory structure

```
.
├── rtl/
│   └── apb_design.sv      # APB slave DUT (FSM + memory)
├── tb/
│   ├── interface.sv       # APB virtual interface + clocking blocks
│   ├── packet.sv          # Sequence item
│   ├── driver.sv
│   ├── sequencer.sv
│   ├── sequence1.sv
│   ├── iagent.sv
│   ├── imonitor.sv
│   ├── oagent.sv
│   ├── omonitor.sv
│   ├── scoreboard.sv
│   ├── environment.sv
│   ├── test.sv
│   └── top.sv             # Testbench top: clock/reset + DUT + run_test()
├── filelist.f              # File list consumed by the Makefile
├── Makefile                # Compile/run targets (Questa, VCS)
└── LICENSE
```

## Prerequisites

- A SystemVerilog/UVM-1.2 capable simulator: **Questa/ModelSim**, **VCS**,
  or **Xcelium**. (Also runnable on **EDA Playground** — see below.)

## How to run

### Using the Makefile
```bash
# Questa / ModelSim
make questa

# Synopsys VCS
make vcs

# clean generated artifacts
make clean
```

### Using EDA Playground
1. Create a new SystemVerilog + UVM project.
2. Paste `rtl/apb_design.sv` into the **Design** panel.
3. Paste `tb/top.sv` (and let it `\`include` the rest of `tb/`) into the
   **Testbench** panel, or upload all `tb/*.sv` files.
4. Select an EDA tool that supports UVM (e.g. Questa) and run.

## Sample output

```
rst on
Running test1 
UVM_INFO @ 0: reporter [RNTST] Running test test1...
UVM_INFO test.sv(22) @ 0: uvm_test_top [TEST] start buildt phase
UVM_INFO test.sv(30) @ 0: uvm_test_top [TEST] end buildt phase
UVM_INFO environment.sv(27) @ 0: uvm_test_top.env [ENV] Build phase
UVM_INFO iagent.sv(23) @ 0: uvm_test_top.env.ig [IAG] Build phase
UVM_INFO imonitor.sv(26) @ 0: uvm_test_top.env.ig.imon [MONIN] start build phase
UVM_INFO imonitor.sv(31) @ 0: uvm_test_top.env.ig.imon [MONIN] end build phase
UVM_INFO oagent.sv(19) @ 0: uvm_test_top.env.og [OAG] Build phase start
UVM_INFO omonitor.sv(24) @ 0: uvm_test_top.env.og.omon [OMON] Build phase start
UVM_INFO iagent.sv(32) @ 0: uvm_test_top.env.ig [IAG] Connect phase
UVM_INFO oagent.sv(27) @ 0: uvm_test_top.env.og [OAG] Connect phase
UVM_INFO environment.sv(42) @ 0: uvm_test_top.env [ENV] Connect phase
UVM_INFO /apps/vcsmx/vcs/X-2025.06-SP1//etc/uvm-1.2/src/base/uvm_root.svh(594) @ 0: reporter [UVMTOP] UVM testbench topology:
------------------------------------------------------------------
Name                       Type                        Size  Value
------------------------------------------------------------------
uvm_test_top               test1                       -     @341 
  env                      environment                 -     @362 
    ig                     iagent                      -     @376 
      apiag                uvm_analysis_port           -     @581 
      drv                  driver                      -     @406 
        rsp_port           uvm_analysis_port           -     @425 
        seq_item_port      uvm_seq_item_pull_port      -     @415 
      imon                 imonitor                    -     @572 
        ap                 uvm_analysis_port           -     @595 
      sqr                  sequencer                   -     @435 
        rsp_export         uvm_analysis_export         -     @444 
        seq_item_export    uvm_seq_item_pull_imp       -     @562 
        arbitration_queue  array                       0     -    
        lock_queue         array                       0     -    
        num_last_reqs      integral                    32    'd1  
        num_last_rsps      integral                    32    'd1  
    og                     oagent                      -     @385 
      apoag                uvm_analysis_port           -     @625 
      omon                 omonitor                    -     @616 
        ap                 uvm_analysis_port           -     @638 
    scb                    scoreboard                  -     @394 
      imon_ap              uvm_tlm_analysis_fifo #(T)  -     @648 
        analysis_export    uvm_analysis_imp            -     @697 
        get_ap             uvm_analysis_port           -     @687 
        get_peek_export    uvm_get_peek_imp            -     @667 
        put_ap             uvm_analysis_port           -     @677 
        put_export         uvm_put_imp                 -     @657 
      omon_ap              uvm_tlm_analysis_fifo #(T)  -     @707 
        analysis_export    uvm_analysis_imp            -     @756 
        get_ap             uvm_analysis_port           -     @746 
        get_peek_export    uvm_get_peek_imp            -     @726 
        put_ap             uvm_analysis_port           -     @736 
        put_export         uvm_put_imp                 -     @716 
------------------------------------------------------------------

UVM_INFO driver.sv(29) @ 0: uvm_test_top.env.ig.drv [DRIVER] start run phase
UVM_INFO imonitor.sv(35) @ 0: uvm_test_top.env.ig.imon [MONIN] start run phase
UVM_INFO test.sv(43) @ 0: uvm_test_top [TEST] start run phase
UVM_INFO sequence1.sv(23) @ 0: uvm_test_top.env.ig.sqr@@seq [SEQ] Generating APB transaction
Rst off
UVM_INFO imonitor.sv(86) @ 45: uvm_test_top.env.ig.imon [IMON] ADDR=18 WRITE=1 WDATA=1879766953 EXP_RDATA=0
UVM_INFO omonitor.sv(49) @ 45: uvm_test_top.env.og.omon [OMON] Prdata=0 Pready=1 Pslverr=0
UVM_INFO scoreboard.sv(80) @ 45: uvm_test_top.env.scb [SCB] WRITE SUCCESS

-------------------------
MATCH    = <MATCH SCORE>
MISMATCH = <MISMATCH SCORE>
Input Coverage  = 100.00%
Output Coverage = 75.00%
-------------------------
```

## Known limitations

- `Pslverr` is never asserted by the DUT — the error path is currently
  unverified.
- The DUT always asserts `Pready` on the first ACCESS cycle, so wait-state
  handling in the driver/monitor is not exercised.
- DUT memory is not reset on `Prst`; the first read to an untouched address
  returns `X` rather than `0`.

## License

MIT — see [LICENSE](LICENSE).
