`timescale 1ns / 1ps


module Clk_Divider(clk,count,clk_out);

input clk; //count
input [1:0] count; 
output reg clk_out = 0; 
integer tick = 0;

//clk_out <= 0;
always @ (posedge clk)
begin
if(tick == count)
begin
    clk_out <= ~clk_out; //clk_out = clk/((count+1)*2)
    tick <= 0;
end
else
    tick <= tick + 1;
end



endmodule
