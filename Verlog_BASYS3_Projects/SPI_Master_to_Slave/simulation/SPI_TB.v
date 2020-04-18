`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//This simulation demonstrates the comunication between master and slave for SPI communication.
//////////////////////////////////////////////////////////////////////////////////


module SPI_TB();
reg clk;
reg [7:0] datain;
reg send;
wire sck;
wire mosi;
wire ss;
wire busy1;

wire [7:0] dataout;
wire busy2;
wire ready;

SPI_leader_transmitter U0(clk,datain,send,sck,ss,mosi,busy1);

SPI_follower_receiver U1(sck,ss,mosi,dataout,busy2,ready);

initial begin
clk = 0;
send = 1;
#5
datain <= 8'b10010101;
#4740
datain <= 8'b01010100;
end
always #5 clk = ~clk;
endmodule

