# HexagonOS 0.2 - 构建指南

## 前提条件
- GitHub 账号
- 本仓库有 GitHub Actions 权限

## 自动构建

每次 push 到 main 分支，GitHub Actions 会自动：
1. 启动一个 Ubuntu 22.04 虚拟机
2. 安装 build 工具
3. 打包成 HexagonOS-0.2.iso
4. 上传到 Artifacts

## 手动触发

1. 进入仓库的 **Actions** 标签
2. 点左边 **Build HexagonOS ISO**
3. 右边 **Run workflow** → **Run workflow**

## 下载 ISO

1. 进 Actions → 最新的绿色运行
2. 页面底部 **Artifacts**
3. 下载 **HexagonOS-0.2-iso**

## 命令列表（0.2）

### 文件系统
- ls                列出文件
- cd <path>         切换目录
- pwd               显示当前路径
- mkdir <path>      创建目录
- rm <path>         删除文件
- cat <path>        显示文件内容

### 系统信息
- time / date       显示时间
- version           显示版本
- history           命令历史

### 其他
- echo <text>       输出文字
- clear             清屏
- help              帮助
- Shut down         关机

### 兼容旧命令（0.1）
- Home page         列出所有文件
- open <file>       打开文件
- Create document   创建文档
- rename <old> <new> 重命名
