#!usr/bin/env bash

#dir为当前目录
dir=`pwd`
#输出当前目录
echo $dir

#帮助
function helps {
       echo "the options:"
       echo "-c         input quality to compress JPEG images"
       echo "-h         get the help of the operations"
       echo "-v         turn all png/svg pictures into JPEG"
       echo "-s         input size to resize the JPEG/PNG/SVG picture"
       echo "-a         add text into the picture"
       echo "-n         rename all the png/svg pictures"
}

#JPEG图像压缩
function compress {
	#第一个参数
	quality=$1
	#反引号表示将命令执行结果赋值给变量
	for file in `ls $dir`
	do
	  #表示删掉最后一个.及其左边的字符串
          extension=${file##*.}
	  echo $extension
	  if [[ $extension == "jpg" ]];then
	     echo $file
             echo "compressing......";
	     #在当前目录创建输出图片文件
	     out=$dir/compress_$file
	     #压缩语句
	     convert -quality $quality $file $out
	  fi
	 done
}

#保持原始宽高比调整图片分辨率
function resize {
         size=$1
	 for file in `ls $dir`
	 do
	   extension=${file##*.}
           if [[ $extension == "jpg" ]] || [[ $extension == "png" ]] || [[ $extension == "svg" ]];then
	   out=$dir/resize_$file
           echo $file
           echo "resizing.......";
	   #改变分辨率语句
           convert -sample $size"%x"$size"%" $file $out
           fi
         done
 }

#图片批量添加自定义文本水印
function add_text {
	#颜色
	color=$1
	#字体大小
	size=$2
	#文本内容
	text=$3
	for file in `ls $dir`
	do
          extension=${file##*.}
	  echo $file
          if [[ $extension == "jpg" ]] || [[ $extension == "png" ]] || [[ $extension == "svg" ]];then
	  echo $file
	  echo "drawing";
	  out=$dir/draw_$file
	  #在图片10，80处添加水印语句
	  convert -fill $color -pointsize $size -draw "text 10,80 '$text'" $file $out
          fi
	done
}

#图像转为JPEG格式
function converting {
	for file in `ls $dir`
	do
          extension=${file##*.}
	  #echo $file
	  if [[ $extension == "png" ]] || [[ $extension == "svg" ]];then
	  echo $file
          #%.*表示删除.及其右边的所有字符串
          out=$dir/type_${file%.*}.jpg
	  echo $out
	  echo "converting"
	  convert $file $out
          fi
	done
}

#重命名
function rename {
	new_name=$1
        for file in `ls $dir`
	do
          extension=${file##*.}
	  echo $file
          if [[ $extension == "jpg" ]] || [[ $extension == "png" ]] || [[ $extension == "svg" ]];then
          echo $file
	  out=$dir/$new_name.${file##*.}
	  echo $out
	  echo "renaming";
	  convert $file $out
          fi
	done
}

#主函数入口
#参数个数等于0，就一直循环,shitf表示参数左移
while [[ "$#" -ne 0 ]];do
  case $1 in
	  "-c")
		  compress $2
		  shift 2;;
	  "-s")
		  resize $2
		  shift 2;;
	  "-h")
		  helps
		  shift;;
          "-a")
		  add_text $2 $3 $4
		  shift 4;;
          "-v")
		  converting
		  shift;;
	  "-n")
		  rename $2
	          shift 2;;
	  *)
		  echo "输入错误";;
	       esac
done




