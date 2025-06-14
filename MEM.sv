`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2025 01:44:13 PM
// Design Name: 
// Module Name: MEM
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


module MEM #(parameter ID=0, parameter DEP=8, parameter LEN=8, parameter WIDTH=2)(
    input clk,
    input en,
    input rst,
    input [(LEN-1):0] addr,
    output logic signed [(DEP-1):0] data_out[0:(WIDTH-1)]
    );
    
    logic signed [(DEP-1):0] params[0:(2**LEN-1)][0:(WIDTH-1)];
    
    initial begin
        $readmemh($sformatf("params_%0d.mem", ID), params);
    end
    
    always @(posedge clk)
    begin
        if (rst)
        begin
            data_out <= params[0];
        end
        else 
        begin
            if (en)
                data_out <= params[addr];
            else 
                data_out <= '{default: '0};
        end
    end
    

endmodule
