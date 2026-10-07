`ifndef COUNTER_SEQUENCER_SVH
`define COUNTER_SEQUENCER_SVH

import uvm_pkg::*;
`include "uvm_macros.svh"

class counter_sequencer #(parameter int NBITS = 4) extends uvm_sequencer #(counter_transaction #(NBITS));
    `uvm_component_param_utils(counter_sequencer #(NBITS))

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

`endif