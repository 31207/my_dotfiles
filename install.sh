#!/bin/bash

# 设置变量
DOTFILES_DIR="$HOME/my_dotfiles"
CONFIG_DIR="$HOME/.config"
DIRS=(i3 kitty polybar rofi fastfetch dunst go-musicfox conky alacritty)

echo "正在将配置文件复制到 $CONFIG_DIR ..."

# 遍历每个目录
for dir in "${DIRS[@]}"; do
    SRC="$DOTFILES_DIR/$dir"
    DEST="$CONFIG_DIR/$dir"
    sudo rm -rf "$DEST"
    # 创建目标目录
    sudo mkdir -p "$DEST"

    # 复制内容
    sudo cp -r "$SRC/"* "$DEST/"
    echo "已复制 $dir 到 $DEST"
done

# 单独处理 picom.conf
cp "$DOTFILES_DIR/picom.conf" "$CONFIG_DIR/picom.conf"
echo "已复制 picom.conf 到 $CONFIG_DIR"
sudo chmod +x ~/.config/i3/*.sh

echo "配置文件复制完成。"
