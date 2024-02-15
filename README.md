# v6_only
本脚本目标在仅ipv6的系统上提供ipv4+ipv6双栈访问能力
# 功能介绍

- 提供了Nat64与warp两种方式，获取ipv4访问能力
- warp引用了fscarmen大佬的脚本

# 部署

```
apt install -y curl && bash <(curl -Ls https://raw.githubusercontent.com/Lynn-Becky/v6_only/main/v4.sh)
```
目前在wap 1刀机上的debian11系统试验  

特别感谢各位大佬的命令，本脚本仅将其做整合

# 建议
先使用Nat64方式，安装warp，再关闭NAT64后正常使用
