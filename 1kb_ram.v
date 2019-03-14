module single_port_syn_ram #(
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

reg	[data_width-1:0]	ram [1023:0];

always@(posedge clk or negedge rstn)begin
	if(!rstn)begin
		$display("%t rstn is trigger",$time);
	end
	else begin
		if(en && wr_rdn)begin
			ram[addr] <= data_wr;
		end
	//	else if(!wr_rdn)begin  // direct read without waiting for en
		else if(en && !wr_rdn)begin  // read that waiting for en
			data_rd <= ram[addr];
		end
		else begin
			ram[addr] <= ram[addr];
		end
	end
end

endmodule
