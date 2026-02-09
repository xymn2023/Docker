#!/bin/bash

# 确保以 root 权限运行
if [ "$EUID" -ne 0 ]; then 
  echo "请使用 sudo 运行此脚本"
  exit 1
fi

echo "正在配置 Docker 镜像源..."

# 创建配置目录（如果不存在）
mkdir -p /etc/docker

# 定义镜像地址
MIRRORS='[
    "https://docker.m.daocloud.io",
    "https://docker.1panel.live",
    "https://hub.rat.dev"
]'

# 写入配置文件
cat <<EOF > /etc/docker/daemon.json
{
    "registry-mirrors": $MIRRORS
}
EOF

echo "配置文件已更新至 /etc/docker/daemon.json"

# 重新加载配置并重启 Docker
echo "正在重启 Docker 服务..."
systemctl daemon-reload
systemctl restart docker

if [ $? -eq 0 ]; then
    echo "✅ Docker 镜像源配置成功！"
    docker info | grep "Registry Mirrors" -A 3
else
    echo "❌ Docker 重启失败，请检查配置文件格式。"
fi
