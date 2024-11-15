# Computer Architecture lab2

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
│   ├── MUX4T1_32.v
│   ├── REG32.v
│   ├── add_32.v
│   └── cmp_32.v
├── constraint.xdc
├── core
│   ├── ALU.v
│   ├── CSRRegs.v
│   ├── CtrlUnit.v
│   ├── ExceptionUnit.v
│   ├── HazardDetectionUnit.v
│   ├── ImmGen.v
│   ├── RAM_B.v
│   ├── REG_EX_MEM.v
│   ├── REG_ID_EX.v
│   ├── REG_IF_ID.v
│   ├── REG_MEM_WB.v
│   ├── ROM_D.v
│   ├── RV32core.v
│   ├── Regs.v
│   ├── ram.mem
│   └── rom.mem
├── exp_test.s
├── lab2_ref
│   ├── data.pdf
│   ├── inst.pdf
│   └── sim_ref
│       ├── 1.png
│       ├── 2.png
│       ├── 3.png
│       ├── 4.png
│       ├── 5.png
│       ├── 6.png
│       ├── 7.png
│       ├── 8.png
│       └── 9.png
└── sim
    ├── core_sim.v
    ├── core_sim_behav.wcfg
    └── example.png
```

1. 创建 vivado 工程，将 `auxillary`, `common`, `core` 三个文件夹的文件作为 design source 添加，将 `sim` 文件夹下的文件作为 simulation source 添加，将 `constraint.xdc` 作为 constraints 添加。
2. 主要在 `CSRRegs.v` 和 `ExceptionUnit.v` 两个文件中补全本实验的代码，详细的实验要求请看实验文档。
3. `exp_test.s` 中包含本次实验的仿真代码和对应现象的注释，`lab2_ref` 文件夹也包含仿真波形图参考，测试代码和数据的注释，供同学们参考。


`.mem` 文件需要添加到 vivado 工程中，在 add source 时若使用 add Directories 添加源文件可能会导致 `.mem` 文件未被成功添加，如果遇到仿真上板时没有读取到数据，请确认 `.mem` 文件已经添加且路径正确。

ROM 和 RAM 读取 `.mem` 文件的格式如下

```verilog
    reg[31:0] data [0:X];
    initial	begin
        $readmemh("XXX", data);
    end
```

其中 `XXX` 是初始化文件的路径，若为相对路径则是相对于相关的源文件（如 `ROM_D.v`）的路径。在框架中我们默认 `RAM_B.v` 和 `ROM_D.v` 与其对应的 `.mem` 文件在同一目录下，若你的文件结构有变化则需要自行修改 `ROM_D.v` 和 `RAM_B.v` 中的初始化路径。