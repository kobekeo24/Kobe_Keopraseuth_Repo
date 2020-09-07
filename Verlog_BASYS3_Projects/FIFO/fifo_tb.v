`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/06/2020 08:51:49 AM
// Design Name: 
// Module Name: fifo_tb
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


module fifo_tb();
parameter ENDTIME = 40000; 
reg clk, reset, write, read;
reg [7:0] data_in;
wire [7:0] data_out;
wire overflow, underflow, full, almost_full, empty, almost_empty;

fifo FIFO_0
(
.clk(clk),
.reset(reset),
.wr_data(data_in),
.write(write),
.read(read),
.re_data(data_out),
.overflow(overflow),
.underflow(underflow),
.Full(full),
.Almost_Full(almost_full),
.Empty(empty),
.Almost_empty(almost)
);

initial begin
    clk =1'b0;
end

initial begin
    main;
end

task main;
    fork
        clk_gen;
        reset_gen;
        send_data;
        read_data;
        display;
        end_sim;
    join
endtask

task clk_gen;
     begin
        forever #5 clk = ~clk;
    end
endtask

task reset_gen;
    begin
        #12
        reset = 1'b1;
        #5 
        reset = 1'b0;
    end
endtask

task send_data;
    begin
        data_in = 8'h47;
        write = 1'b1;
        #145
        write = 1'b0;
    end
endtask

task read_data;
    begin
        read = 1'b0;
        #160
        read = 1'b1;
    end
endtask

task display;
    begin
       $display("----------------------------------------------");  
       $display("----------------------------------------------");  
       $display("------------------   -----------------------");  
       $display("----------- SIMULATION RESULT ----------------");  
       $display("--------------       -------------------");  
       $display("----------------     ---------------------");  
       $display("----------------------------------------------");  
       $monitor("TIME = %d, write = %b, read = %b, write_in = %h, read_out = %h",$time, write, read, data_in,data_out); 
    end
endtask

task end_sim;
    begin
        #ENDTIME
        $display("----------- FINISH SIMULATION ----------------"); 
        $finish;
    end
endtask




endmodule
