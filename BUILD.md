# HexagonOS 0.1 - 构建指南

## 前提条件
- VirtualBox 6.1.50 或更高
- Ubuntu 22.04 Desktop ISO
- Cubic

## 步骤 1：装 Ubuntu 虚拟机
1. VirtualBox 新建虚拟机
2. 内存 4096 MB
3. 硬盘 40 GB
4. 挂载 ubuntu-22.04-desktop-amd64.iso
5. 装 Ubuntu，用户名 hexagon

## 步骤 2：装 Cubic
sudo apt-add-repository ppa:cubic-wizard/release
sudo apt update
sudo apt install cubic

## 步骤 3：准备定制文件
把 HexagonOS-0.1/ 里的所有文件拷到 Ubuntu 家目录：
  ~/HexagonOS-0.1/

## 步骤 4：启动 Cubic
sudo cubic

1. 选择项目目录（默认即可）
2. 选择基础 ISO：ubuntu-22.04-desktop-amd64.iso
3. 进入 chroot 终端

## 步骤 5：在 chroot 里操作

apt install -y dialog

cp /home/hexagon/HexagonOS-0.1/shell/hexagon-shell.sh /usr/local/bin/
chmod +x /usr/local/bin/hexagon-shell.sh

cp /home/hexagon/HexagonOS-0.1/installer/hexagon-installer.sh /usr/local/bin/
chmod +x /usr/local/bin/hexagon-installer.sh

cp /home/hexagon/HexagonOS-0.1/config/os-release /etc/os-release
cp /home/hexagon/HexagonOS-0.1/branding/issue /etc/issue
cp /home/hexagon/HexagonOS-0.1/branding/motd /etc/motd

echo "/usr/local/bin/hexagon-shell.sh" >> /home/hexagon/.bashrc

nano /boot/grub/grub.cfg
# 把 menuentry "Ubuntu" 改成 "HexagonOS 0.1"

exit

## 步骤 6：Cubic 自动打包
Cubic 会问你：
- 压缩方式：选 gzip
- 输出文件：HexagonOS-0.1.iso

等几分钟，ISO 就生成了。

## 步骤 7：测试
用 VirtualBox 挂载 HexagonOS-0.1.iso 启动：
- 看到 GRUB 菜单：HexagonOS 0.1
- 登录后进入 Hexagon Shell
- 敲 time / Home page / open / Create document / rename / Shut down / help