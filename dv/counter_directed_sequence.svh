
`ifndef COUNTER_DIRECTED_SEQUENCE_SVH
`define COUNTER_DIRECTED_SEQUENCE_SVH

import uvm_pkg::*;
`include "uvm_macros.svh"

class counter_directed_sequence #(parameter int NBITS = 4)
    extends uvm_sequence #(counter_transaction #(NBITS));

    `uvm_object_param_utils(counter_directed_sequence #(NBITS))

    function new(string name = "counter_directed_sequence");
        super.new(name);
    endfunction

    // sends a transaction with explicit inputs - to test for edge cases
    task send(bit clr, bit en, logic [NBITS-1:0] limit);
        counter_transaction #(NBITS) req;
        req = counter_transaction#(NBITS)::type_id::create("req");

        start_item(req);
        req.clear = clr;
        req.count_enable = en;
        req.overflow_val = limit;
        finish_item(req);
    endtask

    virtual task body();

        // normal counting
        `uvm_info("Directed Test", "Normal counting", UVM_LOW)
        send(1, 0, 10);                // clear
        repeat(5) send(0, 1, 10);     // count to 5

        // Disabled counting
        `uvm_info("Directed Test", "Count disabled", UVM_LOW)
        repeat(3) send(0, 0, 10);     // Hold at 5

        // testing clear functionality
        `uvm_info("Directed Test", "Clear", UVM_LOW)
       send(1, 0, 10); // clear
        send(0, 0, 10);

        // clear vs count enable priority
        `uvm_info("Directed Test", "Clear priority", UVM_LOW)
        repeat(3) send(0, 1, 10);
        send(1, 1, 10);
        send(0, 0, 10);

        // overflow
        `uvm_info("Directed Test", "Overflow", UVM_LOW)
        send(1, 0, 7);
        repeat(8) send(0, 1, 7);
        send(0, 0, 7);


       
        // change overflow mid count
        `uvm_info("Directed Test", "dynamic overflow val", UVM_LOW)
        send(1, 0, 10);
        repeat(5) send(0, 1, 10);
        send(0, 1, 3);
        send(0, 0, 3);

       
        // min overflow (1)
        `uvm_info("Directed Test", "Minimum threshold", UVM_LOW)
        send(1, 0, 1);
        repeat(4) send(0, 1, 1);
        send(0, 0, 1);

        // max overflow (4 bit at least)
        `uvm_info("Directed Test", "Maximum threshold", UVM_LOW)
        send(1, 0, '1);
        repeat(16) send(0, 1, '1);
        send(0, 0, '1);



       
        // count up a cew times for nRST test
        send(1, 0, 10);
        repeat(5) send(0, 1, 10);
        send(0, 0, 10);

    endtask
endclass

`endif
