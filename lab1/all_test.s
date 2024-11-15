.global __start
__start:
addi x0, x0, 0 # PC = 0x0

lw x2, 4(x0) # PC = 0x4, x2 = 0x00000008

lw x4, 8(x0) # PC = 0x8, x4 = 0x00000010

add x1, x2, x4 # PC = 0xC, x1 = 0x00000018

addi x1, x1, -1 # PC = 0x10, x1 = 0x00000017

lw x5, 12(x0) # PC = 0x14, x5 = 0x00000014

lw x6, 16(x0) # PC = 0x18, x6 = 0xFFFF0000

lw x7, 20(x0) # PC = 0x1C, x7 = 0x0FFF0000

sub x1,x4,x2 # PC = 0x20, x1 = 0x00000008

and x1,x4,x2 # PC = 0x24, x1 = 0x00000000

or  x1,x4,x2 # PC = 0x28, x1 = 0x00000018

xor x1,x4,x2 # PC = 0x2C, x1 = 0x00000018

sll x1,x4,x2 # PC = 0x30, x1 = 0x00001000

slt x1,x4,x2 # PC = 0x34, x1 = 0x00000000

slt x1,x2,x4 # PC = 0x38, x1 = 0x00000001

srl x1, x6, x2 # PC = 0x3C, x1 = 0x00FFFF00

sra x1, x6, x2 # PC = 0x40, x1 = 0xFFFFFF00

sra x1, x7, x2 # PC = 0x44, x1 = 0x000FFF00

sltu x1, x6, x7 # PC = 0x48, x1 = 0x00000000

sltu x1, x7, x6 # PC = 0x4C, x1 = 0x00000001

add x0,x0,x0 # PC = 0x50

addi x1,x10,-3 # PC = 0x54, x1 = 0xFFFFFFFD

andi x1,x4,15 # PC = 0x58, x1 = 0x00000000

ori  x1,x4,15 # PC = 0x5C, x1 = 0x0000001F

xori x1,x4,15 # PC = 0x60, x1 = 0x0000001F

slti x1,x4,15 # PC = 0x64, x1 = 0x00000000

slli x1,x4,1 # PC = 0x68, x1 = 0x00000020

srli x1,x4,2 # PC = 0x6C, x1 = 0x00000004

srai x1, x6, 12 # PC = 0x70, x1 = 0xFFFFFFF0

sltiu x1, x6, -1 # PC = 0x74, x1 = 0x00000001

sltiu x1, x7, -1 # PC = 0x78, x1 = 0x00000001

beq  x4,x5,label0 # PC = 0x7C not branch

beq  x4,x4,label0 # PC = 0x80 branch

addi x0,x0,0 # PC = 0x84

addi x0,x0,0 # PC = 0x88

label0:
bne  x4,x4,label1 # PC = 0x8C not branch

bne  x4,x5,label1 # PC = 0x90 branch

addi x0,x0,0 # PC = 0x94

addi x0,x0,0 # PC = 0x98

label1:
blt  x5,x4,label2 # PC = 0x9C not branch

blt  x4,x5,label2 # PC = 0xA0 branch

addi x0,x0,0 # PC = 0xA4

addi x0,x0,0 # PC = 0xA8

label2:
bltu x6,x7,label3 # PC = 0xAC not branch

bltu x7,x6,label3 # PC = 0xB0 branch

addi x0,x0,0 # PC = 0xB4

addi x0,x0,0 # PC = 0xB8

label3:
bge x4,x5,label4 # PC = 0xBC not branch

bge x5,x4,label4 # PC = 0xC0 branch

addi x0,x0,0 # PC = 0xC4

addi x0,x0,0 # PC = 0xC8

label4:
bgeu x7,x6,label5 # PC = 0xCC not branch

bgeu x6,x7,label5 # PC = 0xD0 branch

addi x0,x0,0 # PC = 0xD4

addi x0,x0,0 # PC = 0xD8

label5:
bge  x4,x4,label6 # PC = 0xDC branch

addi x0,x0,0 # PC = 0xE0

addi x0,x0,0 # PC = 0xE4

label6:
lui  x1,4 # PC = 0xE8 x1 = 0x00004000

jal  x1,12 # PC = 0xEC x1 = 0x000000F0

addi x0,x0,0 # PC = 0xF0

addi x0,x0,0 # PC = 0xF4

lw   x8, 24(x0) # PC = 0xF8, x8 = 0xFF000F0F

sw   x8, 28(x0) # PC = 0xFC

lw   x1, 28(x0) # PC = 0x100, x1 = 0xFF000F0F

sh   x8, 32(x0) # PC = 0x104

lw   x1, 32(x0) # PC = 0x108, x1 = 0x00000F0F

sb   x8, 36(x0) # PC = 0x10C

lw   x1, 36(x0) # PC = 0x110, x1 = 0x0000000F

lh   x1, 26(x0) # PC = 0x114, x1 = 0xFFFFFF00

lhu  x1, 26(x0) # PC = 0x118, x1 = 0x0000FF00

lb   x1, 27(x0) # PC = 0x11C, x1 = 0xFFFFFFFF

lbu  x1, 27(x0) # PC = 0x120, x1 = 0x000000FF

auipc x1, 0xffff0 # PC = 0x124, x1 = 0xFFFF0124

jalr x1,0(x0) # PC = 0x128, x1 = 0x12C