`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2020 01:09:53 AM
// Design Name: 
// Module Name: Clock
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


module Clock(
    input clk,
    input en,
    input rst,
    input hrup,
    input minup,
    output [3:0] s1,
    output [3:0] s2,
    output [3:0] m1,
    output [3:0] m2,
    output [3:0] h1,
    output [3:0] h2
    );
    
    //time display
    //h2 h1 : m2 m1
    reg [5:0] hour = 0, min = 0, sec = 0;
    
    integer clkc = 0;
    localparam onesec = 100000000; //one second
    always @ (posedge clk)
    begin
    //reset clock
    if (rst == 1'b1)
        {hour,min,sec} <= 0;
        
    //set clock
    else if (minup == 1'b1)
        if(min == 6'd59)
            min <= 0;
        else
            min <= min + 1'd1;
            
    else if (hrup == 1'b1)
        if(hour == 6'd23)
            hour <= 0;
        else
            hour <= hour + 1'd1;
    
    //count
    else if (en == 1'b1)
        if (clkc == onesec)
        begin
        clkc <= 0;
        if ( sec == 6'd59)
            begin
            sec <= 0;
            if(min ==6'd59)
                begin
                min <= 0;
                if(hour == 6'd23)
                hour <= 0;
                else
                hour <= hour + 1'd1;
                end
            else
            min <= min + 1'd1;
            end
            else
            sec <= sec + 1'd1;
            end
            else
            clkc <= clkc + 1;
    end
    binaryToBCD secs(sec,,,s2,s1);
    binaryToBCD mins(min,,,m2,m1);
    binaryToBCD hours(hour,,,h2,h1);
            
endmodule
