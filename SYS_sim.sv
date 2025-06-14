`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/28/2025 03:36:26 PM
// Design Name: 
// Module Name: SYS_sim
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

`define ROW 30
`define COL 1
`define DEP 8
`define LAYERS 3
`define W 16
`define B 16
`define INP 30


module SYS_sim(
    );
    
    logic [(`DEP-1):0] data_in[0:(`COL-1)];
    logic [(`DEP-1):0] w_in[0:(`ROW-1)];
    logic clk;
    logic rst;
    logic [(`DEP-1):0] data_out[0:(`COL - 1)];
    
    MAIN #(.LAYERS(`LAYERS), .DEP(`DEP), .COL(`COL), .ROW(`ROW), .W(`W), .B(`B)) main(
        .data_in(data_in),
        .clk(clk),
        .rst(rst),
        .data_out(data_out)
        );
        
    always
    begin
        clk = 0;
        #1;
        clk = 1;
        #1;
    end
   
    
    initial
    begin
        byte x[`INP];
        $readmemh("input.mem", x);
        
        rst = 1;
        wait(clk);
        
        data_in = {x[0]};
        wait(~clk);
        rst = 0;
        wait(clk);
        
        for (int i = 1; i < `INP; i++)
        begin
            data_in = {x[i]};
            wait(~clk);
            wait(clk);
        end
        
        data_in = {2'b00}; 
        wait(~clk);
        wait(clk);
     
    end
      
endmodule
