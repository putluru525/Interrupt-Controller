typedef class interrupt_common;
typedef class interrupt_tx;
typedef class interrupt_env;
typedef class interrupt_agent;
typedef class interrupt_mon;
typedef class interrupt_sbd;
typedef class interrupt_gen;
typedef class interrupt_bfm;
typedef class interrupt_cov;
`include "interrupt_tx.sv";
`include "interrupt_intf.sv";
`include "interrupt_common.sv";
`include "interrupt_gen.sv";
`include "interrupt_bfm.sv";
`include "interrupt_mon.sv";
`include "interrupt_cov.sv";
`include "interrupt_sbd.sv";
`include "interrupt_agent.sv";
`include "interrupt_env.sv";
`include "intr_ctrl.v";
module top;
//steps to write the top module
//1.Declare clk,rst
//2.Generate the clk,rst
//3.instantiate the interface
//4.Instantiate the dut
//5.logic to end the simulation
//6.logic to run the tb of env
bit clk,rst;
event e;
always #5 clk=~clk;
initial begin
	rst=1;
	repeat(2) @(posedge clk)
		rst=0;
	->e;
end
interrupt_intf pif(clk,rst);
intr_ctrl dut(.pclk_i(pif.pclk_i),
		   .prst_i(pif.prst_i),
		   .paddr_i(pif.paddr_i),
		   .pwdata_i(pif.pwdata_i),
		   .prdata_o(pif.prdata_o),
		   .penable_i(pif.penable_i),
		   .pwrite_i(pif.pwrite_i),
		   .pready_o(pif.pready_o),
		   .intr_to_service_o(pif.intr_to_service_o),
		   .intr_serviced_i(pif.intr_serviced_i),
		   .intr_valid_o(pif.intr_valid_o),
		   .intr_active_i(pif.intr_active_i));
interrupt_env env;
initial begin
	env=new();
	wait(e.triggered);
	$value$plusargs("testcase=%s",interrupt_common::testcase);
	env.run();
	end
initial begin
	//#355;
	fork
		wait((interrupt_common::count*2) == (interrupt_common::total_driven_tx));
		#10000;
	join_any
	#20;
	if((interrupt_common::count_mismatches==0) || (interrupt_common::count_matches==interrupt_common::count)) begin
		$display("#######TEST PASSED#######");
		$display("## count of mismatches = %0d ##",interrupt_common::count_mismatches);
		$display("## count of matches = %0d ##",interrupt_common::count_matches);
	end
	else begin
		$display("#######TEST FAILED#######");
		$display("## count of mismatches = %0d ##",interrupt_common::count_mismatches);
		$display("## count of matches = %0d ##",interrupt_common::count_matches);

	end
	$finish();
end
endmodule
