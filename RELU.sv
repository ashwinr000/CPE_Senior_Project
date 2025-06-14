`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2025 04:08:25 PM
// Design Name: 
// Module Name: RELU
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


module RELU #(parameter DEP=2)(
    input signed [(DEP-1):0] x,
    //input en,
    output logic signed [(DEP-1):0] y
    );
    
    always_comb
    begin
//        if (en)
//        begin
//            if (x < 0)
//                y = 0;
//            else
//                y = x;
//        end
//        else
//            y = 0;
        if (x < 0)
            y = 0;
        else
            y = x;
    end
endmodule
