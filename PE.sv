`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/28/2025 03:10:15 PM
// Design Name: 
// Module Name: PE
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


module PE #(parameter DEP=8) (
    input signed [(DEP-1):0] x_in,
    input signed [(DEP-1):0] w_in,
    input clk,
    input rst_in_left,
    input rst_in_up,
    output logic signed [(DEP-1):0] x_out,
    output logic signed [(DEP-1):0] w_out,
    output logic signed [(DEP-1):0] y_out,
    output logic rst_out_right,
    output logic rst_out_down
    );
    
    logic signed [(DEP-1):0] y;
    logic rst;
    assign rst = rst_in_up || rst_in_left;
    
    initial
    begin
        x_out = 0;
        w_out = 0;
        y = 0;
    end
    
    always @ (posedge clk) 
    begin
        if (rst)
        begin
            y <= 0;
            y_out <= y;
        end
        else begin
            y_out <= 0;
            y <= y + x_in * w_in;
        end
        w_out <= w_in;
        x_out <= x_in;
        rst_out_right <= rst;
        rst_out_down <= rst;
    end
    
endmodule
