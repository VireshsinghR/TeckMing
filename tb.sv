module ram_tb;
parameter data_width = 32;
parameter addr_width = 10;
parameter times_of_wr = 3;
reg				clk;
reg				rstn;
reg				en;
reg				wr_rdn;
reg	[addr_width-1:0]	addr;
reg	[data_width-1:0]	data_wr;
wire	[data_width-1:0]	data_rd;

reg	[addr_width-1:0]	x;

ram dut(clk,rstn,en,wr_rdn,addr,data_wr,data_rd);

reg	[addr_width-1:0]	temp_reg	[times_of_wr-1:0];
integer				i;

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
/*
repeat(times_of_wr)begin
	write_then_read;
end
*/
multiple_write(times_of_wr);
rstn = 0;
read(x);
rstn = 1;
read(x);
#10;
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
	$display("tb = %h data has been send to ram address %h at %0t ns ",data_in,addr,$time);
	@(posedge clk);
	en = 0;
	wr_rdn = 0;
end
endtask


task read; //read with en
input [addr_width-1:0]	addr2;
begin
	@(posedge clk);
	en = 1;
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

task write_then_read;
begin
	x = $random;
	write($random,x);
	read(x);
end
endtask

task multiple_write;
input [times_of_wr-1:0] wr_times;
begin
	for(i=0;i<wr_times;i++)begin
		x = $random;
		write($random,x);
		temp_reg[i] = x;
	end
	for(i=0;i<wr_times;i++)begin
		read(temp_reg[i]);
	end
end
endtask

endmodule







