`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Creates Digital Safe that allows user to set password to open and lock.
//////////////////////////////////////////////////////////////////////////////////


module Digitial_Safe(
    input clk,
    input [15:0] sw,
    input btnC,
    input btnU,
    input btnD,
    output [1:0] led,
    output [3:0] an,
    output [6:0] seg
    );
    
    wire btnCclr, btnDclr, btnUclr;
    
    debounce dbc(clk,btnC,btnCclr);
    debounce dbu(clk,btnU,btnUclr);
    debounce dbd(clk,btnD,btnDclr);
    
    reg [3:0] disp1 = 4'b0;
    reg [3:0] disp2 = 4'b0;
    reg [3:0] disp3 = 4'b0;
    reg [3:0] disp4 = 4'b0;
    
    Seven_Segment_Driver seg7(clk,1'b0,disp1,disp2,disp3,disp4,seg,an);
    wire [1:0] safestate;
    
    Safe(clk,sw,btnUclr,btnDclr,btnCclr,safestate);
    
    always @ (posedge clk)
    case(safestate)
    2'b00: {disp1,disp2,disp3,disp4} <= {4{4'b1100}}; //C
    2'b01: {disp1,disp2,disp3,disp4} <= {4{4'b0000}}; //0
    2'b10: {disp1,disp2,disp3,disp4} <= sw; //enterpass
    2'b11: {disp1,disp2,disp3,disp4} <= {4{4'b0101}}; //s
    endcase
    
    assign led = safestate;
endmodule
