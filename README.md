# atk-mp257

正点原子（ALIENTEK）STM32MP257 开发板（ATK-MP257 核心板，2GB DDR，eMMC 启动）的
Yocto 构建层集合，基于 OpenSTLinux Distribution Package
（`openstlinux-6.6-yocto-scarthgap-mpu-v26.06.10`，OpenSTLinux v6.2.1 / Yocto Scarthgap / OE-core 5.x）。

本仓库是 `repo` 检出环境中层目录的快照，所有层的**内容均以普通文件
纳入 git 跟踪**（含 ST 官方层 `meta-st/`、`meta-openembedded/`、
`openembedded-core/`，以及集成的 Qt/X-Linux 框架层，见目录结构），
克隆后即可直接使用，无需 `repo sync` 或子模块/子仓库更新。
克隆得到的顶层目录名为 `atk-mp257`。

> **注意**：envsetup 通过相对路径 `atk-mp257/meta-atk-mp257/...` 定位层，对
> 克隆目录名是**硬依赖**。请保持目录名为 `atk-mp257`（`git clone .../atk-mp257.git`
> 的默认目录名即满足），改名会导致 `source envsetup.sh` 找不到层。

## 目录结构

```text
atk-mp257/
├─ README.md                         # 本文件
├─ meta-atk-mp257/                   # 项目定制层集合 + 集成的 ST 框架层（均以普通文件跟踪）
│  ├─ scripts/                       # 从 meta-st/scripts fork，_META_LAYER_ROOT 指向本集合
│  ├─ meta-atk-mp257-stm32mp/        # meta-st-stm32mp fork（collection: stm-st-stm32mp）
│  │  ├─ conf/machine/stm32mp257-atk.conf        # ATK 板级 machine（MACHINE=stm32mp257-atk）
│  │  ├─ recipes-kernel/linux/linux-stm32mp/     # ATK 内核设备树 + linux-stm32mp_%.bbappend
│  │  └─ recipes-extended/external-dt/           # ATK boot 链设备树 + external-dt_%.bbappend
│  ├─ meta-atk-mp257-stm32mp-addons/ # meta-st-stm32mp-addons fork（collection: stm-st-stm32mp-mx）
│  ├─ meta-atk-mp257-openstlinux/    # meta-st-openstlinux fork（collection: st-openstlinux）
│  ├─ meta-qt6                       # Qt6 层（collection: qt6-layer）
│  ├─ meta-st-x-linux-qt             # ST X-Linux Qt 框架层（collection: x-linux-qt）
│  ├─ meta-st-x-linux-isp            # ST X-Linux ISP 层（collection: x-linux-isp）
│  ├─ meta-st-x-linux-rt             # ST X-Linux RT 层（collection: stm-st-stm32mprt）
│  └─ meta-st-stm32mp-tsn-swch       # ST TSN 交换机层（collection: stm-tsn-base）
├─ meta-st/                          # ST 官方层（内容随仓库跟踪）
├─ meta-openembedded/                # meta-oe / meta-python 等（内容随仓库跟踪）
└─ openembedded-core/                # OE-core（无 poky）（内容随仓库跟踪）
```

> fork 后的各层 `conf/layer.conf` 中 `BBFILE_COLLECTIONS` / `BBFILE_PRIORITY` /
> `LAYERDEPENDS` 沿用 ST 原版命名，`LAYERDEPENDS_stm-st-stm32mp = "core
> openembedded-layer meta-python"` 等依赖关系不变，请勿改名。

## 板级定制内容（meta-atk-mp257-stm32mp）

### Machine：`stm32mp257-atk`

