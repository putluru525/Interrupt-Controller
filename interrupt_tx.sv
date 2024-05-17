parameter NUM_INTR=16;
parameter S_NO_INTR=3'b001;
parameter S_INTR_ACTIVE=3'b010;
parameter S_INTR_GIVEN_TO_SERVICE=3'b100;

class interrupt_tx;
	rand bit [3:0]paddr_i;
	rand bit [3:0]pwdata_i;
	     bit [3:0]prdata_o;
	rand bit penable_i;
	rand bit pwrite_i;
	     bit pready_o;
	     bit [3:0]intr_to_service_o;
	rand bit intr_serviced_i;
	     bit intr_valid_o;
	rand bit [15:0]intr_active_i;
function void print(string name="interrupt_tx");
	$display("printing from%s",name);
	$display("paddr_i=%h",paddr_i);
	$display("pwdata_i=%h",pwdata_i);
	$display("prdata_o=%h",prdata_o);
	$display("penable_i=%b",penable_i);
	$display("pwrite_i=%b",pwrite_i);
	$display("pready_o=%b",pready_o);
	$display("intr_to_service_o=%h",intr_to_service_o);
	$display("intr_serviced_i=%b",intr_serviced_i);
	$display("intr_valid_o=%b",intr_valid_o);
	$display("intr_active_i=%h",intr_active_i);
endfunction
endclass
