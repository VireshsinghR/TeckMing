
`include "params.sv"

module mem(
input clk,
input rst,
input wr_rd, 						// 1= wr, 0 = rd 
input [`ADDR_WIDTH-1 :0]addr,
input [`DATA_WIDTH-1 :0]wr_data,
input en,
output reg [`DATA_WIDTH-1 :0]rd_data
);

reg [`DATA_WIDTH-1 :0]mem_1k [0:1023];

always @(posedge clk or negedge rst)
begin
	if(!rst)
	begin
		$display("Reset detected");
	end
	
	begin
	case ({en, wr_rd})
		'b0x: 	begin
			$display("Memory not enabled");
			rd_data<= 32'bz;
			end

		'b10:   begin				//read
			rd_data <= mem_1k[addr];
			$display("DUT: Reading: %0h from addr: %0d at time ",rd_data, addr, $time);
			end

		'b11:   begin				// write
			mem_1k[addr] <= wr_data;
			$display("DUT: Writing: %0h to addr: %0d at time ", wr_data, addr, $time);
			end

		default: $display("Default case");
					
	endcase
	end	
	
end

endmodule
