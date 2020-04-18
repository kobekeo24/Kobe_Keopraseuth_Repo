`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2020 12:01:39 AM
// Design Name: 
// Module Name: PWM_generator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PWM_generator(clk,dutyc,pwm_out);
input clk;
input [3:0] dutyc; // from 0 to 15 in decimal form
output reg pwm_out;

reg [3:0] pwmc = 0;
integer count = 0;
reg clk25MHz = 1'b0;

always @ (posedge clk)
begin
if (count == 1) begin
count <= 0;
clk25MHz <= ~clk25MHz;
end
else
begin
count <= count + 1;
end
end

always @ (posedge clk25MHz)
begin
pwmc <= pwmc + 1'b1;
if (pwmc <= dutyc)
    pwm_out <= 1'b1;
else
    pwm_out <= 1'b0;
end
endmodule
