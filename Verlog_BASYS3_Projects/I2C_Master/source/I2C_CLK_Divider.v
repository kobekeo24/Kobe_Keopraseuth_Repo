`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//This module divides the input clk, in order to output the correct data clock for I2C communication.
//////////////////////////////////////////////////////////////////////////////////


module I2C_CLK_Divider(clk,reset,divider,scl_clk,data_clk,data_clk_prev);
input clk;
input reset;
input divider;
output reg scl_clk;
output reg data_clk;
output reg data_clk_prev;

reg [31:0] count = 0;

always @ (posedge clk, negedge reset)
begin
if (reset == 0)
count <= 0;
else
begin
data_clk_prev <= data_clk;
if(count == divider*4-1) count <= 0; //reset count
else
begin
count <= count + 1'b1;
if (count >= 0 && count < divider-1)
begin
scl_clk <= 0;
data_clk <= 0;
end
else if (count >= divider && count < divider*2-1) 
begin
scl_clk <= 0;
data_clk <= 1;
end
else if (count >= divider*2 && count < divider*3-1)
begin
scl_clk <= 1;
data_clk <= 1;
end
else if (count >= divider*3 && count < divider*4-1) begin
scl_clk <= 1;
data_clk <= 0;
end
else begin
scl_clk <= scl_clk;
data_clk <= data_clk;
end
end
end
end

endmodule
