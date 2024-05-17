class interrupt_cov;
	interrupt_tx tx;
	//reg [2:0]state;
	parameter NUM_INTR=16;
	parameter S_NO_INTR=3'b001;
	parameter S_INTR_ACTIVE=3'b010;
	parameter S_INTR_GIVEN_TO_SERVICE=3'b100;
	covergroup interrupt_cg;
		WR_RD_CP:coverpoint tx.pwrite_i{
			bins WR_BIN={1};
			bins RD_BIN={0};
			}
		ADDR_CP:coverpoint tx.paddr_i{
			option.auto_bin_max=16;
			}
		WR_RD_CP_X_ADDR_CP:cross WR_RD_CP,ADDR_CP;
		TCP_CP:coverpoint $root.top.dut.state{
			bins nointr2intract		={S_NO_INTR->S_INTR_ACTIVE};
			bins intract2intrgiv2ser	={S_INTR_ACTIVE->S_INTR_GIVEN_TO_SERVICE};
			bins intrgiv2ser2intract   	={S_INTR_GIVEN_TO_SERVICE->S_INTR_ACTIVE};
			bins intrgiv2ser2nointr		={S_INTR_GIVEN_TO_SERVICE->S_NO_INTR};
			}
	endgroup
function new();
	interrupt_cg=new();
endfunction
	task run();
		$display("interrupt_cov RUN TASK called");
		forever begin
			interrupt_common::mon2cov.get(tx);
			interrupt_cg.sample();
		end
	endtask
endclass
