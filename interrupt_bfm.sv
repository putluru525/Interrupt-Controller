class interrupt_bfm;
	interrupt_tx tx;
	virtual interrupt_intf vif;
	function new();
		vif=top.pif;
	endfunction
	task run();
		$display("interrupt_bfm RUN TASK called");
		forever begin
			interrupt_common::gen2bfm.get(tx);
			drive_tx(tx);
			interrupt_common::total_driven_tx++;
			tx.print("interrupt_bfm");
		end
	endtask
	task drive_tx(interrupt_tx tx);
		//@(posedge vif.pclk_i);
		@(vif.bfm_cb)
		vif.bfm_cb.penable_i<=1;
		vif.bfm_cb.paddr_i <= tx.paddr_i;
		vif.bfm_cb.pwrite_i <= tx.pwrite_i;
		if(tx.pwrite_i==1)
			vif.bfm_cb.pwdata_i <= tx.pwdata_i;
		wait(vif.bfm_cb.pready_o==1);
		if(tx.pwrite_i==0)
			tx.prdata_o = vif.bfm_cb.prdata_o;
		vif.bfm_cb.intr_serviced_i <= tx.intr_serviced_i;
		vif.bfm_cb.intr_active_i <= tx.intr_active_i;
		tx.intr_to_service_o = vif.bfm_cb.intr_to_service_o;
		tx.intr_valid_o = vif.bfm_cb.intr_valid_o;

	endtask
endclass
