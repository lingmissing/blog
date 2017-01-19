#!/bin/sh

echo "\033[34;5m *****build project***** \033[0m"
hexo clean
hexo d -g
echo "\033[32;5m *************Success************* \033[0m"