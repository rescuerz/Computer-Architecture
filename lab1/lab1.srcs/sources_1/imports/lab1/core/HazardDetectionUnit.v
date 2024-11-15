`timescale 1ps/1ps

module HazardDetectionUnit(
    input clk,
    input Branch_ID, rs1use_ID, rs2use_ID,
    input[1:0] hazard_optype_ID,
    input[4:0] rd_EXE, rd_MEM, rs1_ID, rs2_ID, rs2_EXE,
    
    output reg_FD_EN,       // enable IF_IF_Reg
    output reg_DE_EN,
    output reg_EM_EN, 
    output reg_MW_EN,

    output PC_EN_IF,        // enable PC 更新
    output reg_FD_stall,    // 
    output reg_FD_flush,

    
    output reg_DE_flush, 
    output reg_EM_flush, 
    
    output forward_ctrl_ls,
    output[1:0] forward_ctrl_A, forward_ctrl_B
);
    //according to the diagram, design the Hazard Detection Unit

    assign reg_FD_EN = 1'b1;    // enable IF_IF_Reg
    assign reg_DE_EN = 1'b1;    // enable ID_EX_Reg
    assign reg_EM_EN = 1'b1;    // enable EX_MEM_Reg
    assign reg_MW_EN = 1'b1;    // enable MEM_WB_Reg


    // 更新EX，MEM阶段的harzard_optype
    reg[1:0] hazard_optype_EX;
    reg[1:0] hazard_optype_MEM;
    always@(posedge clk) begin
        hazard_optype_EX <= hazard_optype_ID & {2{~reg_DE_flush}};
        hazard_optype_MEM <= hazard_optype_EX;
    end

    // hazard_optype_ALU = 2'b01
    // hazard_optype_load = 2'b10
    // hazard_optype_store = 2'b11

    // load-use hazard, 需要一个stall，先排除load_store情况
    wire rs1_stall = (rs1use_ID == 1) 
                    & (rd_EXE != 0)
                    & (rs1_ID == rd_EXE)
                    & (hazard_optype_EX == 2'b10)
                    & (hazard_optype_ID != 2'b11);

    // forward, rs1的输入变为EXE的结果
    wire rs1_forward_ctrl1 = (rs1use_ID == 1)
                            & (rd_EXE != 0)
                            & (rs1_ID == rd_EXE)
                            & (hazard_optype_EX == 2'b01);
    // forward, rs1的输入变为ALU计算的在MEM的值
    wire rs1_forward_ctrl2 = (rs1use_ID == 1)
                            & (rd_MEM != 0)
                            & (rs1_ID == rd_MEM)
                            & (hazard_optype_MEM == 2'b01);

    // forward, 前一条指令是load， rs1的输入变为从内存中读出的值
    wire rs1_forward_ctrl3 = (rs1use_ID == 1)
                            & (rd_MEM != 0)
                            & (rs1_ID == rd_MEM)
                            & (hazard_optype_MEM == 2'b10);

    // load-use hazard, 需要一个stall，先排除load_store情况
    wire rs2_stall = (rs2use_ID == 1)
                    & (rd_EXE != 0)
                    & (rs2_ID == rd_EXE)8
                    & (hazard_optype_EX == 2'b10)
                    & (hazard_optype_ID != 2'b11);
    
    // forward, rs2的输入变为EXE的结果
    wire rs2_forward_ctrl1 = (rs2use_ID == 1)
                            & (rd_EXE != 0)
                            & (rs2_ID == rd_EXE)
                            & (hazard_optype_EX == 2'b01);
    // forward, rs2的输入变为ALU计算的在MEM的值
    wire rs2_forward_ctrl2 = (rs2use_ID == 1)
                            & (rd_MEM != 0)
                            & (rs2_ID == rd_MEM)
                            & (hazard_optype_MEM == 2'b01);
    // forward, 前一条指令是load， rs2的输入变为从内存中读出的值
    wire rs2_forward_ctrl3 = (rs2use_ID == 1)
                            & (rd_MEM != 0)
                            & (rs2_ID == rd_MEM)
                            & (hazard_optype_MEM == 2'b10);
    
    wire load_stall = rs1_stall | rs2_stall;
    
    // PC_EN_IF 用于 PC值的更新， 当发生Stall时，PC不更新
    assign PC_EN_IF = ~load_stall;

    // 当发生load_stall时，
    assign reg_FD_stall = load_stall;
    assign reg_DE_flush = load_stall;

    assign reg_FD_flush = Branch_ID;

    assign forward_ctrl_A = (rs1_forward_ctrl1) ? 2'b01 : 
                            (rs1_forward_ctrl2) ? 2'b10 : 
                            (rs1_forward_ctrl3) ? 2'b11 : 2'b00;
    
    assign forward_ctrl_B = (rs2_forward_ctrl1) ? 2'b01 :
                            (rs2_forward_ctrl2) ? 2'b10 :
                            (rs2_forward_ctrl3) ? 2'b11 : 2'b00;
    
    // 判断是否是load_store情况
    assign forward_ctrl_ls = (hazard_optype_EX == 2'b11) 
                            & (hazard_optype_MEM == 2'b10)
                            & (rs2_EXE == rd_MEM);
endmodule