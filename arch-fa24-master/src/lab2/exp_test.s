.global __start
__start:
addi x0, x0, 0
lw x2, 4(x0) # x2 = 0x00000008
lw x4, 8(x0) # x4 = 0x00000010
lw x5, 12(x0) # x5 = 0x00000014
lw x6, 16(x0) # x6 = 0xffff0000
lw x7, 20(x0) # x7 = 0x0fff0000
csrrwi x1, 0x306, 16 # CSR[6] = 0x00000010
csrr x1, 0x306       # x1 = 0x00000010
csrrw x1, 0x306, x6  # CSR[6] = 0xffff0000, x1 = 0x00000010
csrr x1, 0x306       # x1 = 0xffff0000
addi x0, x0, 0
addi x1, x0, 120     # x1 = 0x00000078
csrw 0x305, x1       # mtvec(CSR[5]) = 0x00000078 _trap
addi x0, x0, 0       
ecall                
addi x0, x0, 0
addi x0, x0, 0 # illegal inst
addi x0, x0, 0
lw   x1, 127(x0) # don't care
lw   x1, 128(x0) # l access fault
addi x0, x0, 0
sw   x1, 128(x0) # s access fault
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
jr x0


trap:
csrr x25, 0x341  # mepc (1) 0x00000038 (2) 0x00000040 (3) 0x0000004c (4) 0x00000054
csrr x27, 0x342  # mcause (1) 0x0000000b (2) 0x00000002 (3) 0x00000005 (4) 0x00000007 (5) 中断 0x8000000b
csrr x28, 0x300  # mstatus  0x00001880
csrr x29, 0x343  # mtval  (1) 0x00000000 (2) 0x00000012 (3) 0x00000080 (4) 0x00000080
csrr x30, 0x344  # mip      0x000000000
addi x2, x25, 4
csrw 0x341, x2
# 30200073  mret

addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
