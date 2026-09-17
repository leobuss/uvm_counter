`ifndef SOCETLIB_COUNTER_SEQ_ITEM_SV
`define SOCETLIB_COUNTER_SEQ_ITEM_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class counter_transaction #(parameter int NBITS = 4) extends uvm_sequence_item;
    rand logic clear;
    rand logic count_enable;
    rand logic [NBITS-1:0] overflow_val;

    logic [NBITS-1:0] count_out;
    logic overflow_flag;

    `uvm_object_param_utils_begin(counter_transaction #(NBITS))
        `uvm_field_int(clear, UVM_ALL_ON)
        `uvm_field_int(count_enable, UVM_ALL_ON)
        `uvm_field_int(overflow_val, UVM_ALL_ON)
        `uvm_field_int(count_out, UVM_ALL_ON)
        `uvm_field_int(overflow_flag, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "counter_transaction");
        super.new(name);
    endfunction

    constraint clear_c 
    {
        clear dist {1 := 5, 0 := 95}; // high only 5% 
    }

    constraint overflow_val_c
    {
        overflow_val > 0;
    }
endclass
'endif
