`ifndef COUNTER_MONITOR_SVH
`define COUNTER_MONITOR_SVH

import uvm_pkg::*;

`include "uvm_macros.svh"

class counter_monitor #(parameter NBITS = 4) extends uvm_monitor;

    `uvm_component_param_utils(counter_monitor #(NBITS))

    virtual counter_if #(NBITS) vif;
    uvm_analysis_port #(counter_seq_item #(NBITS)) ap;

    function new(string name = "counter_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
        
        if (!uvm_config_db#(virtual counter_if #(NBITS))::get(this, "", "vif", vif)) begin
          `uvm_fatal("monitor", "vif not found")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        counter_seq_item #(NBITS) trans;

        forever begin
            @(vif.cb_mon);
          
            trans = counter_seq_item#(NBITS)::type_id::create("trans");
            trans.clear = vif.cb_mon.clear;
            trans.count_enable = vif.cb_mon.count_enable;
            trans.overflow_val = vif.cb_mon.overflow_val;
            trans.count_out = vif.cb_mon.count_out;
            trans.overflow_flag = vif.cb_mon.overflow_flag;
          
            ap.write(trans);
        end
    endtask

endclass
`endif
