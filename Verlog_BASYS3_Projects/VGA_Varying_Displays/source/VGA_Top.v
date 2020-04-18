`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Typed by Kobe Keopraseuth
//Inspired by Nandland.com
//This project displays different images through the Vga port, using the switcheds,on the Board, to choose which image to display.
//////////////////////////////////////////////////////////////////////////////////


module VGA_Top(  
  input clk,
  input [3:0] sw,
  output reg [2:0] red, 
  output reg [2:0] green, 
  output reg [1:0] blue,
  output wire hsync, 
  output wire vsync,
  output wire [6:0] seg,
  output reg [3:0] an);

parameter VIDEO_WIDTH = 3;
parameter TOTAL_COLS  = 800;
parameter TOTAL_ROWS  = 525;
parameter Active_H = 640;
parameter Active_V = 480;
wire [9:0] ColCount;
wire [9:0] RowCount;
//wire clk25;
  wire [VIDEO_WIDTH-1:0] Pattern_Red[0:15];
  wire [VIDEO_WIDTH-1:0] Pattern_Grn[0:15];
  wire [VIDEO_WIDTH-1:0] Pattern_Blu[0:15];
  
  wire [6:0] w_Bar_Width;
  wire [2:0] w_Bar_Select;
  
  //displays the image index of the images.
  Display_Seven_Segment disp(sw,seg);

//Horizontal and Vertical counter and front/back porch enable.  
VGA_H_V_Gen counter(
.clk(clk),.HSync(hsync),
.VSync(vsync),
.ColCount(ColCount),.RowCount(RowCount)
);
/////////////////////////////////////////////////////////////////////////////
  // Pattern 0: All black
  /////////////////////////////////////////////////////////////////////////////
  assign Pattern_Red[0] = 0;
  assign Pattern_Grn[0] = 0;
  assign Pattern_Blu[0] = 0;
  
  /////////////////////////////////////////////////////////////////////////////
  // Pattern 1: All Red
  /////////////////////////////////////////////////////////////////////////////
  assign Pattern_Red[1] = (ColCount < Active_H && RowCount < Active_V) ? {VIDEO_WIDTH{1'b1}} : 0;// all 1's
  assign Pattern_Grn[1] = 0;
  assign Pattern_Blu[1] = 0;

  /////////////////////////////////////////////////////////////////////////////
  // Pattern 2: All Green
  /////////////////////////////////////////////////////////////////////////////
  assign Pattern_Red[2] = 0;
  assign Pattern_Grn[2] = (ColCount < Active_H && RowCount < Active_V) ? {VIDEO_WIDTH{1'b1}} : 0;
  assign Pattern_Blu[2] = 0;
  
  /////////////////////////////////////////////////////////////////////////////
  // Pattern 3: All Blue
  /////////////////////////////////////////////////////////////////////////////
  assign Pattern_Red[3] = 0;
  assign Pattern_Grn[3] = 0;
  assign Pattern_Blu[3] = (ColCount < Active_H && RowCount < Active_V) ? {VIDEO_WIDTH{1'b1}} : 0;

  /////////////////////////////////////////////////////////////////////////////
  // Pattern 4: Checkerboard white/black
  /////////////////////////////////////////////////////////////////////////////
  assign Pattern_Red[4] = ColCount[5] ^ RowCount[5] ? {VIDEO_WIDTH{1'b1}} : 0;
  assign Pattern_Grn[4] = Pattern_Red[4];
  assign Pattern_Blu[4] = Pattern_Red[4];
  
  
  /////////////////////////////////////////////////////////////////////////////
  // Pattern 5: Color Bars
  // Divides active area into 8 Equal Bars and colors them accordingly
  //white,yellow,cyan,green,violet,red,blue,black
  /////////////////////////////////////////////////////////////////////////////
  assign w_Bar_Width = Active_H/8;
  assign Pattern_Red[5] = ((RowCount < 480) && (ColCount < w_Bar_Width*1 || ColCount < w_Bar_Width*2 || ColCount < w_Bar_Width*5 || ColCount < w_Bar_Width*6 )) ? {VIDEO_WIDTH{1'b1}} : 0;
					 
  assign Pattern_Grn[5] = ((RowCount < 480) && (ColCount < w_Bar_Width*1 || ColCount < w_Bar_Width*2 || ColCount < w_Bar_Width*3 || ColCount < w_Bar_Width*4 )) ? {VIDEO_WIDTH{1'b1}} : 0;
                  
                 
					 					 
  assign Pattern_Blu[5] = ((RowCount < 480) && (ColCount < w_Bar_Width*1 || ColCount < w_Bar_Width*3 || ColCount < w_Bar_Width*5 || ColCount < w_Bar_Width*7 )) ? {VIDEO_WIDTH{1'b1}} : 0;


  /////////////////////////////////////////////////////////////////////////////
  // Pattern 6: Black With White Border
  // Creates a black screen with a white border 2 pixels wide around outside.
  /////////////////////////////////////////////////////////////////////////////
  assign Pattern_Red[6] = (RowCount <= 1 || RowCount >= Active_V-1-1 ||
                           ColCount <= 1 || ColCount >= Active_H-1-1) ?
                          {VIDEO_WIDTH{1'b1}} : 0;
  assign Pattern_Grn[6] = Pattern_Red[6];
  assign Pattern_Blu[6] = Pattern_Red[6];
  
  

  /////////////////////////////////////////////////////////////////////////////
  // Select between different test patterns
  /////////////////////////////////////////////////////////////////////////////
  always @(posedge clk)
  begin
    an <= 4'b1110;
    case (sw)
      3'b000 : 
      begin
	    red <= Pattern_Red[0];
        green <= Pattern_Grn[0];
        blue <= Pattern_Blu[0];
      end
      3'b001 :
      begin
        red <= Pattern_Red[1];
        green <= Pattern_Grn[1];
        blue <= Pattern_Blu[1];
      end
      3'b010 :
      begin
        red <= Pattern_Red[2];
        green <= Pattern_Grn[2];
        blue <= Pattern_Blu[2];
      end
      3'b011 :
      begin
        red <= Pattern_Red[3];
        green <= Pattern_Grn[3];
        blue <= Pattern_Blu[3];
      end
      3'b100 :
      begin
        red <= Pattern_Red[4];
        green <= Pattern_Grn[4];
        blue <= Pattern_Blu[4];
      end
      3'b101 :
      begin
        red <= Pattern_Red[5];
        green <= Pattern_Grn[5];
        blue <= Pattern_Blu[5];
      end
      3'b110 :
      begin
        red <= Pattern_Red[6];
        blue <= Pattern_Grn[6];
        green <= Pattern_Blu[6];
      end
      3'b111:
      begin
        red <= 3'b111;
        green <= 3'b111;
        blue <= 2'b11;
      end
      default:
      begin
        red <= Pattern_Red[0];
        green <= Pattern_Grn[0];
        blue <= Pattern_Blu[0];
      end
    endcase
  end

endmodule
