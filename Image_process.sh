#!usr/bin/env bash

dir=`pwd`
echo $dir

# 帮助
function helps {
	  echo "the options:"
	  echo "-c        input quality to compress JPEG images"
	  echo "-h        get the help of the operations"
	  echo "-v        turn all png/svg pictures into JPEG"
	  echo "-s        input size to resize the JPEG/PNG/SVG pictures"
	  echo "-a        add text into the pictures"
	  echo "-n        rename all the png/svg pictures"
}

# JPEG图像压缩
function compress {
	  quality=$1
	  #``返回执行后的结果
	  for file in `ls $dir`
          do
	  # ##.表示删掉最后一个.及其左边的字符串,即jpg
          extension=${file##*.}
	    if [ $extension == "jpg" ];then
              echo $file
	      echo "compressing........";
	      out=$dir/compress_$file
	      #质量压缩语句
	      convert -quality $quality"%" $file $out
            fi
          done
}

# 保持原始宽高比的前提下压缩分辨率
function resize {
	  size=$1
	  for file in `ls $dir`
          do
	  extension=${file##*.}
	     if [ $extension == "jpg" ] || [ $extension == "png" ] || [ $extension == "svg" ];then
	     out=$dir/resize_$file
	     echo $file
	     echo "resizing......";
             #压缩分辨率语句
	     convert -sample $size"%x"$size"%" $file $out
	     fi
	  done

}

# 批量加入文本
function add_text {
	  color=$1
	  size=$2
	  text=$3
	  for file in `ls $dir`
	  do
	  extension=${file##*.}
	    if [ $extension == "jpg" ] || [ $extension == "png" ] || [ $extension == "svg" ];then
	     echo $file
	     echo "drawing......";
	     # %.*表示删掉最后一个 .及其右边的字符串
	     out=$dir/draw_${file%.*}.${file##*.}
	     #color字体颜色 size字体大小 text文本内容
	     convert -fill $color -pointsize $size -draw "text 15,50 '$text'" $file $out
	    fi
	  done
}

# 图像转为JPEG格式
function converting {
  for file in `ls $dir`
    do
        extension=${file##*.}
    #echo $file
    if [ $extension == "png" ] || [ $extension == "svg" ];then
        out=$dir/type_${file%.*}.jpeg
        echo $out
        echo "converting......";
        convert $file $out
    fi
  done
}

# 重命名
function rename {
	  new_name=$1
	  for file in `ls $dir`
	    do
	     extension=${file##*.}
	     if [ $extension == "jpg" ] || [ $extension == "png" ] || [ $extension == "svg" ];then
		echo $file
		out=$dir/$new_name.${file##*.}
		echo $out
		echo "renaming......";
		convert $file $out
	     fi
	  done
}

# 主函数入口
#$#表参数个数 -ne：不等于
while [[ "$#" -ne 0 ]]; do
	 case $1 in
	      	 "-c")   compress $2
			 #shift表示参数的左移
			 shift 2;; 
		 "-s")   resize $2 
			 shift 2;;
		 "-h")   helps
			 shift;;
		 "-a")   add_text $2 $3 $4
			 shift 4;;	
		 "-c")   converting
			 shift;;
		 "-n")   rename $2
			 shift 2;; 
		 "*")    echo "输入错误"
	esac
done
