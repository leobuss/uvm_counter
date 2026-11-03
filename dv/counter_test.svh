`ifndef COUNTER_TEST_SVH
`define COUNTER_TEST_SVH

import uvm_pkg::*;
`include "uvm_macros.svh"

class counter_test extends uvm_test;
    `uvm_component_utils(counter_test)

    counter_env #(4) env;
    virtual counter_interface #(4) vif;
    

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = counter_env#(4)::type_id::create("env", this);

       if (!uvm_config_db#(virtual counter_interface #(4))::get(this, "", "vif", vif)) begin
         `uvm_fatal("Test", "Virtual interface not found")
     end
    endfunction

    task run_phase(uvm_phase phase);
        counter_sequence #(4) rand_seq;
        counter_directed_sequence #(4) dir_seq;
       

        phase.raise_objection(this);
       `uvm_info("Test", "random tests", UVM_LOW)
       repeat(50) begin
	  rand_seq = counter_sequence#(4)::type_id::create("rand_seq");
	  if (!rand_seq.randomize()) begin
                `uvm_fatal("Test", "Sequence randomization failed")
          end
	  rand_seq.start(env.agent.sqr);
	  repeat(10) @(posedge vif.CLK);
       end

       `uvm_info("Test", "directed tests", UVM_LOW)
       dir_seq = counter_directed_sequence#(4)::type_id::create("dir_seq");
       dir_seq.start(env.agent.sqr);
       repeat(3) @(posedge vif.CLK);

        // directed test leaves count at 5
        if (vif.count_out !== 4'd5) begin
            `uvm_error("reset", "count wrong before asynchronous reset")
        end

        // reset between rising and falling edge
        @(negedge vif.CLK);
        #1ns;
        vif.nRST = 1'b0;

        // check
        #1ns;
        if (vif.count_out !== '0 || vif.overflow_flag !== 1'b0) begin
            `uvm_error("reset", "Asynchronous reset failed")
        end
        repeat(2) @(posedge vif.CLK);

        @(negedge vif.CLK);
        #1ns;
        vif.nRST = 1'b1;

        repeat(3) @(posedge vif.CLK);

       phase.drop_objection(this);
       
    endtask
endclass
`endif
