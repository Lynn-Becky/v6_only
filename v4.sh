#!/bin/bash

echo "一键在仅限ipv6主机上访问ipv4脚本 @lynn_becky"
echo "NAT64在执行github脚本时（如安装探针）可不添加proxychains选项，但速度可能较慢"
echo "Warp往往有着更快的速度，更干净的ip，但在部分主机上并非是全局的，需要进行配置"
echo "个人建议先使用NAT64进行开局，安装所需要的脚本，再使用warp做为日常使用"
echo "二者请只使用其中之一"
echo "1. 使用NAT64服务"
echo "2. 使用Warp服务"
echo "3. 恢复为正常DNS"
read -p "请输入选项数字: " choice

case $choice in
  1)
    echo "你选择了NAT64服务"
    cp /etc/resolv.conf /etc/resolv.conf.bak
    echo -e "nameserver 2a01:4f8:c2c:123f::1\nnameserver 2a00:1098:2c::1\nnameserver 2a01:4f9:c010:3f02::1" > /etc/resolv.conf
    echo "原文件已经备份，恢复请使用选项3'"
    ;;
  2)
    echo "你选择了Warp服务"
    apt update && apt install -y curl gnupg lsb-release proxychains4
    curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg |  gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/cloudflare-client.list
    apt update && apt install -y cloudflare-warp
    warp-cli register 
    warp-cli set-mode proxy
    warp-cli set-proxy-port 1835
    warp-cli connect
    warp-cli enable-always-on
    apt install wget
    curl -Ls https://raw.githubusercontent.com/Lynn-Becky/v6_only/main/proxychains4.conf -o proxychains4.conf
    mv proxychains4.conf /etc/proxychains4.conf 
    ;;
  3)
    echo "你选择了恢复为正常DNS"
    if [ -e /etc/resolv.conf.bak ]; then
      cp /etc/resolv.conf.bak /etc/resolv.conf
      echo "DNS配置已恢复为正常状态"
    else
      echo "备份文件不存在，无法恢复DNS配置"
    fi
    ;;
  *)
    echo "无效的选项，请重新运行脚本并选择有效的选项。"
    ;;
esac
