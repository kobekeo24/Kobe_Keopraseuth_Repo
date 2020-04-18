`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2020 12:37:02 PM
// Design Name: 
// Module Name: moving_wave_top
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


module moving_wave_top(clk,sw,led);

input clk;
input [2:0] sw;
output reg [15:0] led = 0;

reg [3:0] dutyc = 0;

wire led_out;

PWM_generator pwm1(.clk(clk),.dutyc(dutyc),.pwm_out(led_out));

reg [27:0] clock_div = 0;
reg [3:0] led_index = 0;

always @ (posedge clk)
begin
clock_div <= clock_div + 1;
led[led_index - 1'b1] <= 0;
led[led_index] <= led_out;

case(led_index)
    4'b0000 : dutyc <= 4'b0000; //0
    4'b0001 : dutyc <= 4'b0001; //1
    4'b0010 : dutyc <= 4'b0010; //2
    4'b0011 : dutyc <= 4'b0011; //3
    4'b0100 : dutyc <= 4'b0100; //4
    4'b0101 : dutyc <= 4'b0101; //5
    4'b0110 : dutyc <= 4'b0110; //6
    4'b0111 : dutyc <= 4'b0111; //7
    4'b1000 : dutyc <= 4'b1000; //8
    4'b1001 : dutyc <= 4'b1001; //9
    4'b1010 : dutyc <= 4'b1010; //10
    4'b1011 : dutyc <= 4'b1011; //11
    4'b1100 : dutyc <= 4'b1100; //12
    4'b1101 : dutyc <= 4'b1101; //13
    4'b1110 : dutyc <= 4'b1110; //14
    4'b1110 : dutyc <= 4'b1110; //14
endcase
end

always @ (posedge clock_div[20 + sw])
led_index <= led_index + 1'b1;
endmodule
