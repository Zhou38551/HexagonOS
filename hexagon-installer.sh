#!/bin/bash
# ============================================
# HexagonOS 0.1 - 安装向导
# 逻辑与 0.0.1 的 installer.c 一致
# ============================================

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root: sudo hexagon-installer"
    exit 1
fi

if ! command -v dialog &> /dev/null; then
    echo "Installing dialog..."
    apt install -y dialog
fi

# ---- 1. 蓝色欢迎画面 ----
dialog --backtitle "HexagonOS 0.1 Installer" \
       --title "Welcome" \
       --msgbox "\n\n       Welcome to HexagonOS 0.1\n\n       Loading installation files...\n\n" \
       15 60

# ---- 2. 选择磁盘 ----
DISKS=()
i=0
for disk in $(lsblk -dpno NAME | grep -E "/dev/(sd|nvme|vd)"); do
    size=$(lsblk -dpno SIZE "$disk")
    DISKS+=("$i" "$disk - $size")
    i=$((i+1))
done

if [ ${#DISKS[@]} -eq 0 ]; then
    DISKS=("0" "/dev/sda - 500 GB (SATA)" "1" "/dev/sdb - 1 TB (NVMe)" "2" "/dev/nvme0n1 - 256 GB (SSD)")
fi

DISK_CHOICE=$(dialog --backtitle "HexagonOS 0.1 Installer" \
                     --title "Select Disk" \
                     --menu "\nSelect installation disk:" \
                     18 65 6 \
                     "${DISKS[@]}" \
                     3>&1 1>&2 2>&3)

if [ $? -ne 0 ]; then
    exit 1
fi

# ---- 3. 用户协议 ----
dialog --backtitle "HexagonOS 0.1 Installer" \
       --title "License Agreement" \
       --yesno "\nHexagonOS 0.1 License:\n\n1. This is an experimental OS.\n2. Only English letters, digits, space, Enter.\n3. Other characters may crash.\n4. Use at your own risk.\n\nDo you agree to this license?" \
       18 65

if [ $? -ne 0 ]; then
    dialog --backtitle "HexagonOS 0.1 Installer" \
           --title "Aborted" \
           --msgbox "\nYou rejected the license.\nInstallation aborted." \
           10 50
    exit 1
fi

# ---- 4. 安装中（进度条） ----
(
    echo "10"; echo "XXX"; echo "Preparing disk..."; sleep 1
    echo "30"; echo "XXX"; echo "Installing system files..."; sleep 1
    echo "60"; echo "XXX"; echo "Configuring Hexagon Shell..."; sleep 1
    echo "85"; echo "XXX"; echo "Finalizing installation..."; sleep 1
    echo "100"; echo "XXX"; echo "Done."; sleep 0.5
) | dialog --backtitle "HexagonOS 0.1 Installer" \
           --title "Installing" \
           --gauge "\nInstalling HexagonOS..." \
           10 60 0

# ---- 5. 安装完成 ----
dialog --backtitle "HexagonOS 0.1 Installer" \
       --title "Complete" \
       --msgbox "\n       Thank you for installing HexagonOS\n\n       Installation successful!\n\n       Please reboot your system." \
       15 60

clear