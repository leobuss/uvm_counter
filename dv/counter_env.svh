`ifndef COUNTER_ENV_SVH
`define COUNTER_ENV_SVH

import uvm_pkg::*;
`include "uvm_macros.svh"

class counter_env #(parameter int NBITS = 4) extends uvm_env;
    `uvm_component_param_utils(counter_env #(NBITS))
    counter_agent #(NBITS) agent;
    counter_scoreboard #(NBITS) scoreboard;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = counter_agent#(NBITS)::type_id::create("agent", this);
        scoreboard = counter_scoreboard#(NBITS)::type_id::create("scoreboard", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.ap.connect(scoreboard.ap_imp);
    endfunction
endclass
`endif
