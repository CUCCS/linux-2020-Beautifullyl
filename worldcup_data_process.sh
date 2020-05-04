#!usr/bin/env bash
echo '------------------------------------------------------------'
echo '--  本脚本用于统计 worldcupplayerinfo.tsv 文件中以下数据  --'
echo '-------------------------------------------------------------'
echo '统计不同年龄区间范围（20岁以下、[20-30]、30岁以上）的球员数量、百分比'
echo '统计不同场上位置的球员数量、百分比'
echo '名字最长的球员是谁？名字最短的球员是谁？'
echo '年龄最大的球员是谁？年龄最小的球员是谁？'
echo '-------------------------------------------------------------'
#当前目录
dir=`pwd`
#统计不同年龄区间的球员数量和百分比
function num_by_age {
	#计数器
	count20=0
	count_between=0
	count30=0
	i=0
        #此处数组加引号使遇到元素中的空格不换行
	#遍历年龄数组，判断年龄段，并计数
	for i in "${age[@]}";do
	  if [[ $i -lt 20 ]]
	  then
	  ((count20++))
          elif [[ $i -le 30 ]]
	  then
	  ((count_between++))
          else
          ((count30++))
          fi
	done
	#打印结果
	#bash不支持浮点运算，需要借助bc awk处理
	printf "20岁以下的球员有%-5d个，占比%-10.6f%% \n" $count20 $(echo "scale=10;$count20/$count*100" |bc -l | awk '{printf "%f",$0}')
	#scale表示小数精度，bc输出只有小数点后数字，将结果代入awk处理，输出浮点数
        printf "20-30岁的球员有%-5d个，占比%-10.6f%% \n" $count_between $(echo "scale=10;$count_between/$count*100" |bc -l | awk '{printf "%f",$0}')
        printf "30岁以上的球员有%-5d个，占比%-10.6f%% \n" $count30 $(echo "scale=10;$count30/$count*100" |bc -l | awk '{printf "%f",$0}')
 }

#计算不同场上位置的球员数量和百分比
function num_by_position {
	#vRs的意义，数组赋值，array是去掉position不必要的空格等
	array=($(awk -vRS=' ' '!a[$1]++' <<< "${position[@]}"))
	i=0
	#声明member数组，position为指数，元素为人数，初始化为0
	declare -A member
	for((i=0;i<${#array[@]};i++))
	{
		m=${array[$i]}
		member["$m"]=0
	}
	#遍历position数组，计数
	for each in "${position[@]}";do
	   case $each in
		   ${array[0]})
			   ((member["${array[0]}"]++));;
		   ${array[1]})
			   ((member["${array[1]}"]++));;
	           ${array[2]})
			   ((member["${array[2]}"]++));;
                   ${array[3]})
			   ((member["${array[3]}"]++));;
	           ${array[4]})
			   ((member["${array[4]}"]++));;
		   esac
        done
        printf "%-10s :%10s %15s  \n" "Position" "Number" "Percent" 
	for((i=0;i<${#array[@]};i++))
	{
	  temp=${member[${array[$i]}]}
          printf "%-10s :%10d %15.8f %% \n" ${array[$i]} $temp $(echo "scale=10; $temp/$count*100" | bc -l| awk '{printf "%f", $0}')
  }

}

#统计名字最长和最短的球员
function name_by_namelen {
	i=0
	#名字最长和最短的长度
	max_name=0
	min_name=0
	#找出名字最长和最短的球员序号
	while [[ i -lt $count ]]
	do
	  #去掉字符串中所有*
	  name=${player[$i]//\*/}
	  #name的长度
	  n=${#name}
	  if [[ n -gt max_name ]];then
		  max_name=$n
		  max_num=$i
	  elif [[ n -lt min_name ]];then
		  min_name=$n
		  min_num=$i
	  fi
	  ((i++))
        done
	echo "名字最长的是 ${player[max_num]//\*/ }"
        echo "名字最短的是 ${player[min_num]}"

}

#统计年龄最大和最小的球员
function name_by_age {
	#最大和最小年龄的球员年龄
	oldest=0
	youngest=100
	i=0
        #找到最小和最大年龄球员的序号
	while [[ i -lt $count ]]
	do
		a=age[$i]
		if [[ a -lt $youngest ]];then
			youngest=$a
			max_num=$i
		elif [[ a -gt $oldest ]];then
			oldest=$a
			min_num=$i
		fi
		((i++))
	done
	echo "年龄最大的是 ${player[max_num]//\*/ }"
	echo "年龄最小的是 ${player[min_num]//\*/ }"
}

#主程序入口

#计数器
count=0
#以行读取文件
while read line
do
((count++))
if [[ $count -gt 1 ]];then
	#字符串转化为数组,以空格作为分隔
	str=(${line// /*})
	position[$(($count-2))]=${str[4]}
	age[$(($count-2))]=${str[5]}
	player[$(($count-2))]=${str[8]}
fi
done < worldcupplayerinfo.tsv
count=$(($count-1))
echo "数组元素个数为：$count"
echo "---------------"
num_by_age
echo "---------------"
num_by_position
echo "---------------"
name_by_namelen
echo "---------------"
name_by_age
