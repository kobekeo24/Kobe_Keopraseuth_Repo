`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//This project shows the process of how I2C communication is possible.
//////////////////////////////////////////////////////////////////////////////////


module I2C_Base(clk,reset_n,ena,addr,rw,data_wr,busy,data_rd,ack_error,eop,sda,scl);
input clk;
input reset_n;
input ena;
input [6:0] addr; //slave address
input rw; //read/write
input [7:0] data_wr; //data to write to slave
output reg busy; //when transmitting or receiving
output reg [7:0] data_rd; // data coming from the slave
output reg ack_error;
output reg eop = 0; //end of process

inout sda;
inout scl;

parameter input_clk = 100_000_000;
parameter bus_clk = 400_000;

localparam READY = 4'b0000, START = 4'b0001, COMMAND = 4'b0010, SLV_ACK1 = 4'b0011, WR = 4'b0100, RD = 4'b0101, SLV_ACK2 = 4'b0110, MSTR_ACK = 4'b0111, STOP = 4'b1000;

reg [3:0] state;
integer divider = (input_clk/bus_clk)/4;
wire data_clk;
wire data_clk_prev;
wire scl_clk;
reg scl_ena = 0;
reg sda_int = 1;
reg sda_ena_n;
reg [7:0] addr_rw;
reg [7:0] data_tx;
reg [7:0] data_rx;
reg [2:0] bit_cnt = 3'd7;

I2C_CLK_Divider I2c_clk(.clk(clk),.reset(reset_n),.divider(divider),.scl_clk(scl_clk),.data_clk(data_clk),.data_clk_prev(data_clk_prev));

always @ (posedge clk, negedge reset_n)
begin
if (reset_n == 0)
begin
state <= READY;
busy <= 1;
scl_ena <= 0;
sda_int <= 1;
ack_error <= 0;
bit_cnt <= 3'd7;
data_rd <= 8'b0;
end
else
begin
if (data_clk == 1 && data_clk_prev == 0)

case (state)
READY:
    if (ena == 1)
    begin
    busy <= 1;
    addr_rw <= {addr,rw};
    data_tx <= data_wr;
    state <= START;
    end
    else
    begin
    busy <= 0;
    state <= READY;
    end
START: //start communication
    begin
    busy <= 1;
    sda_int <= addr_rw[bit_cnt];
    state <= COMMAND;
    end
COMMAND: //load in address bits and read/write bit
    if (bit_cnt == 0)
    begin
    sda_int <= 1;
    bit_cnt <= 3'd7;
    state <= SLV_ACK1;
    end
    else begin
    bit_cnt <= bit_cnt - 1;
    sda_int <= addr_rw[bit_cnt -1];
    state <= COMMAND;
    end
SLV_ACK1: //acknowledgement bit has been received and determines read = 1/write = 0
    if (addr_rw[0] == 0)
    begin
    sda_int <= data_tx[bit_cnt-1];
    state <= WR;
    end
    else
    begin
    sda_int <= 1;
    state <= RD;
    end
WR: //master keeps transmitting data one bit at a time 
    begin
    busy <= 1;
    if (bit_cnt == 0)
    begin
    sda_int <= 1;
    bit_cnt <= 3'd7;
    state <= SLV_ACK2;
    end
    else if (bit_cnt == 1)
    begin
    bit_cnt <= bit_cnt - 1;
    sda_int <= data_tx[bit_cnt-1];
    eop <= 1;
    end
    else begin
    bit_cnt <= bit_cnt - 1;
    sda_int <= data_tx[bit_cnt-1];
    state <= WR;
    end
    end
RD: //keeps reading in bits received from slave
    begin
    busy <= 1;
    if (bit_cnt == 0)
    begin
    if (ena == 1 && addr_rw == {addr,rw}) sda_int <= 0;
    else sda_int <= 1;
    bit_cnt <= 3'd7;
    data_rd <= data_rx;
    state <= MSTR_ACK;
    end
    else if (bit_cnt == 1)
    begin
    bit_cnt <= bit_cnt - 1;
    eop <= 1;
    end
    else
    begin
    bit_cnt <= bit_cnt - 1;
    state <= RD;
    end
    end
SLV_ACK2: //Acknowledgement from slave that it has received the data
    if (ena == 1)
    begin
    eop <= 0;
    busy <= 0;
    addr_rw <= {addr,rw};
    data_tx <= data_wr;
    if (addr_rw == {addr,rw})
    begin
    sda_int <= data_wr[bit_cnt];
    state <= WR;
    end
    else state <= START;
    end
    else
    begin
    eop <= 0;
    state <= STOP;
    end
MSTR_ACK: //Acknowledgement from master that it has received the data
    if (ena == 1)
    begin
    eop <= 0;
    busy = 0;
    addr_rw <= {addr,rw};
    data_tx <= data_wr;
    if (addr_rw == {addr,rw})
    begin
    sda_int <= 1;
    state <= RD;
    end
    else
    begin
    eop <= 0;
    state <= STOP;
    end
    end
STOP:
    begin
    busy <= 0;
    state <= READY;
    end
endcase

else if (data_clk == 0 && data_clk_prev == 1)  //just making sure everything is processing correctly
case (state)
START:
    if (scl_ena == 0)
    begin
    scl_ena <= 1;
    ack_error <= 0;
    end
SLV_ACK1:
    if (sda != 0 || ack_error == 1) ack_error <= 1;
RD:
    data_rx[bit_cnt] <= sda; //data from slave
SLV_ACK2:
    if (sda != 0 || ack_error == 1) ack_error <= 1;
STOP:
    scl_ena <= 0;
endcase
end
end

always @ (clk)
case (state)
START : sda_ena_n <= data_clk_prev;
STOP  : sda_ena_n <= ~data_clk_prev;
default : sda_ena_n <= sda_int;
endcase

assign scl = (scl_ena == 1 && scl_clk == 0) ? 0 : 1'bz;
assign sda = (sda_ena_n == 0) ? 0 : 1'bz;
    
endmodule
