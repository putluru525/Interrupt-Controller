class interrupt_env;
	interrupt_agent agent;
	interrupt_cov cov;
	interrupt_sbd sbd;
	function new();
		agent = new();
		cov = new();
		sbd = new();
	endfunction
	task run();
		fork
			agent.run();
			cov.run();
			sbd.run();
		join
	endtask
endclass
