# 浙江大学 24 秋冬学期计算机体系结构实验指导

本文档面向对象为 2024-2025 秋冬《计算机体系结构》**常瑞**老师班，助教是钟梓航和秦嘉俊同学。实验仓库同时部署在 [gitee](https://gitee.com/crix1021/zju-computer-architecture-course-2024/) 和 [zju-git](https://git.zju.edu.cn/zju-arch/arch-fa24) 上，实验文档已经部署在了[zju-git pages](https://zju-arch.pages.zjusct.io/arch-fa24)上，方便大家阅读。

本文档部分内容借鉴了《计算机系统》系列课程的实验文档，你可以在他们的 [zju-git 仓库](https://git.zju.edu.cn/zju-sys)上查看相关内容。

## 本地渲染文档

文档采用了 [mkdocs-material](https://squidfunk.github.io/mkdocs-material/) 工具构建和部署。如果想在本地渲染：

```bash
$ pip3 install mkdocs-material mkdocs-heti-plugin   # 安装 mkdocs-material
$ git clone https://gitee.com/crix1021/zju-computer-architecture-course-2024.git # clone 本 repo
$ mkdocs serve                                      # 本地渲染
INFO     -  Building documentation...
INFO     -  Cleaning site directory
...
INFO     -  [11:00:57] Serving on http://127.0.0.1:8000//arch-fa24/
```

## 实验报告要求

总的来说，你的报告应该**包含且仅包含**以下内容：

* 设计思路，要求配合关键部分代码进行说明（不要直接贴整个代码文件）。
* 思考题。
* 感想（可选）。

以上是报告的总体要求，具体的实验可能会有部分修改，请留意。对于其他我们没有要求的内容（如实验原理、仿真上板结果），请不要放在报告里，谢谢配合！