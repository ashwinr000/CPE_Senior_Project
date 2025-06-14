`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/28/2025 03:10:15 PM
// Design Name: 
// Module Name: SYS
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


module SYS #(parameter DEP=2, parameter ROW=2, parameter COL=2) (
    input [(DEP-1):0] x_in[0:(COL-1)],
    input [(DEP-1):0] w_in[0:(ROW-1)],
    input clk,
    input rst,
    output logic [(DEP-1):0] y_out[0:(COL-1)]
    );
    
    logic [(DEP-1):0] x1[0:ROW][0:(COL-1)];
    logic [(DEP-1):0] w1[0:COL][0:(ROW-1)];
    
    logic [(DEP-1):0] y[0:(ROW-1)][0:(COL-1)];
    
    logic [(DEP-1):0] y_accum[0:(COL-1)];
    
    logic rst_ud[0:ROW][0:(COL-1)];
    logic rst_lr[0:COL][0:(ROW-1)];
    
    assign x1[0] = x_in;
    assign w1[0] = w_in;
    
    assign rst_lr[0][0] = rst;
    assign rst_ud[0][0] = rst;
    
    always_comb
    begin
        for (int j = 0; j < COL; j++)
        begin
            y_out[j] = 0;
            y_accum[j] = 0;
            for (int i = 0; i < ROW; i++)   
                y_accum[j] |= y[i][j];
            y_out[j] = y_accum[j];
        end
    end
    
    
    genvar i;
    genvar j;
    generate
        for (i = 0; i < ROW; i++)
        begin
            for (j = 0; j < COL; j++)
            begin
            
                PE #(.DEP(DEP)) pe(
                    .x_in(x1[i][j]),
                    .w_in(w1[j][i]),
                    .clk(clk),
                    .rst_in_left(rst_lr[j][i]),
                    .rst_in_up(rst_ud[i][j]),
                    .x_out(x1[i + 1][j]),
                    .w_out(w1[j + 1][i]),
                    .y_out(y[i][j]),
                    .rst_out_right(rst_lr[j + 1][i]),
                    .rst_out_down(rst_ud[i + 1][j])
                    );
            end
        end
    endgenerate
   
    
endmodule
