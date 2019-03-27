module ram #(
parameter data_width = 32,
parameter addr_width = 10
)(
input logic 				clk,
input logic				rstn,
input logic				en,
input logic				wr_rdn,
input logic	[addr_width-1:0]	addr,
input logic	[data_width-1:0]	data_wr,
output logic	[data_width-1:0]	data_rd
);

reg	[(2**addr_width)-1:0][data_width-1:0] 	ram_mem; 

always@(posedge clk or negedge rstn)begin
		if(en && wr_rdn)begin
			ram_mem[addr] <= data_wr;
			//$display("DUT = %h data has been written into ram address %h at %0t ns ",data_wr,addr,$time);
		end
end

always@(posedge clk or negedge rstn)begin
	if(!rstn)begin
		data_rd <= 0;
		//$display("flip flop in the ram is been reset");
	end
	else begin
		if(en && !wr_rdn)begin  
			data_rd <= ram_mem[addr];
			//$display("DUT = ram address %h data is %h at %0t ns",addr,data_rd,$time);
		end
	end
end

endmodule
