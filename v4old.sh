#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' 

echo -e "${GREEN}一键在仅ipv6系统上添加ipv4出口脚本 github@lynn-becky${NC}"
echo "NAT64是全局的，在执行github脚本时（如安装探针）可不添加proxychains选项，但速度可能较慢"
echo "Warp往往有着更快的速度，但并非是全局的，需要进行配置才可使用"
echo "个人建议先使用NAT64进行开局，安装所需要的脚本，再使用warp做为日常使用"
echo "二者请只使用其中之一"
echo "1. 使用NAT64服务"
echo "2. 使用Warp服务"
echo "3. 不再使用NAT64服务"
echo "4. 持久化NAT64"
echo "5. 不再持久化NAT64"
read -p "请输入选项数字: " choice

case $choice in
  1)
    echo -e "${YELLOW}你选择了NAT64服务${NC}"
    cp /etc/resolv.conf /etc/resolv.conf.bak
    echo -e "nameserver 2a01:4f8:c2c:123f::1\nnameserver 2a00:1098:2c::1\nnameserver 2a01:4f9:c010:3f02::1" > /etc/resolv.conf
    echo -e "${GREEN}在lxc虚拟化的系统上，重启会导致NAT64服务失效，需使用对应命令修复${NC}"    
    echo -e "${GREEN}执行完毕${NC}"
    ;;
  2)
    echo -e "${YELLOW}你选择了Warp服务${NC}"
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
    echo -e "${GREEN}执行完毕${NC}"
    ;;
  3)
    echo -e "${YELLOW}你选择了恢复为正常DNS${NC}"
    if [ -e /etc/resolv.conf.bak ]; then
      cp /etc/resolv.conf.bak /etc/resolv.conf
      echo -e "${GREEN}DNS配置已恢复为正常状态${NC}"
    else
      echo -e "${RED}备份文件不存在，无法恢复DNS配置${NC}"
    fi
    ;;
  4)
    echo -e "${YELLOW}你选择了持久化NAT64${NC}"
    touch /etc/.pve-ignore.resolv.conf
    echo -e "${GREEN}执行完毕${NC}"
    ;;
  5)
    echo -e "${YELLOW}你选择了不再持久化NAT64${NC}"
      rm /etc/.pve-ignore.resolv.conf
      echo -e "${GREEN}执行完毕${NC}"
    ;;
  *)
    echo -e "${RED}无效的选项，请重新运行脚本并选择有效的选项。${NC}"
    exit 1
    ;;
esac
