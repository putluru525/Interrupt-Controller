class interrupt_common;
	static string testcase;
	static mailbox#(interrupt_tx) gen2bfm=new();
	static mailbox#(interrupt_tx) mon2cov=new();
	static mailbox#(interrupt_tx) mon2sbd=new();
	static int count_matches;
	static int count_mismatches;
	static int count=16;
	static int total_driven_tx;
endclass
