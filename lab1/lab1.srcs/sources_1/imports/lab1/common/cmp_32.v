`timescale 1ns / 1ps

// 32位比较器，用于branch指令，先判断比较的类型，再进行比较
module cmp_32(  input [31:0] a,
                input [31:0] b,
                input [2:0] ctrl,
                output c
    );
    parameter cmp_EQ  = 3'b001;
    parameter cmp_NE  = 3'b010;
    parameter cmp_LT  = 3'b011;
    parameter cmp_LTU = 3'b100;
    parameter cmp_GE  = 3'b101;
    parameter cmp_GEU = 3'b110;

    // 计算结果
    wire res_EQ  = a == b;
    wire res_NE  = ~res_EQ;
    // 有符号比较
    // a的符号为1，b的符号为0，a为负数，b为正数，a<b
    // a，b符号相同，~(a[31] ^ b[31]) = 1
    // 无符号数比较，如果a，b都为正数，无符号a<b适用于有符号的a<b
    // 如果a，b都为负数，无符号a<b,不妨设b=-1，用补码表示就是11111111...111。无符号比较肯定最大，有符号也是负数最大
    wire res_LT  = (a[31] & ~b[31]) || (~(a[31] ^ b[31]) && a < b);
    wire res_LTU = a < b;
    wire res_GE  = ~res_LT;
    wire res_GEU = ~res_LTU;

    // 比较类型选择，判断信号
    wire EQ  = ctrl == cmp_EQ ; 
    wire NE  = ctrl == cmp_NE ; 
    wire LT  = ctrl == cmp_LT ; 
    wire LTU = ctrl == cmp_LTU;
    wire GE  = ctrl == cmp_GE ; 
    wire GEU = ctrl == cmp_GEU;

    assign c =  ({32{EQ}} && res_EQ) || 
                ({32{NE}} && res_NE) || 
                ({32{LT}} && res_LT) || 
                ({32{LTU}} && res_LTU) || 
                ({32{GE}} && res_GE) || 
                ({32{GEU}} && res_GEU);

endmodule