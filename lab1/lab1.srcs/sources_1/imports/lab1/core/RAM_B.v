`timescale 1ns / 1ps

module RAM_B(
    input [31:0] addra,
    input clka,      // normal clock
    input[31:0] dina,
    input wea, 
    output[31:0] douta,
    input[2:0] mem_u_b_h_w
);

    // data[0:127] 用于存储数据, 每一个单元存储8bit的数据
    reg[7:0] data[0:127];

    initial	begin
        // $readmemh("ram.mem", data);
        $readmemh("C:/Users/26822/Desktop/ZJU_Course_Resource/CA/Lab/lab1/lab1.srcs/sources_1/imports/core/ram.mem", data);
        
    end

    // addra 由 ALUout_EXE 传入, 计算出load或者store的地址
    // 要求 addra[31:7] = 0，原因是
    // 此处执行store操作，分别是sb，sh，sw
    // dina是要写入的数据
    always @ (negedge clka) begin
        if (wea & ~|addra[31:7]) begin
            // sb
            data[addra[6:0]] <= dina[7:0];
            // sh
            if(mem_u_b_h_w[0] | mem_u_b_h_w[1])
                data[addra[6:0] + 1] <= dina[15:8];
            // sw
            if(mem_u_b_h_w[1]) begin
                data[addra[6:0] + 2] <= dina[23:16];
                data[addra[6:0] + 3] <= dina[31:24];
            end
        end
    end

    // load的数据是从data中读出的
    // lw， lh， lb， lhu， lbu
    assign douta = addra[31:7] ? 32'b0 :
        mem_u_b_h_w[1] ? {data[addra[6:0] + 3], data[addra[6:0] + 2],
                    data[addra[6:0] + 1], data[addra[6:0]]} :
        mem_u_b_h_w[0] ? {mem_u_b_h_w[2] ? 16'b0 : {16{data[addra[6:0] + 1][7]}},
                    data[addra[6:0] + 1], data[addra[6:0]]} :
        {mem_u_b_h_w[2] ? 24'b0 : {24{data[addra[6:0]][7]}}, data[addra[6:0]]};

endmodule