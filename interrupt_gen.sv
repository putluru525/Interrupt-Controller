class interrupt_gen;
	interrupt_tx tx;
	bit [3:0]addr[$];
	bit [3:0]temp;
	rand bit [3:0]addr_arr[15:0];
	constraint arr_unique{ unique {addr_arr};
		};
	constraint arr_values{ foreach(addr_arr[i])
				addr_arr[i] inside {[0:15]};
		};
	task run();
		assert(this.randomize());
		$display("interrupt_gen RUN TASK called");
		case(interrupt_common::testcase)
			"test_one_tx":begin
				tx=new();
				assert(tx.randomize());
				interrupt_common::gen2bfm.put(tx);
				tx.print("interrupt_gen");
			end
			"test_rand_wr_rd":begin
				for(int i=0;i<interrupt_common::count;i++) begin
				tx=new();
				assert(tx.randomize() with {tx.pwrite_i==1;});
				//addr.push_back(tx.paddr_i);
				tx.paddr_i = this.addr_arr[i];
				interrupt_common::gen2bfm.put(tx);
				tx.print("interrupt_write_gen");
				end
				for(int i=0;i<interrupt_common::count;i++) begin
				tx=new();
				tx.pwdata_i.rand_mode(0);
				//temp=addr.pop_front();
				temp = this.addr_arr[i];
				assert(tx.randomize() with {tx.pwrite_i==0;
							    tx.paddr_i==temp;});
				interrupt_common::gen2bfm.put(tx);
				tx.print("interrupt_read_gen");
				end
			end
			"test_no_interrupt":begin
				tx=new();
				assert(tx.randomize() with {tx.intr_active_i==0;});
				interrupt_common::gen2bfm.put(tx);
				tx.print("no_interrupt_gen");
			end

			"test_interrupt_active":begin
				for(int i=0;i<NUM_INTR;i++) begin
					tx=new();
					assert(tx.randomize() with {tx.intr_active_i[i]==1;});
					interrupt_common::gen2bfm.put(tx);
					tx.print("interrupt_active_gen");
			end
			end
			"test_interrupt_service":begin
				tx=new();
				assert(tx.randomize() with {tx.intr_serviced_i==1;});
				interrupt_common::gen2bfm.put(tx);
				tx.print("interrupt_service_gen");
			end

		endcase

	endtask
endclass
