module intr_ctrl(
//processor 
input pclk_i,input prst_i,input [3:0]paddr_i,input [3:0]pwdata_i,output reg [3:0]prdata_o,input penable_i,input pwrite_i,output reg pready_o,output reg [3:0]intr_to_service_o,input intr_serviced_i,output reg intr_valid_o,
//peripheral
input [15:0]intr_active_i
);
parameter NUM_INTR=16;
parameter S_NO_INTR=3'b001;
parameter S_INTR_ACTIVE=3'b010;
parameter S_INTR_GIVEN_TO_SERVICE=3'b100;

//priority register declarartion
reg [3:0]priority_regA[NUM_INTR-1:0];
reg [2:0]state,next_state;
reg first_match_flag;
reg high_prio;
reg intr_with_highest_prio;
always @(posedge pclk_i)begin//same like memory design
	if(prst_i==1)begin
		prdata_o=0;
		pready_o=0;
		intr_to_service_o=0;
		intr_valid_o=0;
		state=S_NO_INTR;
		next_state=S_NO_INTR;
		for(int i=0;i<NUM_INTR;i=i+1)begin
			priority_regA[i]=0;
		end
	end
	else begin
		if(penable_i==1)begin
			pready_o=1;
			if(pwrite_i==1)begin
				priority_regA[paddr_i]=pwdata_i;
			end
			else begin
				prdata_o=priority_regA[paddr_i];
			end
		end
		else begin
			pready_o=0;
		end
	end
end
always@(posedge pclk_i)begin
	if(prst_i==0)begin
		case(state)
			S_NO_INTR:begin
				if(intr_active_i!=0)begin
					next_state=S_INTR_ACTIVE;
					first_match_flag=1;//got the first valid interrupt
				end
			end
			S_INTR_ACTIVE:begin
				for(int i=0;i<NUM_INTR;i=i+1)begin
					if(intr_active_i[i]==1)begin
						if(first_match_flag==1)begin
							high_prio=priority_regA[i];
							intr_with_highest_prio = i;
							first_match_flag=0;
						end
						else begin
							if(priority_regA[i] > high_prio)begin
								high_prio=priority_regA[i];
								intr_with_highest_prio = i;
								
							end
						end
					end
				end
				intr_to_service_o = intr_with_highest_prio;
				intr_valid_o=1;
				next_state = S_INTR_GIVEN_TO_SERVICE;
			end
			S_INTR_GIVEN_TO_SERVICE:begin
				if(intr_serviced_i==1)begin
					first_match_flag=1;
					intr_with_highest_prio=0;
					high_prio=0;
					intr_valid_o=0;
					intr_to_service_o=0;
					if(intr_active_i!=0)begin
						next_state=S_INTR_ACTIVE;
					end
					else begin
						next_state=S_NO_INTR;
					end

				end
			end
		endcase
	end
end
always@(next_state) state = next_state;
endmodule
