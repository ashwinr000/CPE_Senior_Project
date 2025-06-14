`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2025 01:33:54 PM
// Design Name: 
// Module Name: ACT
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


module ACT #(parameter DEP=8, parameter WIDTH=2)(
    input signed [(DEP-1):0] x_in[0:(WIDTH-1)],
    output logic signed [(DEP-1):0] x_out[0:(WIDTH-1)]
    );
    
    genvar i;
    generate
        for (i = 0; i < WIDTH; i++)
        begin
            RELU #(.DEP(DEP)) activ(
                .x(x_in[i]),
                .y(x_out[i])
                );
        end
    endgenerate
    
    
endmodule
