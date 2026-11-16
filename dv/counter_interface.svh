// chnaged the file to interfasce instead of if

`ifndef SOCETLIB_COUNTER_INTERFACE_SVH
`define SOCETLIB_COUNTER_INTERFACE_SVH

interface counter_interface #(parameter int NBITS = 4) (input logic CLK);
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
    endclocking // cb_mon

// --------------- Functional Coverage ----------------------------------------
   localparam int MAX_VAL = (1 << NBITS) - 1; // makes bins more modular
   covergroup counter_covergroup @(posedge CLK);
      option.per_instance = 1;

      // every overflow threshold
      cp_limit: coverpoint overflow_val iff (nRST)
      {
       bins each_limit[] = {[1:MAX_VAL]};
      }

      // has every possible overflow val
      cp_overflow_reached: coverpoint overflow_val iff (nRST && overflow_flag && count_out == overflow_val)
      {
	 bins each_reached[] = {[1:MAX_VAL]};
      }

      // actually wraps around for each overflow val
      cp_wraps: coverpoint overflow_val iff (nRST && !clear && count_enable && (count_out + 1) > overflow_val)
      {
	 bins each_wrap[] = {[1:MAX_VAL]};
      }

      cp_count_out: coverpoint count_out iff(nRST)
      {
	 bins count_out[] = {[0:MAX_VAL]};
      }

      cp_clear: coverpoint clear iff (nRST)
      {
	 bins on = {1};
	 bins off = {0};
      }

      cp_enable: coverpoint count_enable iff (nRST)
      {
	 bins on = {1};
	 bins off = {0};
      }

      cp_overflow_flag: coverpoint overflow_flag iff (nRST)
      {
	 bins on = {1};
	 bins off = {0};
      }

      crosses: cross cp_clear, cp_enable;
   endgroup // counter_covergroup

   counter_covergroup cov = new();

   covergroup reset_covergroup @(negedge nRST);
       option.per_instance = 1;

       cp_reset: coverpoint nRST
       {
            bins asserted = {0};
       }

   endgroup // reset_covergroup

   reset_covergroup reset_cov = new();
									     

      

endinterface
`endif
