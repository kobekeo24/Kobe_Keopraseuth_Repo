`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//This project takes in data from the user input from a serial terminal and outputs it on the leds.
//////////////////////////////////////////////////////////////////////////////////


module uart_rx_top(
    input clk,
    input RsRx,
    output reg [15:0] led
    );
    
    localparam RX_RDY = 2'b00, RX_WAIT = 2'b01, RX_DATARDY = 2'b10;
    
    reg [1:0] state = RX_RDY;
    
    wire data_ready;
    wire [7:0] out;
    wire parity;
    wire error;
    
    uart_rx_ctrl rx(.clk(clk),.rx(RsRx),.data(out),.parity(parity),.ready(data_ready),.error(error));
    
    always @ (posedge clk)
    
    case (state)
    RX_RDY:
        if (!data_ready) state <= RX_WAIT;
    RX_WAIT:
        if (data_ready) state <= RX_DATARDY;
    RX_DATARDY:
        begin
        led[9:0] <= {error,parity,out}; //displays binary input from serial monitar on leds
        led[15:10] <= led[15:10] + 1'b1;
        state <= RX_RDY;
        end
    endcase
endmodule
