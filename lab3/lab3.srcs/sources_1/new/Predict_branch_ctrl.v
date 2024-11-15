`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/05 22:11:14
// Design Name: 
// Module Name: Predict_branch_ctrl
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


module Predict_branch_ctrl(
    // 系统信号
    input wire rst,                    // 复位信号
    input wire clk,                    // 时钟信号
    
    // 控制信号
    input wire PC_EN_IF,              // IF阶段PC使能
    input wire reg_FD_stall,          // FD寄存器暂停信号
    
    // PC和分支信息
    input wire [31:0] PC_ID,          // ID阶段PC
    input wire [31:0] PC_IF,          // IF阶段PC
    input wire [31:0] jump_PC_ID,     // ID阶段跳转目标地址
    input wire Branch,                 // 分支指令标志

    // 输出信号
    output wire refetch,         // 分支预测冲突控制信号
    output wire [31:0] next_PC_IF     // 预测的PC
);

reg prev_predict_branch;        // 上一次的分支预测结果
reg [31:0] prev_predict_PC;     // 上一次的预测PC
reg predict_fail;               // 预测失败标志


wire Predict_PC_Branch;         // 预测是否分支跳转
wire [31:0] Predict_PC;         // 预测的下一条PC
wire [31:0] Correct_PC;         // 发生冲突时的正确PC

PC_Table PC_Table(
    .clk(clk),
    .rst(rst),
    .PC_IF(PC_IF),

    .PC_result(Predict_PC),
    .predict_pc_branch(Predict_PC_Branch),
    
    .stall((reg_FD_stall & ~PC_EN_IF) | predict_fail),
    .PC_ID(PC_ID),
    .PC_branch(jump_PC_ID),
    .branch_new(Branch) 
);

// 计算冲突时的正确PC值
assign Correct_PC = (Branch) ? jump_PC_ID : PC_ID + 4;

// 1. 预测结果与实际分支结果不符
// 2. 预测跳转且实际跳转，但目标地址不同
assign refetch = (Branch != prev_predict_branch) || (Branch & prev_predict_branch & (jump_PC_ID != prev_predict_PC));

// 计算下一条指令的
assign next_PC_IF = (refetch) ? Correct_PC : (Predict_PC_Branch) ? Predict_PC : PC_IF + 4;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        // 复位时清空所有状态
        prev_predict_branch <= 1'b0;
        prev_predict_PC <= 32'd0;
        predict_fail <= 1'b0;
    end
    else begin
        if(reg_FD_stall & ~PC_EN_IF) begin
            // 流水线暂停时保持状态不变
            prev_predict_branch <= prev_predict_branch;
            prev_predict_PC <= prev_predict_PC;
            predict_fail <= predict_fail;
            
        end
        else if(refetch) begin
            // 发生预测冲突时，清空预测状态并标记预测失败
            prev_predict_branch <= 0;
            prev_predict_PC <= 0;
            predict_fail <= 1;
        end
        else begin
            // 正常情况下更新预测状态
            prev_predict_branch <= Predict_PC_Branch;
            prev_predict_PC <= Predict_PC;
            predict_fail <= 0;
        end
    end
end
endmodule
