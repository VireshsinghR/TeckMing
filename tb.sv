module mem_tb ();

parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 10;

reg                  clk =0;
reg                  rst;
reg                  wr_rd; 						// 1= wr, 0 = rd 
reg [ADDR_WIDTH-1:0] addr;
reg [DATA_WIDTH-1:0] wr_data;
reg                  en;

wire [DATA_WIDTH-1:0]rd_data;

int unsigned tb_db[*];
reg [ADDR_WIDTH-1:0]temp_addr;

typedef struct { reg wr_rd;
reg [ADDR_WIDTH-1:0]addr;
reg [DATA_WIDTH-1:0]wr_data;
reg en;
bit [DATA_WIDTH-1:0]rd_data;
} cycle;

cycle PREV_CYCLE;
cycle PRESENT_CYCLE;
//cycle temp_PREV_CYCLE;

bit first_cycle;

int data_matched;
int data_mismatched;

mem dut (.clk(clk), .rst(rst), .wr_rd(wr_rd), .addr(addr), .wr_data(wr_data), .en(en), .rd_data(rd_data));

//bit [0:4][ADDR_WIDTH-1:0]addr_array;

initial 
begin
  forever #5 clk = ~clk;
end

initial 
begin
	automatic int j=0;
	
	 	begin
		reset();
		end

	repeat(3000)
		begin			//Drive randomized i/p to DUT
		@(negedge clk);
	       	en	<= $random;
		wr_rd	<= $urandom;
		wr_data	<= $urandom;
		addr	<= $urandom; 
	end

	$display("data matched   = %0d times", data_matched);
	$display("data mismatched   = %0d times", data_mismatched);
#200 $finish;
end

always @(posedge clk)		//Saving the writes
begin
		if(en && wr_rd) 
		begin
		 tb_db[addr] = wr_data; 
	  	end
end

always @(posedge clk)			//Check rd_data 
  begin			
  if(PREV_CYCLE.en) 
    begin
    if(PREV_CYCLE.wr_rd && (PREV_CYCLE.rd_data == rd_data))				// if Write cycle then rd_data remains unchanged
      begin
      data_matched <= data_matched + 1;
      print(PREV_CYCLE, 1, PREV_CYCLE.rd_data, rd_data);
      end	

    else if ((!PREV_CYCLE.wr_rd) && (tb_db.exists(PREV_CYCLE.addr)))		// if Read cycle then compare the database with the read data		
      begin
      if(rd_data == tb_db[PREV_CYCLE.addr]) 
        begin
	print(PREV_CYCLE, 1, tb_db[PREV_CYCLE.addr], rd_data);
	data_matched <= data_matched + 1;
	end

      else 
        begin									
	print(PREV_CYCLE, 0, tb_db[PREV_CYCLE.addr], rd_data );
	data_mismatched <= data_mismatched + 1;
	end
      end

     else if ( !tb_db.exists(PREV_CYCLE.addr) && (rd_data == 0) )			//if location is not written 
       begin
       data_matched <= data_matched + 1;
       end
    end
	  	
     else if(!PREV_CYCLE.en && (PREV_CYCLE.rd_data == rd_data))		// if Mem not enabled then rd_data remains unchanged
       begin
       data_matched <= data_matched + 1;
       end

       PREV_CYCLE.en 		<= en;
       PREV_CYCLE.wr_rd	<= wr_rd;
       PREV_CYCLE.wr_data	<= wr_data;
       PREV_CYCLE.addr		<= addr;
       PREV_CYCLE.rd_data	<= rd_data;
end

task reset();
	rst 	<= 0;
	en	<= 'bz;
	wr_rd	<= 'bz;
	addr	<= 'bz;
       	wr_data <= 'bz;	
	first_cycle	<=0;
	data_matched 	<=0;
	data_mismatched	<=0;
	#10;
	rst <=1;
endtask

function print(cycle temp_PREV_CYCLE, bit match, int exp_data, int got_data);
	if(match)
		$display("DATA MATCHED");
	else
		$display("DATA MISMATCHED");

	$display("PREV_CYCLE.en      = %0d", PREV_CYCLE.en);
	$display("PREV_CYCLE.wr_rd   = %0d", temp_PREV_CYCLE.wr_rd);
	$display("PREV_CYCLE.addr    = %0d", PREV_CYCLE.addr);
	$display("PREV_CYCLE.rd_data = %0h", temp_PREV_CYCLE.rd_data);

	$display("EXPECTED_DATA = %0h", exp_data);
	$display("READ_DATA     = %0h", rd_data);

	$display("-------------------------------------------------------");
	
endfunction

endmodule
