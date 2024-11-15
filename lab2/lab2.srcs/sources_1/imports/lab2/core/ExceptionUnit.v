`timescale 1ns / 1ps

module ExceptionUnit(
    input clk, rst,
    input csr_rw_in,
    // write/set/clear (funct bits from instruction)
    input[1:0] csr_wsc_mode_in,
    input csr_w_imm_mux,
    input[11:0] csr_rw_addr_in,
    input[31:0] csr_w_data_reg,
    input[4:0] csr_w_data_imm,
    output[31:0] csr_r_data_out,

    input interrupt,
    input illegal_inst,
    input l_access_fault,
    input s_access_fault,
    input ecall_m,

    input mret,

    input[31:0] epc_cur,
    input[31:0] epc_next,

    input[31:0] addr_WB,
    input[31:0] inst_WB,
    output[31:0] PC_redirect,
    output redirect_mux,

    output reg_FD_flush, reg_DE_flush, reg_EM_flush, reg_MW_flush, 
    output RegWrite_cancel,
    output MemWrite_cancel
);
    // According to the diagram, design the Exception Unit
    // You can modify any code in this file if needed!
    wire[11:0] csr_waddr;
    wire[31:0] csr_wdata;
    wire csr_w;
    wire[1:0] csr_wsc;
    wire[11:0] csr_raddr;

    wire[31:0] mstatus;
    wire[31:0] mtvec;
    wire[31:0] mepc;
    wire[31:0] mcause;
    wire[31:0] mtval;
    wire[31:0] csr_rdata;

    assign csr_raddr = csr_rw_addr_in;
    assign csr_waddr = csr_rw_addr_in; 
    assign csr_w = csr_rw_in;
    assign csr_wsc = csr_wsc_mode_in;
    // 修改1
    assign csr_wdata = csr_w_imm_mux ? {27'b0, csr_w_data_imm} : csr_w_data_reg;
    assign csr_r_data_out = csr_rdata;


    // 使用 trap 来指代 exception 或者 interrupt
    // exception 如下：
    // 访问错误异常：当物理内存的地址不支持访问类型时发生（例如尝试写入 ROM）。
    // 环境调用异常：执行 ecall 指令时发生。
    // 非法指令异常：在译码阶段发现无效操作码时发生。
    // trap的发生要求mie为1
    wire mie;
    assign mie = mstatus[3];
    wire trap;
    wire exception;
    assign exception = (illegal_inst | l_access_fault | s_access_fault | ecall_m);
    assign trap = (exception | interrupt) & mie;

    // 根据 interrupt 来决定是否发生 PC_redirect
    wire[31:0] mepc_in;
    wire[31:0] mcause_in;
    wire[31:0] mtval_in;
    wire[31:0] mstatus_in;
    wire[31:0] mtvec_in;

    // mepc_in 仅仅用于trap发生时，要么exception，要么interrupt
    assign mepc_in = exception ? epc_cur : epc_next;
    // 当trap发生时，PC跳转到mtvec，mret返回时，PC跳转到mepc
    assign PC_redirect =  (trap) ? mtvec : mepc;

    // 根据 trap 来决定是否发生 redirect_mux
    assign redirect_mux = trap | mret;
    
    assign mtval_in = (illegal_inst) ? inst_WB : 
                      (l_access_fault | s_access_fault) ? addr_WB : 32'b0;


    assign mcause_in =  (illegal_inst)  ? 32'h00000002 : 
                        (l_access_fault) ? 32'h00000005 : 
                        (s_access_fault) ? 32'h00000007 : 
                        (ecall_m) ? 32'h0000000b : 
                        (interrupt) ? 32'h8000000b : 32'b0;
    assign mtvec_in = mtvec;

    reg[1:0] MPP;
    reg MPIE;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            MPP <= 2'b11;
            MPIE <= 1'b1;
        end
        else if (mret) begin
            MPP <= mstatus[12:11];
            MPIE <= mstatus[3];
        end
        // 修改3
        else if (trap) begin
            MPP <= 2'b11;
            MPIE <= 1'b1;
        end
        else begin
            MPP <= MPP;
            MPIE <= MPIE;
        end
    end


    
    assign mstatus_in = (mret) ? {mstatus[31:4], MPIE, mstatus[2:0]} : {mstatus[31:13], 2'b11, mstatus[10:8], mstatus[3], mstatus[6:4], 1'b0, mstatus[2:0]} ;
    
    // 接下来处理 reg_FD_flush，reg_DE_flush，reg_EM_flush，reg_MW_flush
    // 当trap发生时，需要将后面的指令全部取消
    // 当mret发生时，需要将IF，ID，EXE阶段的指令全部取消，MEM阶段的指令保存
    assign reg_FD_flush = trap | mret;
    assign reg_DE_flush = trap | mret;
    assign reg_EM_flush = trap | mret;
    // 修改2
    assign reg_MW_flush = trap;

    // 接下来处理 RegWrite_cancel，MemWrite_cancel
    assign RegWrite_cancel = exception;
    assign MemWrite_cancel = trap;

    CSRRegs csr(
        .clk(clk),.rst(rst),
        .raddr(csr_raddr),.waddr(csr_waddr),
        .wdata(csr_wdata),
        .csr_w(csr_w),
        .csr_wsc_mode(csr_wsc),
        .rdata(csr_rdata),
        .trap(trap),
        .mret(mret),
        .mstatus_in(mstatus_in),
        .mtvec_in(mtvec_in),
        .mepc_in(mepc_in),
        .mcause_in(mcause_in),
        .mtval_in(mtval_in),
        .mstatus_out(mstatus),
        .mtvec_out(mtvec),
        .mepc_out(mepc),
        .mcause_out(mcause),
        .mtval_out(mtval)
    );

    

endmodule
