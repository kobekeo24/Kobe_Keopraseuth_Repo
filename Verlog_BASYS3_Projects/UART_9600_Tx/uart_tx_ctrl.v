`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2020 07:18:25 PM
// Design Name: 
// Module Name: uart_tx_ctrl
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


module uart_tx_ctrl(
    input send,
    input clk,
    input [7:0] data,
    output ready,
    output uart_tx
    );
    parameter baud = 9600; //baud rate
    parameter bit_index_max = 10; //number of bits being transmitted
    localparam [31:0] baud_timer = 100_000_000/baud; //number clk cycles for each bit transmission
    localparam RDY = 2'b00, LOAD_BIT = 2'b01, SEND_BIT = 2'b10;
    
    reg [1:0] state = RDY;
    reg [31:0] timer = 0;
    reg [9:0] txData;
    reg [3:0] bitIndex;
    reg txBit = 1'b1;
    
    always @ (posedge clk)
    
    case(state)
    RDY:
        begin
        if (send) //WAIT FOR TRANSMITT SIGNAL
        begin
        txData <= {1'b1, data, 1'b0}; //{stop bit,data,start bit}
        state <= LOAD_BIT;
        end
        timer <= 14'b0;
        bitIndex <= 0;
        txBit <= 1'b1;
        end
    LOAD_BIT:
        begin
        state <= SEND_BIT;
        txBit <= txData[bitIndex];
        bitIndex <= bitIndex + 1'b1;
        end
    SEND_BIT:
        if (timer == baud_timer) //bit has been transmitted
        begin
        timer <= 14'b0;
        if (bitIndex == bit_index_max) //all data has has been transmitted
        state <= RDY;
        else state <= LOAD_BIT;
        end
        else timer <= timer + 1'b1;
    default:
        state <= RDY;
    endcase
    
    assign uart_tx = txBit; //TRANSMITTED BIT
    assign ready = (state == RDY); //SIGNAL TO INDICATE THAT TRANMISSION IS OCCURING
endmodule
