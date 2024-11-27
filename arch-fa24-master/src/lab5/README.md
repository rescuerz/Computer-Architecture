# Computer Architecture lab5

框架结构

```bash
.
├── README.md
├── auxillary
│   ├── UART_TX_CTRL.vhd
│   ├── btn_scan.v
│   ├── debug_clk.v
│   ├── debug_ctrl.v
│   ├── display.v
│   ├── function.vh
│   ├── my_clk_gen.v
│   ├── parallel2serial.v
│   ├── top.v
│   └── uart_buffer.v
├── common
│   ├── MUX2T1_32.v
│   ├── MUX8T1_32.v
│   ├── REG32.v
│   ├── add_32.v
│   └── cmp_32.v
├── constraint.xdc
├── core
│   ├── CtrlDefine.vh
│   ├── CtrlUnit.v
│   ├── FU_ALU.v
│   ├── FU_div.v
│   ├── FU_jump.v
│   ├── FU_mem.v
│   ├── FU_mul.v
│   ├── ImmGen.v
│   ├── RAM_B.v
│   ├── REG_IF_IS.v
│   ├── ROM_D.v
│   ├── RV32core.v
│   ├── Regs.v
│   ├── ram.mem
│   └── rom.mem
├── ref
│   ├── data.pdf
│   ├── inst.S
│   ├── inst.pdf
│   └── sim_ref
│       ├── 1.png
│       ├── 2.png
│       ├── 3.png
│       ├── 4.png
│       ├── 5.png
│       ├── 6.png
│       ├── 7.png
│       └── 8.png
└── sim
    ├── sim_top.v
    └── sim_top_behav.wcfg
```

创建 vivado 工程，将 `auxillary`, `common`, `core` 三个文件夹的文件作为 design source 添加，将 `sim` 文件夹下的 `.v` 和 `.wcfg` 文件作为 simulation source 添加，将 `constraint.xdc` 作为 constraints 添加。

`ref/` 中两个 pdf 文件为 CPU 运行的指令和数据，`ref/inst.S` 是带着寄存器值变化和变化时 `CLK_CNT` 参考值的测试汇编代码，验收会参考该文件的注释，请填完框架后自行验证。


`.mem` 文件需要添加到 vivado 工程中，在 add source 时若使用 add Directories 添加源文件可能会导致 `.mem` 文件未被成功添加，如果遇到仿真上板时没有读取到数据，请确认 `.mem` 文件已经添加且路径正确。

ROM 和 RAM 读取 `.mem` 文件的格式如下

```verilog
    reg[31:0] data [0:X];
    initial	begin
        $readmemh("XXX", data);
    end
```

其中 `XXX` 是初始化文件的路径，若为相对路径则是相对于相关的源文件（如 `ROM_D.v`）的路径。在框架中我们默认 `RAM_B.v` 和 `ROM_D.v` 与其对应的 `.mem` 文件在同一目录下，若你的文件结构有变化则需要自行修改 `ROM_D.v` 和 `RAM_B.v` 中的初始化路径。