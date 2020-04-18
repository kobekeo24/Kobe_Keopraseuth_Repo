`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Transmits character A to serial terminal, when pressing button C, and should print on serial monitor.
//////////////////////////////////////////////////////////////////////////////////


module uart_tx_top(
    input btnC,
    input clk,
    output RsTx
    );
    
localparam TX_WAIT_BTN = 2'b00, TX_SEND_CHAR = 2'b01, TX_SEND_WAIT = 2'b10;

reg [1:0] state = TX_WAIT_BTN;

wire uartRDY;
wire uartSend;
reg [7:0] uartData = 0;
reg [7:0] initStr = 8'h41; //ASCII 'A' char

wire btnCclr;
reg btnC_prev;

uart_tx_ctrl TX(uartSend,clk,uartData,uartRDY,RsTx);

debounce dbc(clk,btnC,btnCclr);

always @ (posedge clk)
begin
btnC_prev <= btnCclr;
case(state)
TX_WAIT_BTN:
    if (btnC_prev == 0 && btnCclr == 1'b1) state <= TX_SEND_CHAR;
TX_SEND_CHAR:
    begin
    uartData <= initStr;
    initStr <= initStr + 1'b1;
    state <= TX_SEND_WAIT;
    end
TX_SEND_WAIT:
    if (uartRDY) state <= TX_WAIT_BTN;
default: 
    state <= TX_WAIT_BTN;
endcase
end

assign uartSend = (state == TX_SEND_CHAR);
endmodule
