#!/bin/sh

ssh-keygen -t rsa -f ~/.ssh/vms -N ""
ssh-copy-id -i ~/.ssh/vms root@172.16.74.10

for ip in 172.16.74.{1..2}0{0..1}
do
    sshpass -p '1123' ssh-copy-id -i ~/.ssh/vms root@$ip
done