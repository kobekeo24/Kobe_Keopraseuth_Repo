`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2020 11:05:09 PM
// Design Name: 
// Module Name: Safe
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


module Safe(
    input clk,
    input [15:0] passinput,
    input pass_set,
    input pass_reg,
    input pass_lock,
    output reg [1:0] safestate
    );
    //00:locked(c), 01: open(o), 10:enterpass, 11:pass changed(s)
    
    localparam ENTERPASS = 1'b0, SETPASS = 1'b1;
    reg [1:0] state = ENTERPASS;
    reg [15:0] pass = 16'h1234;
    
    always @ (posedge clk)
    
    case(state)
    ENTERPASS:
        if (passinput == pass && pass_set == 1'b1)
        begin
        state <= SETPASS;
        safestate <= 2'b10;
        end
        else if (passinput == pass)
        safestate <= 2'b01;
        else safestate <= 2'b00;
    SETPASS:
        if (pass_reg == 1'b1)
        begin
        pass <= passinput;
        safestate <= 2'b11; end
        else if (pass_lock == 1'b1)
        state <= ENTERPASS;
    endcase
endmodule
