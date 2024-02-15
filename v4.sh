#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' 

echo -e "${GREEN}一键在仅ipv6系统上添加ipv4出口脚本 github@lynn-becky${NC}"
echo "先使用NAT64安装warp，再关闭NAT64，将warp做为日常使用"
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
    wget -N https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh && bash menu.sh 4
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
