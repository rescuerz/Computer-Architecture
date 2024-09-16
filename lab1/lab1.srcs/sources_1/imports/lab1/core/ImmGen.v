`timescale 1ns / 1ps

// 生成立即数
module ImmGen(
            input  wire [2:0] ImmSel,
            input  wire [31:0] inst_field,
            output[31:0] Imm_out
    );
    // I型指令，B型指令，J型指令，S型指令，U型指令
    parameter Imm_type_I = 3'b001;
    parameter Imm_type_B = 3'b010;
    parameter Imm_type_J = 3'b011;
    parameter Imm_type_S = 3'b100;
    parameter Imm_type_U = 3'b101;

    // 用于最后的选择信号
    wire I = ImmSel == Imm_type_I;
    wire B = ImmSel == Imm_type_B;
    wire J = ImmSel == Imm_type_J;
    wire S = ImmSel == Imm_type_S;
    wire U = ImmSel == Imm_type_U;
    
	// I型指令，立即数为inst_field[31:20]
	// 指令格式为 imm[11:0], rs1[4:0], func3[2:0], rd[4:0], opcode[6:0]
    wire[31:0] Imm_I = {{20{inst_field[31]}}, inst_field[31:20]};
	// B型指令，立即数为 inst_field[31], inst_field[7], inst_field[30:25], inst_field[11:8], 1'b0
	// 指令格式为 imm[12, 10:5], rs2[4:0], rs1[4:0], func3[2:0], imm[4:1, 11], opcode[6:0]
    wire[31:0] Imm_B = {{20{inst_field[31]}}, inst_field[7], inst_field[30:25], inst_field[11:8], 1'b0};
	// J型指令，立即数为 inst_field[31], inst_field[19:12], inst_field[20], inst_field[30:21],1'b0
	// 指令格式为 imm[20, 10:1, 11, 19:12] rd[4:0], opcode[6:0]
    wire[31:0] Imm_J = {{12{inst_field[31]}}, inst_field[19:12], inst_field[20], inst_field[30:21],1'b0};
    // S型指令，立即数为 inst_field[31:25], inst_field[11:7]
	// 指令格式为 imm[11:5], rs2[4:0], rs1[4:0], func3[2:0], imm[4:0], opcode[6:0]
	wire[31:0] Imm_S = {{20{inst_field[31]}}, inst_field[31:25], inst_field[11:7]};
    // U型指令，立即数为 inst_field[31:12], 12'b0
	// 指令格式为 imm[31:12], rd[4:0], opcode[6:0]
	wire[31:0] Imm_U = {inst_field[31:12], 12'b0};

	// 最终的立即数
    assign Imm_out = {32{I}} & Imm_I |
                     {32{B}} & Imm_B |
                     {32{J}} & Imm_J |
                     {32{S}} & Imm_S |
                     {32{U}} & Imm_U ;
endmodule
