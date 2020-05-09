`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//This module controls the functionality of the paddle for the pong game.
//////////////////////////////////////////////////////////////////////////////////


module Pong_Paddle 
#(parameter paddle_speed = 2_000_000,
  parameter paddle_start = 20,
  parameter paddle_width = 20,
  parameter paddle_height = 80,
  parameter Active_width = 640,
  parameter Active_height = 480)
  (input clk,
   input up,
   input down,
   input [9:0] hcount,
   input [9:0] vcount,
   output wire Draw_Paddle,
   output reg [9:0] Paddle_X = paddle_start - paddle_width ,
   output reg [9:0] Paddle_Y = (Active_height/2) - (paddle_height/2)); //center paddle
   
reg [31:0] speed_count = 1'b0; 

always @ (posedge clk)
begin
    if(speed_count == paddle_speed)
    begin
    speed_count <= 1'b0;
        if(Paddle_Y == 0 && up == 1'b1) // paddle will stop moving up, once it reaches the top of the screen
            begin
            Paddle_Y <= 0;
            end
        else if (Paddle_Y == Active_height - paddle_height && down == 1'b1) //paddle will stop moving down, once it reaches the bottom of the screen
            begin
            Paddle_Y <= Active_height - paddle_height;
            end
        else
            begin
            if (up == 1'b1)
            begin
                Paddle_Y <= Paddle_Y - 1'b1;
            end
             else if (down == 1'b1)
             begin
                Paddle_Y <= Paddle_Y + 1'b1;
            end
        end
    end
    else
    begin
        speed_count <= speed_count + 1'b1;
    end
    
    
end
   
assign Draw_Paddle = (hcount <= Paddle_X + paddle_width && hcount >= Paddle_X 
                      && vcount <= Paddle_Y + paddle_height && vcount >= Paddle_Y)
                      ? (1'b1) : (1'b0);
endmodule
