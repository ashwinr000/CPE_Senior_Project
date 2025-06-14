`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2025 05:26:30 PM
// Design Name: 
// Module Name: BIAS
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


module BIAS #(parameter DEP=8, parameter WIDTH=2) (
    input signed [(DEP-1):0] x_in[0:(WIDTH-1)],
    input signed [(DEP-1):0] b_in[0:(WIDTH-1)],
    output logic signed [(DEP-1):0] x_out[0:(WIDTH-1)]
    );
    
    always_comb
    begin
        for (int i = 0; i < WIDTH; i++)
        begin
            x_out[i] = x_in[i] + b_in[i];
        end
    end
    
endmodule
