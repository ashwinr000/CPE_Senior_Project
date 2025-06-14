`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2025 04:13:08 PM
// Design Name: 
// Module Name: MAIN
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


module MAIN #(parameter LAYERS=1, parameter DEP=8, parameter COL=2, parameter ROW=2, parameter W=16, parameter B=16)(
    input logic [(DEP-1):0] data_in[0:(COL-1)],
    input logic clk,
    input logic rst,
    output logic [(DEP-1):0] data_out[0:(COL - 1)]
    );
    
    logic [(DEP-1):0] x_in[0:(COL-1)];
    
    logic [(DEP-1):0] imm_out[0:(COL-1)]; 
    
    logic [(DEP-1):0] x_f[0:(COL-1)];
    logic [(DEP-1):0] w_f[0:(ROW-1)];
    logic [(DEP-1):0] b_f[0:(COL-1)];
    
    logic [(DEP-1):0] data_f[0:(COL-1)];
    logic [(DEP-1):0] data_out_f[0:(COL - 1)];
    logic [(DEP-1):0] data_out_rev[0:(COL - 1)];
    
    logic [(DEP-1):0] sys_out[0:(COL-1)];
    logic [(DEP-1):0] b_in[0:(COL-1)];
    
    logic [(DEP-1):0] activ_in[0:(COL-1)];
    logic [(DEP-1):0] activ_out[0:(COL-1)];
    
    logic ctrl_rst;
    logic ctrl_input_layer;
    logic ctrl_output_layer;
    logic ctrl_end_prog;
    logic ctrl_feed_hold;
    logic ctrl_bias_hold;
    logic [(W-1):0] ctrl_w_mem_addr;
    logic [(B-1):0] ctrl_b_mem_addr;
    logic [7:0] ctrl_mem_addr_rst;
    
    logic [(DEP-1):0] w_in[0:(ROW-1)];
    
    assign data_out = {<< DEP {data_out_rev}};
    
    always_comb
    begin       
        if (ctrl_end_prog)
        begin
            data_out_f = {<< DEP {activ_in}};
            imm_out = '{default: '0};
        end
        else
        begin
            data_out_f = '{default: '0};
            imm_out = activ_out; 
        end
        
        if (ctrl_input_layer)
            x_f = data_f;
        else
            x_f = imm_out;
            
        if (rst)
            ctrl_mem_addr_rst = 0;
        else
            ctrl_mem_addr_rst = ctrl_w_mem_addr;
         
    end
   
    MEM #(.ID(0), .DEP(DEP), .LEN(W), .WIDTH(ROW)) w_mem(
        .clk(clk),
        .en(~ctrl_feed_hold),
        .rst(rst),
        .addr(ctrl_w_mem_addr),
        .data_out(w_in)
        );
        
    MEM #(.ID(1), .DEP(DEP), .LEN(B), .WIDTH(COL)) b_mem(
        .clk(clk),
        .en(~ctrl_bias_hold),
        .rst(0),
        .addr(ctrl_b_mem_addr),
        .data_out(b_in)
        );
    
    SYS #(.DEP(DEP), .ROW(ROW), .COL(COL)) arr(
        .x_in(x_f),
        .w_in(w_f),
        .clk(clk),
        .rst(ctrl_rst),
        .y_out(sys_out)
        );
        
    FEED #(.DEP(DEP), .LEN(COL)) x_feed(
        .x_in(data_in),
        .clk(clk),
        .en(1'b1),
        .x_out(data_f)
        );
    
    FEED #(.DEP(DEP), .LEN(ROW)) w_feed(
        .x_in(w_in),
        .clk(clk),
        .en(1'b1),
        .x_out(w_f)
        );
        
    FEED #(.DEP(DEP), .LEN(COL)) b_feed(
        .x_in(b_in),
        .clk(clk),
        .en(1'b1),
        .x_out(b_f)
        );
        
        
    FEED #(.DEP(DEP), .LEN(COL)) out_feed(
        .x_in(data_out_f),
        .clk(clk),
        .en(1'b1),
        .x_out(data_out_rev)
        );
       
    ACT #(.DEP(DEP), .WIDTH(COL)) activ(
        .x_in(activ_in),
        .x_out(activ_out)
        );
        
    BIAS #(.DEP(DEP), .WIDTH(COL)) bias(
        .x_in(sys_out),
        .b_in(b_f),
        .x_out(activ_in)
        );
        
    CTRL #(.LAYERS(LAYERS), .ROW(ROW), .COL(COL), .DEP(DEP), .W(W), .B(B)) ctrl(
        .rst_in(rst),
        .clk(clk),
        .rst_out(ctrl_rst),
        .feed_hold(ctrl_feed_hold),
        .bias_hold(ctrl_bias_hold),
        .input_layer(ctrl_input_layer),
        .output_layer(ctrl_output_layer),
        .end_prog(ctrl_end_prog),
        .w_mem_addr(ctrl_w_mem_addr),
        .b_mem_addr(ctrl_b_mem_addr)
        );
       
        
endmodule
