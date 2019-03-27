module ram_tb;
parameter data_width = 32;
parameter addr_width = 10;
parameter times_of_wr = 1000000;

reg				clk;
reg				rstn;
reg				en;
reg				wr_rdn;
reg	[addr_width-1:0]	addr;
reg	[data_width-1:0]	data_wr;
reg	[data_width-1:0]	data_rd;

int	unsigned		tb_ram[*];

typedef struct{
	bit rstn;
	bit en;
	bit wr_rdn;
	reg[addr_width-1:0] addr;
	reg[data_width-1:0] data_wr;
	reg[data_width-1:0] data_rd;
}one_cycle;

one_cycle					prev_cycle;
int						data_match;
int						data_mismatch;
int						rseed;

ram dut(clk,rstn,en,wr_rdn,addr,data_wr,data_rd);

initial begin
	clk = 0;
	forever #5 clk = ~clk;
end

initial begin
rstn <= 0;
en <= 0;
wr_rdn <= 0;
addr <= 0;
data_wr <= 0;
data_match <= 0;
data_mismatch <= 0;
rseed <= 0;
#10;
rstn <= 1;
repeat(times_of_wr)begin
	@(posedge clk);
	rseed <= rseed + 1;
	en <= $random(rseed);
	wr_rdn <= $random(rseed);
	addr <= $random(rseed);
	data_wr <= $random(rseed);
end

$display("Data matched = %d times",data_match);
$display("Data mismatched = %d times",data_mismatch);
$finish;
end

always@(posedge clk)begin
	if(prev_cycle.en && prev_cycle.wr_rdn)begin	// write previous cycle data into testbench array to mimic dut
		tb_ram[prev_cycle.addr] = prev_cycle.data_wr;
	       // $display("RAM[%h] = %h",prev_cycle.addr,prev_cycle.data_wr);
	end
end


always@(posedge clk)begin
	if(!prev_cycle.rstn)begin	// previous cycle rstn
		if(data_rd == 0)begin	 
			data_match <= data_match + 1;
			save_cycle;
		end 
		else begin
			data_mismatch <= data_mismatch + 1;
			$display("1.Previous Reset Cycle, Expected data = %h, Read data = %h at %tns",32'b0,data_rd,$time);
			save_cycle;
		end
	end	
	else if(prev_cycle.en && prev_cycle.wr_rdn)begin	// previous write cycle
		if(prev_cycle.data_rd===data_rd)begin 
			data_match <= data_match + 1;
			save_cycle;
			end
		else begin
			data_mismatch <= data_mismatch + 1;
			$display("2.Previous Write Cycle, prev_cycle.data_rd = %h, data_rd = %h at %0tns",prev_cycle.data_rd, data_rd,$time);
			save_cycle;
		end	
	end	
	else if(prev_cycle.en && !prev_cycle.wr_rdn && (tb_ram.exists(prev_cycle.addr)))begin	//previous read cycle with written addr
		if(data_rd === tb_ram[prev_cycle.addr])begin
			data_match <= data_match + 1;
			save_cycle;
		end
		else begin
			data_mismatch <= data_mismatch + 1;
			$display("3.Previously Read cycle with Address written with data, Expected data = %h, Read data = %h at %0tns",tb_ram[prev_cycle.addr],data_rd,$time);
			save_cycle;
		end
	end
	else if(prev_cycle.en && !prev_cycle.wr_rdn && (!tb_ram.exists(prev_cycle.addr)))begin	//previous read cycle with not written addr
		if(data_rd===32'bx)begin
			data_match <= data_match + 1;
			save_cycle;
		end
		else begin
			data_mismatch <= data_mismatch + 1;
			$display("4.Previously read cycle with Address no data written, Expected data = %h, Read data = %h at %tns",tb_ram[prev_cycle.addr],data_rd,$time);
			save_cycle;
		end
	end
	else if(!prev_cycle.en)begin	//previous disable cycle
		if(prev_cycle.data_rd===data_rd)begin
			data_match <= data_match + 1;
			save_cycle;
		end
		else begin
			data_mismatch <= data_mismatch + 1;
			$display("5.Previously disable cycle,Expected data = %h, Read data = %h at %tns",prev_cycle.data_rd,data_rd,$time);
			save_cycle;
		end
	end
end

function save_cycle;
begin
	prev_cycle.rstn <= rstn;
	prev_cycle.en <= en;
	prev_cycle.wr_rdn <= wr_rdn;
	prev_cycle.addr <= addr;
	prev_cycle.data_wr <= data_wr;
	prev_cycle.data_rd <= data_rd;
end
endfunction


endmodule







