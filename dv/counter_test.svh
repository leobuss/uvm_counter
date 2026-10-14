`ifndef COUNTER_TEST_SVH
`define COUNTER_TEST_SVH

import uvm_pkg::*;
`include "uvm_macros.svh"

class counter_test extends uvm_test;
    `uvm_component_utils(counter_test)

    counter_env #(4) env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = counter_env#(4)::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        counter_sequence #(4) seq;
        seq = counter_sequence#(4)::type_id::create("seq");

        phase.raise_objection(this);

        if (!seq.randomize()) begin
            `uvm_error("TEST", "Sequence randomization failed")
        end

        seq.start(env.agent.sqr);

        phase.drop_objection(this);
    endtask
endclass
`endif
