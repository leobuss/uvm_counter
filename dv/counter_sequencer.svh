`ifndef COUNTER_SEQUENCER_SVH
`define COUNTER_SEQUENCER_SVH

import uvm_pkg::*;
`include "uvm_macros.svh"

class counter_sequencer extends uvm_sequence #(counter_transaction);
    `uvm_object_utils(count_n_times_seq)
  
    function new(string name = "count_n_times_seq");
        super.new(name);
    endfunction

    virtual task body();
        repeat(num_counts) begin
            req = counter_transaction::type_id::create("req");
            start_item(req);
          
            if (!req.randomize() with { clear == 0; count_enable == 1; }) begin
                `uvm_error("SEQ", "Randomization failed")
            end
            
            finish_item(req);
        end
    endtask
endclass

`endif
