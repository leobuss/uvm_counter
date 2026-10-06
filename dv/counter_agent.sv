`ifndef COUNTER_AGENT_SV
`define COUNTER_AGENT_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "counter_transaction.sv"
`include "counter_sequencer.sv"
`include "counter_driver.sv"
`include "counter_monitor.sv"

class counter_agent #(parameter int NBITS = 4) extends uvm_agent;
  `uvm_component_param_utils(counter_agent#(NBITS))

  counter_sequencer #(NBITS) sqr;
  counter_driver #(NBITS) drv;
  counter_monitor #(NBITS) mon;
  uvm_analysis_port #(counter_transaction #(NBITS)) ap;

  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    ap  = new("ap", this);
    sqr = counter_sequencer#(NBITS)::type_id::create("sqr", this);
    drv = counter_driver#(NBITS)::type_id::create("drv", this);
    mon = counter_monitor#(NBITS)::type_id::create("mon", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(sqr.seq_item_export);
    mon.ap.connect(this.ap);
  endfunction

endclass: counter_agent

`endif
