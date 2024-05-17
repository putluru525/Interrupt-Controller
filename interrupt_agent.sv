class interrupt_agent;
	interrupt_gen gen;
	interrupt_bfm bfm;
	interrupt_mon mon;
	function new();
		gen=new();
		bfm=new();
		mon=new();
	endfunction
	task run();
		fork
			gen.run();
			bfm.run();
			mon.run();
		join
	endtask
endclass
