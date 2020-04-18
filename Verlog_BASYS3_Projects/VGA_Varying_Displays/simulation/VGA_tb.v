`timescale 1ns / 1ps

module VGA_tb();

reg clk;
reg [3:0] in;
wire [2:0] red; 
wire [2:0] green; 
wire [1:0] blue;
wire hsync; 
wire vsync;
wire [6:0] seg;
wire [3:0] an;
  
VGA_Top U00(.clk(clk),.sw(in),.red(red),.green(green),.blue(blue),.hsync(hsync),.vsync(vsync),.seg(seg),.an(an));

initial
begin
clk = 0;
in = 3'b000;
#100
in = 3'b001;
#100
in = 3'b010;
#100
in = 3'b011;
#100
in = 3'b100;
#100
in = 3'b101;
#100 
in = 3'b110;
#100
in = 3'b111;
end
always #5 clk = ~clk; //frequency of 100MHz
endmodule
