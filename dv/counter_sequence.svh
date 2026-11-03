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
        num_counts inside {[10:100]}; // counts
    }
    
    constraint overflow {
       seq_overflow_val > 0;
    }

    function new(string name = "counter_sequence");
        super.new(name);
    endfunction

    virtual task body();
       counter_transaction #(NBITS) req;
       
        repeat(num_counts) begin
            req = counter_transaction#(NBITS)::type_id::create("req");
            start_item(req);
            
            // lock the transaction overflow
            if (!req.randomize() with {overflow_val == local::seq_overflow_val;}) begin
                `uvm_error("SEQ", "Randomization failed")
            end
            
            finish_item(req);
        end // repeat (num_counts)
        start_item(req);
        req.clear = 0;
        req.count_enable = 0;
        req.overflow_val = seq_overflow_val;
        finish_item(req);
    endtask
endclass

`endif
