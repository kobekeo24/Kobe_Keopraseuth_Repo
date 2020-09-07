`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 09/06/2020 07:49:35 AM
// Design Name: 
// Module Name: fifo
// Project Name:  FIFO
// Description: First in First out Memory (8x64)
//////////////////////////////////////////////////////////////////////////////////


module fifo
#(parameter depth = 64,
  parameter af = 57,
  parameter ae = 7)
(
input clk,
input reset,
input [7:0] wr_data,
input write,
input read,
output reg [7:0] re_data,
output wire overflow,
output wire underflow,
output wire  Full,
output wire Almost_Full,
output wire Empty,
output wire Almost_empty
);

reg [7:0] fifo [depth-1:0];
reg [7:0] fifo_count = 0;
reg [7:0] wr_count = 0;
reg [7:0] re_count = 0;

always @ (posedge clk)
    if(reset) begin
        //re-initialize
        fifo_count = 0;
        wr_count = 0;
        re_count = 0;
    end
        
    else
        //keep track of where to write
        if (write && !read) begin 
            
            if(wr_count == depth-1) begin 
                fifo[wr_count] <= wr_data; //write data
                wr_count = 0;
            end
            else if(!Full) begin
                fifo[wr_count] <= wr_data; //write data
                wr_count <= wr_count +'b1;
            end
        end
        //keep track of where to read
        else if (!write && read) begin 
            if(re_count == depth-1) begin
                re_data <= fifo[re_count]; //read data
                re_count = 0;
            end
            else if(!Empty) begin
                re_data <= fifo[re_count]; //read data
                re_count <= re_count +'b1;
            end
        end



always @ (posedge clk)
    //keep track of fifo size
    if (write && !read) begin 
        fifo_count <= fifo_count + 1'b1;
    end
    else if (!write && read) begin 
        fifo_count <= fifo_count - 1'b1; 
    end

//output flags 
assign Full = (fifo_count == depth) ? 1'b1 : 1'b0;
assign Almost_Full = (fifo_count == af) ? 1'b1 : 1'b0;

assign Empty = (fifo_count == 0) ? 1'b1 : 1'b0;
assign Almost_empty = (fifo_count == ae) ? 1'b1 : 1'b0;

assign underflow = (read && Empty) ? 1'b1 : 1'b0;
assign overflow = (write && Full) ? 1'b1 : 1'b0;

endmodule
