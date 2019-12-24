#!/bin/sh
echo "\e[1;34m \nInstalling Python Packages ...\e[0m"
pip3 install -r requirements.txt

echo "\e[1;34m \nDataloading ... \e[0m"
python3 python/future_loading.py