# 常见问题及解答

## lab1
- 确保你的板子型号选择正确。不然 implementation 会有"'XX' is not a valid site or package pin name" 的 error。pull 最新版的 nexys 工程，应该已经设置好了。vivado 左边 navigate 栏，上面有个 settings 的选项，点开以后可以看到选的板子型号（project device）。
- jal/jalr 结果写回寄存器。在计组中，WB 阶段写回寄存器是三选一（ALU 结果，MEM，jal/jalr 结果），但是在体系给的框架里面是二选一（只有 ALU 结果和 MEM）。部分同学对 jal/jalr 的结果写回是在哪里做的有疑问。请注意，在 CtrlUnit.v 文件里面定义的 ALU 操作（ALUControl），有一个是计算 PC+4 的（ALU_Ap4），即 jal/jalr 的结果是通过 EXE 的 ALU 计算的。
- 测试文件的最后一条是 jalr x1,0(x0)，该指令 PC 值为 0x128，那么 WB 之后 x1 的值应该是 0x12C。部分同学的结果为 0x4，请注意，0x128+4 是在 EXE 的 ALU 计算的，这个结果看起来很像是 0x128 变成了 0，你需要检查你的 CtrlUnit.v 里面的 ALUSrc_A（EXE 的 ALU 的源操作数 A 选择信号线，用来选来自 PC 还是寄存器组），jalr/jal 的话，应该是选 PC。
- 关于 HazardDetectionUnit 模块中的 hazard_optype_ID 接口。看名字，你应该能感觉到这个是用来表示 ID 段指令的操作类型（在这里，指ALU、load、store，以便用来判断冲突类型。比如 load-store 冲突， MEM 阶段是 load 类型且 EXE 阶段是 store 类型且前者的目标是后者的源，然后再做 MEM 到 EXE 的前递）。有的同学觉得，只传了 ID 段的类型，不够。在这个框架的原本实现中，是在该模块内部维护了 optype_exe，optype_mem，用一个简单的时序逻辑来传递 ID 的操作类型。其实你也可以自行修改该模块的接口，直接接一些信号线进去，不用这个 hazard_optype_ID。
- 有若干同学在 0x100 的指令上出了问题：
``` asm
lw   x8, 24(x0)     ******************** PC = 0XF8
# x8 = 0xFF000F0F  

sw   x8, 28(x0)

lw   x1, 28(x0)     ******************** PC = 0X100
```
x1 应该是 0xFF000F0F。请**耐心**检查你的仿真，可以先看看 x8 的值是不是写入了 MEM（store 指令的 MEM 阶段，写入 RAM 的值对不对）。
- 关于报告，仿真/上板需要记录哪些指令。有同学问是否需要全部记录，这显然太多了。选一些代表性的就行了，比如 add-add，load-add，load-store 冲突前递，跳转指令（beq，最后的 jalr 回到第一条指令）。