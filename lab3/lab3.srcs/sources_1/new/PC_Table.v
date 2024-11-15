`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/05 22:13:28
// Design Name: 
// Module Name: PC_Table
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


module PC_Table (
    input wire rst,
    input wire clk,
    input wire [31:0] PC_IF,
    input wire stall,
    input wire [31:0] PC_ID,
    input wire [31:0] PC_branch,
    input wire branch_new,

    output wire [31:0] PC_result,
    output wire predict_pc_branch
);

// 34位，2位status, 32位PC，
// 256个条目, 对应256条指令，对应PC的范围是0-1024
reg [33:0] PC_Table [0:255];

// 读取PC_Table
wire [33:0] entry;
assign entry = PC_Table[PC_IF[9:2]];
assign predict_pc_branch = entry[33];
assign PC_result = entry[31:0];

// 更新PC_Table
integer i;
wire [33:0] entry_new;
assign entry_new = PC_Table[PC_ID[9:2]];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        for (i = 0; i < 256; i = i + 1) begin
            PC_Table[i] <= 34'b0;
        end
    end 
    else if (~stall) begin
        if (branch_new) begin
            if(entry_new[33:32] == 2'b00)
                PC_Table[PC_ID[9:2]] <= {2'b01, PC_branch[31:0]};
            else
                PC_Table[PC_ID[9:2]] <= {2'b11, PC_branch[31:0]};
        end 
        else begin
            if(entry_new[33:32] == 2'b11)
                PC_Table[PC_ID[9:2]] <= {2'b10, entry_new[31:0]};
            else
                PC_Table[PC_ID[9:2]] <= {2'b00, entry_new[31:0]};
        end
    end 
end


endmodule