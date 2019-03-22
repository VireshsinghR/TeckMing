
//`include "params.sv"

module mem#(
parameter DATA_WIDTH = 32,
parameter ADDR_WIDTH = 10
)(
input clk,
input rst,
input wr_rd, 						// 1= wr, 0 = rd 
input [ADDR_WIDTH-1 :0]addr,
input [DATA_WIDTH-1 :0]wr_data,
input en,
output reg [DATA_WIDTH-1 :0]rd_data
);

 bit [0:2**ADDR_WIDTH-1][DATA_WIDTH-1:0]mem_1k;

always @(posedge clk or negedge rst)
begin
	if(en && wr_rd)
			begin				// write
			mem_1k[addr] <= wr_data;
			//$display("DUT: Writing: %0h to addr: %0d at time ", wr_data, addr, $time);
			end
end

always @(posedge clk or negedge rst)
begin
	if(!rst)
	begin
		rd_data<= 32'b0;
		//$display("Reset detected");
	end

	else if(en && !wr_rd)
			begin				//read
			rd_data <= mem_1k[addr];
			//$display("DUT: Reading: %0h from addr: %0d at time ",rd_data, addr, $time);
			end

end

endmodule