- `conf/machine/stm32mp257-atk.conf`：
  - 继承 `stm32mp2common:stm32mp25common`，`DEFAULTTUNE = "cortexa35"`；
  - boot scheme `optee`，boot device `emmc`；
  - 启用 `EXTERNAL_DT_ENABLED = "1"`（boot 链设备树来自 dt-stm32mp 外部注入）；
  - `STM32MP_DT_FILES_EMMC = "stm32mp257d-atk-ddr-2GB"`（内核 dtb）；
  - `EXTERNAL_DEVICETREE_EMMC = "stm32mp257d-atk-ddr-2GB"`（TF-A/OP-TEE/U-Boot/FIP）；
  - GPU 特性按 `ACCEPT_EULA_stm32mp257-atk = "1"` 条件使能；
  - `#@NEEDED_BSPLAYERS:` 声明 INIT 时由 envsetup 自动写入 `bblayers.conf` 的层
    （`meta-oe`/`meta-python`、`meta-qt6`、`meta-st-x-linux-qt`、
    `meta-st-x-linux-isp`、`meta-st-stm32mp-tsn-swch`），
    全新 INIT / `--reset` 后**无需手工** `bitbake-layers add-layer`；
    标签可用**多条重复注释行**分行走读，但不可用行尾 `\` 续行
    （bitbake 会把注释里的 `\` 当续行符解析而报 “confusing multiline”）。

### 内核设备树注入

- `recipes-kernel/linux/linux-stm32mp_%.bbappend`：把 ATK 板级 `.dts`/`.dtsi`
  注入到内核 `arch/arm64/boot/dts/st/` 并在 `st/Makefile` 注册默认 dtb。
- 源码位于 `recipes-kernel/linux/linux-stm32mp/`，含基础板
  `stm32mp257d-atk-ddr-2GB.dts` 及 rgb / mipi / lvds(1x/2x/dualLink) 显示变体、
  `stm32mp257d-atk-ddr-2GB-ca35tdcid-resmem.dtsi`、`stm32mp25-pinctrl-atk-ddr-2GB.dtsi`。

### Boot 链设备树注入（TF-A / U-Boot / OP-TEE）

- `recipes-extended/external-dt/external-dt_%.bbappend`：把 ATK boot 链设备树
  （DDR4 2x8Gbits 2x16bits 1200MHz）安装到 external-dt 仓库布局并注册：
  - TF-A：`external-dt/tf-a/`；
  - U-Boot：`external-dt/u-boot/`（追加 dtb 到 u-boot Makefile）；
  - OP-TEE：`external-dt/optee/`（追加 `flavor_dts_file-257D_ATK_DDR_2GB` 到 conf.mk）。
- OP-TEE 设备树由 v1.0 SDK 适配到 ST r3.1 OP-TEE：`LTDC_L0L1/L2` rifsc 宏重命名、
  `&scmi_regu`→`&scmi_regulator{regulators{}}`、resmem 增加 `scmi_cid2_s/ns` 并把
  `cm33_sram1` 移至 `@a043000/0x1d000`。

## 集成的 ST 框架层（Qt / X-Linux / TSN）

为应用扩展，把 ST 上游框架层集成到 `meta-atk-mp257/` 下：各自删除独立 `.git`
（不再保留 git 子仓库/远程关联），随本仓库以**普通文件**快照跟踪，版本即本仓库提交。

- `meta-qt6` + `meta-st-x-linux-qt`：Qt6 运行时/开发支持。
- `meta-st-x-linux-isp`：X-Linux 图像信号处理。
- `meta-st-x-linux-rt`：X-Linux RT 层（当前随仓库跟踪，`stm32mp257-atk` 默认未启用）。
- `meta-st-stm32mp-tsn-swch`：TSN 交换机（ptp4l / qbv 等）。

是否加入编译由板级 machine 的 `#@NEEDED_BSPLAYERS:` 决定。envsetup 的
`conf_bblayerconf()` 会收集机器文件里**所有** `#@NEEDED_BSPLAYERS:` 行并合并为层列表
（`meta-atk-mp257/scripts/envsetup.sh` 与 `meta-st/scripts/envsetup.sh` 均已同步支持），
因此新增/移除某层只需增删对应机器文件里的标签行，下次 INIT 自动生效。

> 更新提示：以上层来自 ST/上游独立 git 仓库。因 `.git` 已移除，如需升级请用
> `repo sync` 或重新 clone 后**整体替换**目录，再在 `bblayers.conf`（或机器文件
> 标签）里保持路径不变即可。

## 构建

主机要求 Ubuntu 20.04/22.04/24.04 且非 root。在包含本仓库克隆（目录名
`atk-mp257`）的父目录下 **source**（不可直接执行）fork 后的 envsetup：

```bash
cd /path/to/Distribution-Package

# 交互式
source atk-mp257/meta-atk-mp257/scripts/envsetup.sh build-openstlinuxweston-stm32mp257-atk

# 非交互式（首次 INIT 推荐，EULA 通过变量预接受）
DISTRO=openstlinux-weston \
MACHINE=stm32mp257-atk \
BUILD_DIR=build-openstlinuxweston-stm32mp257-atk \
EULA_stm32mp257atk=1 \
source atk-mp257/meta-atk-mp257/scripts/envsetup.sh --no-ui

# 编译镜像
bitbake st-image-weston
```

仅重建 boot 链（改动 external-dt 之后）：

```bash
source atk-mp257/openembedded-core/oe-init-build-env build-openstlinuxweston-stm32mp257-atk
bitbake external-dt -c cleansstate
bitbake external-dt
bitbake optee-os-stm32mp
bitbake fip-stm32mp
```

产物目录：`build-openstlinuxweston-stm32mp257-atk/tmp-glibc/deploy/images/stm32mp257-atk/`
（split bootfs/rootfs/userfs/vendorfs ext4、TF-A、FIP、dtb、wic）。

## 注意事项

- 不要在各层内 `git pull`；所有层内容已随本仓库快照提交，脱离 repo/上游管理，
  如需从上游更新需手动替换对应层目录。
- `conf/` 完全由 envsetup 从模板生成（`--reset` 会重建，含 atk 定制层与集成的
  ST 框架层引用，来自板级 machine 的 `#@NEEDED_BSPLAYERS:`），
  不要手工维护 bblayers.conf；如确需自定义，请在 `conf/local.conf` / `conf/site.conf` 追加。
- 首次构建无共享 sstate 缓存，需从 ST 源码镜像重新下载（约 10GB+）并全量编译，
  耗时较长，属正常现象；产物与缓存均在 `build-openstlinuxweston-stm32mp257-atk/` 内。
- `conf/local.conf` 沿用 ST 默认覆盖：`PACKAGE_CLASSES = "package_deb"`、
  `INHERIT += "rm_work buildhistory"`、`PRSERV_HOST = "localhost:0"`。
- GPU/多媒体（Vivante）等 EULA 受限特性需 `ACCEPT_EULA_stm32mp257-atk = "1"`，
  交互式 envsetup 会提示接受；非交互式用 `EULA_stm32mp257atk=1` 预接受。

## 参考

- OpenSTLinux v6.2.1 官方文档：<https://wiki.st.com/stm32mpu>
- 米尔电子yocto仓库：<https://github.com/MYiR-Dev/myir-st-manifest.git>
