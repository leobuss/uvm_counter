`ifndef COUNTER_SEQUENCE_SVH
`define COUNTER_SEQUENCE_SVH

import uvm_pkg::*;
`include "uvm_macros.svh"

class counter_sequence #(parameter int NBITS = 4) extends uvm_sequence #(counter_transaction #(NBITS));
    `uvm_object_param_utils(counter_sequence #(NBITS))

    // Sequence-level variables
    rand int unsigned num_counts;
    rand logic [NBITS-1:0] seq_overflow_val; 

    constraint counts {
        num_counts inside {[5:20]}; // Enough cycles to see a rollover
    }
    
    constraint overflow {
        seq_overflow_val > 2; // Ensure it takes a few cycles to overflow
    }

    function new(string name = "counter_sequence");
        super.new(name);
    endfunction

    virtual task body();
        repeat(num_counts) begin
            req = counter_transaction#(NBITS)::type_id::create("req");
            start_item(req);
            
            // lock the transaction overflow
            if (!req.randomize() with { 
                clear == 0; 
                count_enable == 1; 
                overflow_val == local::seq_overflow_val; 
            }) begin
                `uvm_error("SEQ", "Randomization failed")
            end
            
            finish_item(req);
        end
    endtask
endclass

`endif
