class interrupt_sbd;
	bit [3:0]assoc_arr[int];
	interrupt_tx tx;
	task run();
		$display("interrupt_sbd RUN TASK called");
		forever begin
			interrupt_common::mon2sbd.get(tx);
			if(tx.pwrite_i==1) begin
				assoc_arr[tx.paddr_i]=tx.pwdata_i;
			end			
			else begin
				if(assoc_arr[tx.paddr_i]==tx.prdata_o) begin
					interrupt_common::count_matches++;
					$display("count_matches=%0d",interrupt_common::count_matches);
				end
				else begin
					interrupt_common::count_mismatches++;
					$display("count_mismatches=%0d",interrupt_common::count_mismatches);
				end
			end
		end
	endtask
endclass
