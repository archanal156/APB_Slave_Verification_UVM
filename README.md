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
UVM_INFO: [SEQ] Generating APB transaction
UVM_INFO: [IMON] ADDR=5 WRITE=1 WDATA=123 EXP_RDATA=0
UVM_INFO: [OMON] Prdata=0 Pready=1 Pslverr=0
UVM_INFO: [SCB] WRITE SUCCESS
...
-------------------------
MATCH    = 10
MISMATCH = 0
Input Coverage  = 100.00%
Output Coverage = 100.00%
-------------------------
```
*(Replace with your own captured log/coverage once you run it.)*

## Known limitations

- `Pslverr` is never asserted by the DUT — the error path is currently
  unverified.
- The DUT always asserts `Pready` on the first ACCESS cycle, so wait-state
  handling in the driver/monitor is not exercised.
- DUT memory is not reset on `Prst`; the first read to an untouched address
  returns `X` rather than `0`.

## License

MIT — see [LICENSE](LICENSE).
