`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////


module Ping_Pong_Top #(parameter loading = 100_000_000,
                       parameter max_score = 10)
(
  input clk,
  input btnU,
  input btnL,
  input btnR,
  input btnD,
  input btnC,
  output wire [2:0] red, 
  output wire [2:0] green, 
  output wire [2:0] blue,
  output wire hsync, 
  output wire vsync,
  output wire [3:0] an,
  output wire [6:0] seg,
  output wire [15:0] led);
  

parameter VIDEO_WIDTH = 3;
parameter TOTAL_COLS  = 800;
parameter TOTAL_ROWS  = 525;
parameter Active_H = 640;
parameter Active_V = 480;
parameter paddle_width = 20;
parameter paddle_height = 80;
parameter ball_width = 20;
parameter ball_height = 20;

wire P1_up_clr;
wire P1_down_clr;
wire P2_up_clr;
wire P2_down_clr;
wire btnC_clr;

wire [9:0] P1_x;
wire [9:0] P1_y;
wire [9:0] P2_x;
wire [9:0] P2_y;

reg gameStart = 1'b0;
reg enable = 1'b0;
wire [9:0] ColCount;
wire [9:0] RowCount;
reg [31:0] load_count = 1'b0;
wire [9:0] ball_x, ball_y;
wire draw_ball, draw_P1, draw_P2, draw;
reg [4:0] score1, score2 = 1'b0;

wire [VIDEO_WIDTH-1:0] Pattern_Red;
wire [VIDEO_WIDTH-1:0] Pattern_Grn;
wire [VIDEO_WIDTH-1:0] Pattern_Blue;

localparam P2_down = 2'b00, P2_up = 2'b01, P1_down = 2'b10, P1_up = 2'b11; 
reg [1:0] hit = P2_down;
localparam READY = 2'B00, PLAY = 2'B01, GAMEOVER = 2'B10;
reg [1:0] state = READY;

Seven_Segment_Driver show(.clk(clk),.clr(1'b0),.in1(score1[4]),.in2(score1[3:0]),.in3(score2[4])
                    ,.in4(score2[3:0]),.seg(seg),.an(an));


debounce btnc (.clk(clk),.btn(btnC),.btn_clr(btn_C_clr));
debounce btn1 (.clk(clk),.btn(btnU),.btn_clr(P1_up_clr));
debounce btn2 (.clk(clk),.btn(btnL),.btn_clr(P1_down_clr));
debounce btn3 (.clk(clk),.btn(btnR),.btn_clr(P2_up_clr));
debounce btn4 (.clk(clk),.btn(btnD),.btn_clr(P2_down_clr));
  
  VGA_H_V_Gen counter(
.clk(clk),.HSync(hsync),
.VSync(vsync),
.ColCount(ColCount),.RowCount(RowCount)
);

Pong_Paddle 
#(.paddle_start(paddle_width))
  P1
  (.clk(clk),.up(P1_up_clr),.down(P1_down_clr),.hcount(ColCount),.vcount(RowCount),
   .Draw_Paddle(draw_P1),.Paddle_X(P1_x),.Paddle_Y(P1_y));
   
Pong_Paddle 
#(.paddle_start(Active_H))
  P2
  (.clk(clk),.up(P2_up_clr),.down(P2_down_clr),.hcount(ColCount),.vcount(RowCount),
   .Draw_Paddle(draw_P2),.Paddle_X(P2_x),.Paddle_Y(P2_y));

Pong_Ball ball (.clk(clk),.Game_Start(gameStart),.hit(hit),.Hcount(ColCount),.Vcount(RowCount),
                .Draw_Ball(draw_ball),.HBall(ball_x),.VBall(ball_y));


always @ (posedge clk)
begin
    case(state)
    READY:
    begin
        if(load_count == loading)
        begin
            gameStart <= 1'b1;
            load_count <= 1'b0;
            state <= PLAY;
        end
        else
        begin
            load_count <= load_count + 1'b1;
            gameStart <= 1'b0;
        end
    end
    PLAY:
    begin
        if (score1 == max_score || score2 == max_score)
        begin
            score1 <= 1'b0;
            score2 <= 1'b0;
            state <= GAMEOVER;
        end
        else if (ball_x + ball_width == Active_H)
        begin
            score1 <= score1 + 1'b1;
            state <= READY;
        end
        else if (ball_x == 1'b0)
        begin
            score2 <= score2 + 1'b1;
            state <= READY;
        end
        else
        begin
        case(hit)
            P2_down:
            begin
                if(ball_y == Active_V - ball_width)
                begin
                    hit <= P2_up;
                end
                else if (ball_y <= P1_y + paddle_height &&
                        ball_y + ball_height >= P1_y && ball_x == paddle_width ) //p1 hit the ball
                begin
                    hit <= P1_down;
                end
            end
            P2_up:
            begin
                if(ball_y == 1'b0)
                begin
                    hit <= P2_down;
                end
                else if (ball_y <= P1_y + paddle_height &&
                        ball_y + ball_height >= P1_y && ball_x == paddle_width ) //p1 hit the ball
                begin
                    hit <= P1_up;
                end
            end    
            P1_down:
            begin
                if(ball_y + ball_height == Active_V)
                begin
                    hit <= P1_up;
                end
                else if (ball_y  <= paddle_height + P2_y &&
                         ball_y + ball_height >= P2_y && ball_x + ball_width == P2_x) //p2 hit the ball
                begin
                    hit <= P2_down;
                end
            end
            P1_up:
            begin
                if(ball_y == 0)
                begin
                    hit <= P1_down;
                end
                else if (ball_y  <= paddle_height + P2_y &&
                         ball_y + ball_height >= P2_y && ball_x + ball_width == P2_x) //p2 hit the ball
                begin
                    hit <= P2_up;
                end
            end 
        endcase
    end
    end
    GAMEOVER:
    begin
        gameStart <= 1'b0;
        if (btnC_clr == 1'b1)
        begin
            state <= READY;
        end
        else
        begin
            state <= GAMEOVER;
        end
    end
    endcase
end

assign draw = draw_ball || draw_P1 || draw_P2;
assign red = (draw == 1'b1) ? {VIDEO_WIDTH{1'b1}} : 0;
assign green = (draw == 1'b1) ? {VIDEO_WIDTH{1'b1}} : 0;
assign blue = (draw == 1'b1) ? {VIDEO_WIDTH{1'b1}} : 0;
assign led = (state == GAMEOVER) ? {15{1'b1}} : 15'd0;

endmodule
