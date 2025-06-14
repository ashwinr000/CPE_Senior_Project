`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/28/2025 06:29:17 PM
// Design Name: 
// Module Name: FEED
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

module DELAY #(parameter DEP=2) (
    input signed [(DEP-1):0] x_in,
    input clk,
    input en,
    output logic signed [(DEP-1):0] x_out
    );
    
    always @(posedge clk)
    begin
        if (en)
            x_out <= x_in;
        else
            x_out <= 0;
    end
    
endmodule


module FEED #(parameter DEP=2, LEN=2) (
    input signed [(DEP-1):0] x_in[0:(LEN-1)],
    input clk,
    input en,
    output logic signed [(DEP-1):0] x_out[0:(LEN-1)]
    );
    
    genvar i, j;
    generate
        for (i = 0; i < LEN; i++)
        begin
        
            logic signed [(DEP-1):0] conn[0:i];
            
            assign conn[0] = x_in[i];
            assign x_out[i] = conn[i];
            
            for (j = 0; j < i; j++)
            begin 
                DELAY #(.DEP(DEP)) d(
                    .x_in(conn[j]),
                    .clk(clk),
                    .en(en),
                    .x_out(conn[j + 1])
                    );
            end
        end
    endgenerate
 endmodule
