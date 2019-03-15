module mem_tb ();
reg clk =0;
reg rst;
reg wr_rd; 						// 1= wr, 0 = rd 
reg [`ADDR_WIDTH-1:0]addr;
reg [`DATA_WIDTH-1:0]wr_data;
reg en;
wire [`DATA_WIDTH-1:0]rd_data; 

mem dut (.clk(clk), .rst(rst), .wr_rd(wr_rd), .addr(addr), .wr_data(wr_data), .en(en), .rd_data(rd_data));

bit [`ADDR_WIDTH-1:0]addr_array[10];


initial 
begin
	forever #5 clk = ~clk;
end


initial 
begin
	automatic int j=0;
	
	fork 
		begin
		reset();
		end

		begin
		foreach(addr_array[i]) 
			begin	addr_array[i] = $urandom; end
				
		end
	join

	repeat(5) begin
			@(posedge clk);
			write(addr_array[j++]); 
		  end
		
		 j=0;
	repeat(5) begin
			@(posedge clk); 
			read(addr_array[j++]);
				
		  end

#200 $finish;
end

function void write(input bit [`ADDR_WIDTH-1:0]wr_addr);
	en	<=1;
	wr_rd 	<=1;
	addr	<= wr_addr;
	wr_data <= $urandom;
endfunction

function void read( input bit [`ADDR_WIDTH-1:0]rd_addr);
	en	<=1;
	wr_rd 	<=0;
	 $display ("rd_addr= %0h",rd_addr);
	addr	<= rd_addr;
endfunction

task reset();
	rst <= 0;
	#10;
	rst <=1;
endtask

endmodule
