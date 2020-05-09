`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Typed by Kobe Keopraseuth
//Inspired by Nandland.com
//This module creates the frame for the image display, by incrementing the rows and columns.
//Enables front and back porch
//////////////////////////////////////////////////////////////////////////////////


module VGA_H_V_Gen #(parameter Total_Col = 800,
  parameter Total_Row = 525,
  parameter Active_Col = 640,
  parameter Active_Row = 480)
(   input            clk, 
   output reg         HSync,
   output reg         VSync,
   output reg [9:0] ColCount = 0, 
   output reg [9:0] RowCount = 0
  );  
  
  
  parameter H_Front_Porch = 18;
  parameter H_Back_Porch = 50;
  parameter V_Front_Porch = 10;
  parameter V_Back_Porch = 33;
  wire clk25;
  
  //convert 100MHz clk to 25MHz
  Clk_Divider newClk(.clk(clk),.count(2'b01),.clk_out(clk25));
  
  always @(posedge clk25)
  begin
    if (ColCount == Total_Col-1'b1) //ready to start rowCount
    begin
      ColCount <= 0;
      if (RowCount == Total_Row-1'b1) //end of frame
        RowCount <= 0; 
      else
        RowCount <= RowCount + 1'b1;
    end
    else
      ColCount <= ColCount + 1'b1;
      
  end
  
  //Consider the Front/Back Porch.
  always @(posedge clk25)
  begin
  if (RowCount > (Active_Row + V_Front_Porch) && RowCount < (Total_Row - V_Back_Porch)) 
    VSync <= 1'b0;
  else
    VSync <= 1'b1;

  if (ColCount > (Active_Col + H_Front_Porch) && ColCount < (Total_Col - H_Back_Porch)) 
    HSync <= 1'b0;
  else
    HSync <= 1'b1;
  end

endmodule
