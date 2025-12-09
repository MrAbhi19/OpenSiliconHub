`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2025 12:05:09 PM
// Design Name: 
// Module Name: subBytes
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


module subBytes(in,out);
    input [127:0]in;
    output [127:0] out;
    
    genvar i;
    generate
    for(i=0;i<128;i=i+8) begin :sub_Bytes
        sbox s(in[i +:8],out[i +:8]);
    end
    endgenerate
endmodule
