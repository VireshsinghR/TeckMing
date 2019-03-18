module ram_tb;
parameter data_width = 32;
parameter addr_width = 10;
reg				clk;
reg				rstn;
reg				en;
reg				wr_rdn;
reg	[addr_width-1:0]	addr;
reg	[data_width-1:0]	data_wr;
wire	[data_width-1:0]	data_rd;

reg	[addr_width-1:0]	x;

ram dut(clk,rstn,en,wr_rdn,addr,data_wr,data_rd);

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
repeat (3) begin
	x = $random;
	write($random,x);
	read(x);
end
rstn = 0;
read(x);
rstn = 1;
#30;
$finish;
end

task write;
input [data_width-1:0]	data_in;
input [addr_width-1:0]	addr1;
begin
	@(posedge clk);
	en = 1;
	@(posedge clk);
	wr_rdn = 1;	
	data_wr = data_in;
	addr = addr1;
	$display("tb = %h data has been written into ram address %h at %0t ns ",data_wr,addr,$time);
	@(posedge clk);
	en = 0;
	wr_rdn = 0;
end
endtask


task read; //read with en
input [addr_width-1:0]	addr2;
begin
	@(posedge clk);
	en = 1;@(posedge clk);
	wr_rdn = 0;
	addr = addr2;	
	@(posedge clk);
	en = 0;
end
endtask


/*
task read; //read without en
input [addr_width-1:0]	addr2;
begin
	@(posedge clk);
	wr_rdn = 0;
	addr = addr2;
end
endtask
*/	
endmodule







