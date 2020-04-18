`timescale 1ns / 1ps
/////////////////////////////////////
//Created By: Kobe Keopraseuth
// This project allows the user to set the time, which will be in military time.
////////////////////////////////////


module Digital_Clock(
    input clk,
    input [0:0] sw,
    input btnC,
    input btnU,
    input btnR,
    output [6:0] seg,
    output [3:0] an,
    output [7:0] led
    );
    
    wire [3:0] s1, s2, m1, m2, h1, h2;
    reg hrup,minup;
    
    wire btnCclr, btnUclr, btnRclr;
    reg btnCclr_prev, btnUclr_prev, btnRclr_prev;
    
    debounce dbc(clk,btnC,btnCclr);
    debounce dbu(clk,btnU,btnUclr);
    debounce dbr(clk,btnR,btnRclr);
    
    Seven_Segment_Driver seg7(clk,1'b0,h2,h1,m2,m1,seg,an);
    Clock clock1(clk,sw[0],btnCclr,hrup,minup,s1,s2,m1,m2,h1,h2);
    
    always @ (posedge clk)
    begin
    btnUclr_prev <= btnUclr;
    btnRclr_prev <= btnRclr;
    if (btnUclr_prev == 1'b0 && btnUclr == 1'b1) hrup <= 1'b1; else hrup <= 1'b0;
    if (btnRclr_prev == 1'b0 && btnRclr == 1'b1) minup <= 1'b1; else minup <= 1'b0;
    end
    assign led[7:0] = {s2,s1};
    
    
endmodule
