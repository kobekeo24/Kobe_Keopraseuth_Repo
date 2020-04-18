`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2020 10:53:32 PM
// Design Name: 
// Module Name: debounce
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


module debounce(
    input clk,
    input btn,
    output reg btn_clr
    );
    
    parameter delay = 650000; //6.5 ms delay
    integer count = 0;
    
    reg xnew = 0;
    
    always @ (posedge clk)
    if (btn != xnew)
        begin 
        xnew <= btn;
        count <= 0;
        end
    else if (count == delay) btn_clr <= xnew;
    else count <= count +1;
endmodule
