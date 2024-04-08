#!/bin/bash

year=2020  # 设置要查询的年份
directory="/mnt/vena/pics" # 定义源目录
# 定义文件大小阈值 M
SIZE_LIMIT=5000
# 定义目标目录的基路径
BASE_TARGET_DIR="/mnt/vena/pics0"

# 用于计数的目标目录编号
DIR_COUNT=1

for file in $(find $directory -type f -newermt "${year}-01-01" ! -newermt "${year}-12-31"); do
    #echo "$file" # 输出符合条件的文件名或者其他操作
    # 计算文件大小
    size=$(stat -c%s "$file")
    
    # 检查当前目标目录的大小是否超过了SIZE_LIMIT
    if [ $(du -k $BASE_TARGET_DIR/$DIR_COUNT | cut -f1) -gt $((SIZE_LIMIT*1024)) ]; then
        # 如果超过了阈值，则增加目标目录编号
        DIR_COUNT=$((DIR_COUNT+1))
        
        # 创建新的目标目录
        mkdir -p $BASE_TARGET_DIR/$DIR_COUNT
    fi

    # 拷贝文件到当前的目标目录
	echo 'cp-path: ' + $BASE_TARGET_DIR/$DIR_COUNT/
    cp "$file" $BASE_TARGET_DIR/$DIR_COUNT/
done
