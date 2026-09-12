`ifndef SOCETLIB_COUNTER_IF_SV
`define SOCETLIB_COUNTER_IF_SV

interface socetlib_counter_if #(parameter int NBITS = 4) (input logic CLK);
    logic nRST;
    logic clear;
    logic count_enable;
    logic [NBITS-1:0] overflow_val;
    logic [NBITS-1:0] count_out;
    logic overflow_flag;

    clocking cb_drv @(posedge CLK);
        default input #1ns output #1ns;
        output nRST, clear, count_enable, overflow_val;
        input count_out, overflow_flag;
    endclocking

    clocking cb_mon @(posedge CLK);
        default input #1ns output #1ns;
        input nRST, clear, count_enable, overflow_val, count_out, overflow_flag;
    endclocking

endinterface
`endif