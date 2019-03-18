module ram #(
parameter data_width = 32,
parameter addr_width = 10
)(
input				clk,
input				rstn,
input				en,
input				wr_rdn,
input	[addr_width-1:0]	addr,
input	[data_width-1:0]	data_wr,
output reg[data_width-1:0]	data_rd
);

reg	[data_width-1:0]	ram [(2**addr_width)-1:0];

always@(posedge clk or negedge rstn)begin
	if(!rstn)begin
		data_rd <= 0;
		$display("flip flop in the ram is been reset");
	end
	else begin
		if(en && wr_rdn)begin
			ram[addr] = data_wr;
			$display("DUT = %h data has been written into ram address %h at %0t ns ",data_wr,addr,$time);
		end
	//	else if(!wr_rdn)begin  // direct read without waiting for en
		else if(en && !wr_rdn)begin  // read that waiting for en
			data_rd = ram[addr];
			$display("ram address %h data is %h at %0t ns",addr,data_rd,$time);
		end
		else begin
			ram[addr] = ram[addr];
		end
	end
end

endmodule
