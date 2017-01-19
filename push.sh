#!/bin/sh

echo "\033[34;5m *****Git***** \033[0m"
git add .
echo "请输入提交信息："
read message
git commit -m $message
git push
echo "\033[32;5m *************Success************* \033[0m"