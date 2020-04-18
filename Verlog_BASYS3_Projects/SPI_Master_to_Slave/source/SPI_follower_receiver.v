`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//receiving process of slave from master
//////////////////////////////////////////////////////////////////////////////////


module SPI_follower_receiver(sck,ss,mosi,data,busy,ready);

parameter data_length = 8;

input sck;
input ss;
input mosi;
output reg [data_length - 1:0] data;
output reg busy = 0;
output reg ready =0;

localparam RDY = 2'b00, RECEIVE = 2'b01, STOP = 2'b10;
reg [1:0] state = RDY;

reg [data_length-1:0] data_temp = 0;
reg [7:0] index = data_length-1;

always @ (posedge sck)

case (state)
RDY:
    if (!ss)
    begin
    data_temp[index] <= mosi;
    index <= index -1;
    busy <= 1;
    ready <= 0;
    state <= RECEIVE;
    end
RECEIVE:
    begin
    if(index == 0) //keep waiting for data until the last bit is received
    state <= STOP;
    else index <= index - 1;
    data_temp[index] <= mosi;
    end
STOP:
    begin 
    busy <= 0;
    ready <= 1;
    data_temp <= 0;
    data <= data_temp;
    index <= data_length-1;
    state <= RDY;
    end
endcase
endmodule
