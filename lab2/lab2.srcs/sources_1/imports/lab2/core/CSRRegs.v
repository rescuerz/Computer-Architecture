`timescale 1ns / 1ps

module CSRRegs(
    input clk, rst,
    input[11:0] raddr, waddr,
    input[31:0] wdata,
    input csr_w,
    input[1:0] csr_wsc_mode,
    output[31:0] rdata,
    // 补充信号
    input trap,
    input mret,
    input[31:0] mstatus_in,
    input[31:0] mtvec_in,
    input[31:0] mepc_in,
    input[31:0] mcause_in,
    input[31:0] mtval_in,
    output[31:0] mstatus_out,
    output[31:0] mtvec_out,
    output[31:0] mepc_out,
    output[31:0] mcause_out,
    output[31:0] mtval_out
);
    // You may need to modify this module for better efficiency
    
    reg[31:0] CSR [0:15];

    // mstatua_addr = 0x300 = 0b0011_0000_0000
    // mtvec_addr = 0x305 = 0b0011_0000_0101
    // mepc_addr = 0x341 = 0b0011_0100_0001
    // mcause_addr = 0x342 = 0b0011_0100_0010
    // mtval_addr = 0x343 = 0b0011_0100_0011
    // mip_addr = 0x344 = 0b0011_0100_0100
    // 观察后发现 前五位均为 00110
    // Address mapping. The address is 12 bits, but only 4 bits are used in this module.
    wire raddr_valid = raddr[11:7] == 5'h6 && raddr[5:3] == 3'h0;
    wire[3:0] raddr_map = (raddr[6] << 3) + raddr[2:0];
    wire waddr_valid = waddr[11:7] == 5'h6 && waddr[5:3] == 3'h0;
    wire[3:0] waddr_map = (waddr[6] << 3) + waddr[2:0];

    // 根据 raddr_map 计算得到 mepc，mtvec，mcause，mtval，mstatus对应的CSR索引
    assign mstatus_out = CSR[0];
    assign mtvec_out = CSR[5];
    assign mepc_out = CSR[9];
    assign mcause_out = CSR[10];
    assign mtval_out = CSR[11];
    

    assign rdata = CSR[raddr_map];

    always@(posedge clk or posedge rst) begin
        if(rst) begin
			CSR[0] <= 32'h88;
			CSR[1] <= 0;
			CSR[2] <= 0;
			CSR[3] <= 0;
			CSR[4] <= 32'hfff;
			CSR[5] <= 0;
			CSR[6] <= 0;
			CSR[7] <= 0;
			CSR[8] <= 0;
			CSR[9] <= 0;
			CSR[10] <= 0;
			CSR[11] <= 0;
			CSR[12] <= 0;
			CSR[13] <= 0;
			CSR[14] <= 0;
			CSR[15] <= 0;
		end
        else if(trap) begin
            CSR[0] <= mstatus_in;
            CSR[5] <= mtvec_in;
            CSR[9] <= mepc_in;
            CSR[10] <= mcause_in;
            CSR[11] <= mtval_in;
        end
        else if(mret) begin
            CSR[0] <= mstatus_in;
        end
        else if(csr_w & !trap & !mret) begin
            // csr_wsc_mode = inst[13:12]
            // 当 csr_wsc_mode = 01 时, csr_wdata = wdata
            // 当 csr_wsc_mode = 10 时, csr_wdata = wdata | wdata
            // 当 csr_wsc_mode = 11 时, csr_wdata = wdata & ~wdata
            case(csr_wsc_mode)
                2'b01: CSR[waddr_map] = wdata;
                2'b10: CSR[waddr_map] = CSR[waddr_map] | wdata;
                2'b11: CSR[waddr_map] = CSR[waddr_map] & ~wdata;
                default: CSR[waddr_map] = wdata;
            endcase            
        end
    end
endmodule