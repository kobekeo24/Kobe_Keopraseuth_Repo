`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2020 05:23:09 PM
// Design Name: 
// Module Name: Display_Seven_Segment
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


module Display_Seven_Segment(
    input [3:0] digit, //4-bit value to be displayed as 0 to 9
    output reg [6:0] seven_seg // seven segment display
    );
    //creating a set of constraints for the seven segment display
    //        a
    //        --  
    //      |     |
    //    f | g   | b
    //        --
    //      |     |
    //    e | d   | c
    //        --
    // 7'bGFEDCBA active low
    parameter zero = 7'b100_0000;
    parameter one = 7'b111_1001;
    parameter two = 7'b010_0100;
    parameter three = 7'b011_0000;
    parameter four = 7'b001_1001;
    parameter five = 7'b001_0010;
    parameter six = 7'b000_0010;
    parameter seven = 7'b111_1000;
    parameter eight = 7'b000_0000;
    parameter nine = 7'b001_0000;
    parameter A = 7'b000_1000;
    parameter B = 7'b000_0011;
    parameter C = 7'b100_0110;
    parameter D = 7'b010_0001;
    parameter E = 7'b000_0110;
    parameter F = 7'b000_1110;
    
    always @(digit)
    case(digit)
    0: seven_seg = zero;
    1: seven_seg = one;
    2: seven_seg = two;
    3: seven_seg = three;
    4: seven_seg = four;
    5: seven_seg = five;
    6: seven_seg = six;
    7: seven_seg = seven;
    8: seven_seg = eight;
    9: seven_seg = nine;
    4'b1010: seven_seg = A;
    4'b1011: seven_seg = B;
    4'b1100: seven_seg = C;
    4'b1101: seven_seg = D;
    4'b1110: seven_seg = E;
    4'b1111: seven_seg = F;
    default: seven_seg = zero;
    endcase
endmodule
