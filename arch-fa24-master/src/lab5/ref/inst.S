# 注释中 clk_cnt 的值是串口输出变化时的 CLK_CNT 的值。由于 regfile 是下降沿写入，WB 级指令下半周期即可观察到 regfile 的变化，
# 因此仿真时查看 clk_cnt 的变化会比注释的值早半个周期，例如注释中 clk_cnt = 0x7 会观察到变化的寄存器，仿真时会在 clk_cnt = 0x6 的中间观察到变化。

__start:
 addi x0, x0, 0
 lw x2, 4(x0) # x2 = 0x8, clk_cnt = 0x7
 lw x4, 8(x0) # x4 = 0x10, clk_cnt = 0xc
 add x1, x2, x4 # x1 = 0x18, clk_cnt = 0xf
 addi x1, x1, -1 # x1 = 0x17, clk_cnt = 0x13
 lw x5, 12(x0) # x5 = 0x14, clk_cnt = 0x15
 lw x6, 16(x0) # x6 = 0xffff0000, clk_cnt = 0x1A
 lw x7, 20(x0) # x7 = 0x0fff0000, clk_cnt = 0x20
 sub x1,x4,x2 # x1 = 0x8, clk_cnt = 0x1f
 addi x1,x10,-3 # x1 = 0xfffffffd, clk_cnt = 0x23
 beq x4,x5,label0 # not jump
 beq x4,x4,label0 # jump
 addi x0,x0,0
 addi x0,x0,0
 addi x0,x0,0
 addi x0,x0,0
label0: lui x1,4 # x1 = 0x00004000, clk_cnt = 0x2c
 jal x1,12 # x1 = 48, clk_cnt = 0x30
 addi x0,x0,0
 addi x0,x0,0
 auipc x1, 0xffff0 # x1 = 0xffff0050, clk_cnt = 0x34
 div x8, x7, x2 # x8 = 0x0x01ffe000, clk_cnt = 0x59
 mul x9, x4, x5 # x9 = 00000140, clk_cnt = 0x3c
 mul x9, x8, x2 # x9 = 0x0fff0000, clk_cnt = 0x62
 addi x2, x0, 4 # x2 = 4, clk_cnt = 0x5b
 jalr x1,0(x0) # x1 = 0x68, clk_cnt = 0x42
 addi x0,x0,0
 addi x0,x0,0
