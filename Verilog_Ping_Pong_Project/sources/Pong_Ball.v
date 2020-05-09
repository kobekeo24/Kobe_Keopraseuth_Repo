`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//This module controls the functionality of the ball for the pong game.
//////////////////////////////////////////////////////////////////////////////////


module Pong_Ball 
#(parameter Active_width = 640,
parameter Active_height = 480,
parameter ball_width = 20,
parameter ball_height = 20,
parameter Ball_speed = 2_000_000) //25MHz clk / 1250000 = 50 milisecond periods
(
input clk,
input Game_Start,
input [1:0] hit, //when hit = 2'b01 => P1 hit the ball; when hit = 2'b10 hit => P2 hit the ball
input [9:0] Hcount,
input [9:0] Vcount,
output reg Draw_Ball,
output reg [9:0] HBall = (Active_width/2) - (ball_width/2),
output reg [9:0] VBall = (Active_height/2) - (ball_height/2));



localparam P2_DOWN = 2'b00, P2_UP = 2'b01, P1_DOWN = 2'b10, P1_UP = 2'b11;

reg [31:0] Speed_count = 0;


always @ (posedge clk)
begin

if (Speed_count == Ball_speed)
    begin
    Speed_count <= 1'b0;
    if (Game_Start == 1'b0) //restart game => ball starts at center of screen
    begin
        HBall <= (Active_width/2) - (ball_width/2); 
        VBall <= (Active_height/2) - (ball_height/2);
    end
    else if (Game_Start == 1'b1)
    begin
    case(hit) //motion of ball
    P2_DOWN:
        begin
        VBall <= VBall + 1'b1;
        HBall <= HBall - 1'b1;
        end
    P2_UP:
        begin
        VBall <= VBall - 1'b1;
        HBall <= HBall - 1'b1;
        end
      P1_DOWN:
        begin
        VBall <= VBall + 1'b1;
        HBall <= HBall + 1'b1;
        end
    P1_UP:
        begin
        VBall <= VBall - 1'b1;
        HBall <= HBall + 1'b1;
        end
    endcase
    end
    end
else 
    begin
    Speed_count <= Speed_count + 1'b1;
    end
end
//draw ball at location
always @(posedge clk)
  begin
    if (Vcount >= VBall  && Vcount <= VBall + ball_height && Hcount >= HBall && Hcount <= HBall + ball_width)
      Draw_Ball <= 1'b1;
    else
      Draw_Ball <= 1'b0;
  end
endmodule
