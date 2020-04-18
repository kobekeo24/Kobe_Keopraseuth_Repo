`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//transmission of master
//////////////////////////////////////////////////////////////////////////////////


module SPI_leader_transmitter(clk,data,send,sck,ss,mosi,busy);

parameter data_length = 8;

input clk;
input [data_length - 1:0] data;
input send;
output reg sck = 0;
output reg ss = 1;
output reg mosi;
output reg busy = 0;

localparam RDY = 2'b00, START = 2'b01, TRANSMIT = 2'b10, STOP = 2'b11;

reg [1:0] state = RDY;
reg [7:0] clkdiv = 0;
reg [7:0] index = 0;

always @ (posedge clk)
//sck is set to 2 Mhz
if (clkdiv == 8'd24)
    begin
    clkdiv <= 0;
    sck <= ~sck; //toggles sck
    end
else clkdiv <= clkdiv + 1; 

always @ (negedge sck)

case(state)
RDY:
    if (send)
    begin
    state <= START;
    busy <= 1;
    index <= data_length - 1;
    end
START:
    begin
    ss <= 0; // enables communication
    mosi <= data[index]; //data to be transmitted to slave
    index <= index -1;
    state <= TRANSMIT;
    end
TRANSMIT:
    begin
    if (index == 0) //keep transmitting data serially until the last bit is transmitted
    state <= STOP;
    mosi <= data[index];
    index <= index - 1;
    end
STOP:
    begin
    busy <= 0;
    ss <= 1;
    state <= RDY;
    end
endcase
endmodule
