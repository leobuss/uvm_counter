`ifndef COUNTER_SCOREBOARD_SVH
`define COUNTER_SCOREBOARD_SVH

import uvm_pkg::*;
`include "uvm_macros.svh"

class counter_scoreboard #(parameter int NBITS = 4) extends uvm_scoreboard;
    `uvm_component_param_utils(counter_scoreboard #(NBITS))

    uvm_analysis_imp #(counter_transaction #(NBITS), counter_scoreboard #(NBITS)) ap_imp;

    logic [NBITS-1:0] expected_count;
    logic expected_overflow_flag;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        expected_count = 0;
        expected_overflow_flag = 0;
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap_imp = new("ap_imp", this);
    endfunction

    virtual function void write(counter_transaction #(NBITS) tr);
        logic [NBITS-1:0] next_count;

       	// check for reset
       	if (!tr.nRST) begin
            expected_count = 0;
            expected_overflow_flag = 0;
            return;
        end

        // comapre
        if (tr.count_out !== expected_count) begin
            `uvm_error("SCBD_COUNT", $sformatf("Exp: %0d, Got: %0d", expected_count, tr.count_out))
        end
        
        if (tr.overflow_flag !== expected_overflow_flag) begin
            `uvm_error("SCBD_OVF", $sformatf("Exp flag: %0b, Got: %0b", expected_overflow_flag, tr.overflow_flag))
        end

        if (tr.clear) begin
            next_count = 0;
        end else if (tr.count_enable) begin
            if (expected_count + 1 > tr.overflow_val)
                next_count = 1; // Wraps to 1
            else
                next_count = expected_count + 1;
        end else begin
            next_count = expected_count;
        end

        expected_overflow_flag = (next_count == tr.overflow_val) ? 1'b1 : 1'b0;
        expected_count = next_count;
    endfunction
endclass
`endif
