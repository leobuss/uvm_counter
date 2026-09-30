// driber
//

`ifndef COUNTER_DRIVER_SV
`define COUNTER_DRIVER_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class counter_driver #(parameter NBITS = 4) extends uvm_driver #(counter_transaction #(NBITS));
	`uvm_component_param_utils(counter_driver #(NBITS))
	
	virtual counter_if #(NBITS)vif;

	function new (string name = "counter_driver", uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		if (!uvm_config_db#(virtual socetlib_counter_if #(NBITS))::get(this, "", "vif", vif)) begin
            		`uvm_fatal("Driver", "No interface found");
        	end	
	endfunction


	virtual task run_phase(uvm_phase phase);
		transaction req;
		vif.cb_drv.nRST <= 1'b1;
		vif.cb_drv.clear <= 1'b0;
		vif.cb_drv.count_enable <= 1'b0;
		vif.cb_drv.overflow_val <= '0;

		forever begin
			seq_item_port.get_next_item(req);

			@(vif.cb_drv);

			vif.cb_drv.clear <= req.clear;
            		vif.cb_drv.count_enable <= req.count_enable;
            		vif.cb_drv.overflow_val <= req.overflow_val;
            		seq_item_port.item_done();
		end
	endtask




endclass

`endif
