interface interrupt_intf(input logic pclk_i,prst_i);
	logic [3:0]paddr_i;
	logic [3:0]pwdata_i;
	logic [3:0]prdata_o;
	logic penable_i;
	logic pwrite_i;
	logic pready_o;
	logic [3:0]intr_to_service_o;
	logic intr_serviced_i;
	logic intr_valid_o;
	logic [15:0]intr_active_i;
clocking bfm_cb@(posedge pclk_i);
	default input #0 output #1;
	output paddr_i;
	output pwdata_i;
	input prdata_o;
	output penable_i;
	output pwrite_i;
	input pready_o;
	input intr_to_service_o;
	output intr_serviced_i;
	input intr_valid_o;
	output intr_active_i;
endclocking
clocking mon_cb@(posedge pclk_i);
	default input #0 output #1;
	input paddr_i;
	input pwdata_i;
	input prdata_o;
	input penable_i;
	input pwrite_i;
	input pready_o;
	input intr_to_service_o;
	input intr_serviced_i;
	input intr_valid_o;
	input intr_active_i;
endclocking
endinterface
