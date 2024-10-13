# Computer Architecture lab1

框架结构

```bash
.
├── README.md
├── all_test.s 
├── auxillary 
│   ├── UART_TX_CTRL.vhd
│   ├── btn_scan.v
│   ├── debug_clk.v
│   ├── debug_ctrl.v
│   ├── function.vh
│   ├── my_clk_gen.v
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
│   ├── CtrlUnit.v
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
└── sim
    ├── core_sim.v
    └── core_sim_behav.wcfg
```

创建 vivado 工程，将 `auxillary`, `common`, `core` 三个文件夹的文件作为 design source 添加，将 `sim` 文件夹下的文件作为 simulation source 添加，将 `constraint.xdc` 作为 constraints 添加。

请补全 `RV32core.v` 中五级流水线的实现，上板时将 SW0 和 SW8 调至高电平启动串口单步调试模式。

`.mem` 文件需要添加到 vivado 工程中，在 add source 时若使用 add Directories 添加源文件可能会导致 `.mem` 文件未被成功添加，如果遇到仿真上板时没有读取到数据，请确认 `.mem` 文件已经添加且路径正确。

ROM 和 RAM 读取 `.mem` 文件的格式如下

```verilog
    reg[31:0] data [0:X];
    initial	begin
        $readmemh("XXX", data);
    end
```

其中 `XXX` 是初始化文件的路径，若为相对路径则是相对于相关的源文件（如 `ROM_D.v`）的路径。在框架中我们默认 `RAM_B.v` 和 `ROM_D.v` 与其对应的 `.mem` 文件在同一目录下，若你的文件结构有变化则需要自行修改 `ROM_D.v` 和 `RAM_B.v` 中的初始化路径。
