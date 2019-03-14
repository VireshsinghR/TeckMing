module single_port_syn_ram_tb;

reg		clk;
reg		rstn;
reg		en;
reg		wr_rdn;
reg	[9:0]	addr;
reg	[31:0]	data_wr;
wire	[31:0]	data_rd;

reg	[9:0]	x;

single_port_syn_ram dut(clk,rstn,en,wr_rdn,addr,data_wr,data_rd);

initial begin
	clk = 0;
	forever #5 clk = ~clk;
end

initial begin
rstn = 0;
en = 0;
wr_rdn = 0;
addr = 0;
data_wr = 0;
#10;
rstn = 1;
repeat (5) begin
	x = $random;
	write($random,x);
	read(x);
end
$finish;
end

task write;
input [31:0]	data_in;
input [9:0]	addr1;
begin
	@(posedge clk);
	wr_rdn = 1;	
	data_wr = data_in;
	addr = addr1;
	@(posedge clk);
	en = 1;
	@(posedge clk);
	en = 0;
	wr_rdn = 0;
end
endtask

task read;
input [9:0]	addr2;
begin
	@(posedge clk);
	wr_rdn = 0;
	addr = addr2;
	@(posedge clk);
	en = 1;
	@(posedge clk);
	en = 0;
end
endtask
	
endmodule







