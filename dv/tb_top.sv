`timescale 1ns / 10ps

import uvm_pkg::*;
`include "uvm_macros.svh"

module tb_top;
    parameter int NBITS = 4;
    logic clk;
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    // Instantiate interface
    counter_interface #(NBITS) vif(.CLK(clk));

    // Instantiate DUT[cite: 3]
    socetlib_counter #(NBITS) dut (
        .CLK(clk),
        .nRST(vif.nRST),
        .clear(vif.clear),
        .count_enable(vif.count_enable),
        .overflow_val(vif.overflow_val),
        .count_out(vif.count_out),
        .overflow_flag(vif.overflow_flag)
    );

    initial begin
        // Reset sequence
        vif.nRST = 0;
        vif.clear = 0;
        vif.count_enable = 0;
        vif.overflow_val = '0; 
        #20 vif.nRST = 1;
    end
    initial begin
        uvm_config_db #(virtual counter_interface #(NBITS))::set(null, "*", "vif", vif);

        // Start the UVM test
        run_test("counter_test");
    end

    initial begin
        $dumpfile("dump.vcd"); 
        $dumpvars(0, tb_top);
    end
endmodule
