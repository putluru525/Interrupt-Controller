class interrupt_mon;
	interrupt_tx tx;
	virtual interrupt_intf vif;
	function new();
		vif=top.pif;
		tx=new();
	endfunction
	task run();
		$display("interrupt_mon RUN TASK called"); 
		forever begin
			//convert interface level to tx level
			//@(posedge vif.pclk_i)
			@(vif.mon_cb);
			if(vif.mon_cb.penable_i==1 && vif.mon_cb.pready_o==1) begin
				tx.paddr_i = vif.mon_cb.paddr_i;
				tx.pwrite_i = vif.mon_cb.pwrite_i;
				if(tx.pwrite_i==1)
					tx.pwdata_i = vif.mon_cb.pwdata_i;
				if(tx.pwrite_i==0)
					tx.prdata_o = vif.mon_cb.prdata_o;
				tx.intr_to_service_o = vif.mon_cb.intr_to_service_o;
				tx.intr_serviced_i = vif.mon_cb.intr_serviced_i;
				tx.intr_valid_o = vif.mon_cb.intr_valid_o;
				tx.intr_active_i = vif.mon_cb.intr_active_i;
				//tx.print("interrupt_mon");
				interrupt_common::mon2cov.put(tx);
				interrupt_common::mon2sbd.put(tx);
			end
		end
	endtask
endclass
