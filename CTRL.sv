`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2025 04:22:47 PM
// Design Name: 
// Module Name: CTRL
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


module CTRL #(parameter LAYERS=1, parameter ROW=2, parameter COL=2, parameter DEP=8, parameter W=10, parameter B=6)(
    input rst_in,
    input clk,
    output logic rst_out,
    output logic feed_hold,
    output logic bias_hold,
    output logic input_layer,
    output logic output_layer,
    output logic end_prog,
    output logic [(W-1):0] w_mem_addr,
    output logic [(B-1):0] b_mem_addr
    );
   
    
    logic [31:0] layer_widths[0:LAYERS];
    logic [31:0] layer_depths[0:LAYERS];
    logic [31:0] layer_count;
    logic [31:0] width_count;
    logic end_layer;
    logic [31:0] depth_count;

    
    initial
    begin
        $readmemh("widths.mem", layer_widths);
        $readmemh("depths.mem", layer_depths);
    end
    
    assign input_layer = (layer_count == 0);
    assign output_layer = (layer_count == (LAYERS - 1)) & end_layer;
    assign end_prog = (layer_count >= LAYERS);
    assign end_layer = ~end_prog & (width_count == layer_widths[layer_count]);
    assign rst_out = rst_in | end_layer;
    assign feed_hold = (width_count == layer_widths[layer_count]-1);
    assign bias_hold = (depth_count == 0);
    
    always @(posedge clk)
    begin                        
        if (rst_in)
        begin
            layer_count <= 0;
            width_count <= 0;
            w_mem_addr <= 1;
            b_mem_addr <= 0;
            bias_hold <= 1;
            depth_count <= 0;
        end
        else
        begin
            if (width_count == layer_widths[layer_count] - 1)
            begin
                depth_count <= layer_widths[layer_count + 1];
            end
            else if (depth_count > 0)
                depth_count <= depth_count - 1;
            else
                depth_count <= 0;
                
            if (width_count == layer_widths[layer_count])
            begin
                layer_count <= layer_count + 1;
                width_count <= 0;
            end
            else
            begin
                layer_count <= layer_count;
                width_count <= width_count + 1;
            end
            
            if (feed_hold)
                w_mem_addr <= w_mem_addr;
            else
                w_mem_addr <= w_mem_addr + 1;
                
            if (bias_hold)
            begin
                b_mem_addr <= b_mem_addr;
            end
            else
            begin
                b_mem_addr <= b_mem_addr + 1;
            end
           
        end
    end  
    
endmodule
    