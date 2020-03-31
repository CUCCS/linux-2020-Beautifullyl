# 实验报告chap0x02
## 软件环境
Ubuntu 18.04 Server 64bit
## 实验任务
### 1.在asciinema注册一个账号，并在本地安装配置好asciinema
* 使用putty链接虚拟机，在putty上进行操作

* 根据[官方提供安装方法](https://asciinema.org/docs/installation),输入以下代码：
  
```
sudo apt-add-repository ppa:zanchey/asciinema
sudo apt-get update
sudo apt-get install asciinema
```
### 2.确保本地已经完成asciinema auth，并在asciinema成功关联了本地账号和在线账号
* putty中输入`asciinema auth`

打开出现网址，完成关联。
### 3.上传本人亲自动手完成的vimtutor操作全程录像
[Lesson 1](https://asciinema.org/a/Aqv63i9jMgGFvwVF3CXyICiLf)

[Lesson 2](https://asciinema.org/a/LknJd2P8UABzNPTgdw3lG0fC7)

[Lesson 3](https://asciinema.org/a/pcpggIqrt06Z6TkZK9UB4uhAy)

[Lesson 4,5,6,7](https://asciinema.org/a/pgu7eyWLpigAguCSxwwMU8HSB)
## vimtutor完成后的自查清单
* 你了解vim有哪几种工作模式？
  + Normal模式
  + 编辑模式
  + 命令模式
  + VISUAL模式
* Normal模式下，从当前行开始，一次向下移动光标10行的操作方法？如何快速移动到文件开始行和结束行？如何快速跳转到文件中的第N行？
  + 输入:   `10j`
  + 移到文件开始:   `gg`
  + 移到文件结束:   `G`
  + 跳转到第N行:    `[N]G`
* Normal模式下，如何删除单个字符、单个单词、从当前光标位置一直删除到行尾、单行、当前行开始向下数N行？
  + 删除单个字符：`x`或`X`
  + 删除单个单词：`dw`或`de`
  + 当前光标删到行尾：`d$`
  + 删除单行：`dd`
  + 当前行向下数N行： `[N]dd`
* 如何在vim中快速插入N个空行？如何在vim中快速输入80个-？
  + 插入N个空行： `[N]o`
  + 输入80个-：`80i-`
* 如何撤销最近一次编辑操作？如何重做最近一次被撤销的操作？
  + 撤销最近一次编辑操作：`u`
  + 重做最近一次被撤销的操作：ctrl+r
* vim中如何实现剪切粘贴单个字符？单个单词？单行？如何实现相似的复制粘贴操作呢？
  + 复制:

  复制单个单词：`yw`

  复制单行：`yy`

  复制N行：`[N]yy`

  复制选中文本：输入`v`进入VISUAL模式，移动光标选中内容，输入`y`
  + 粘贴：同意输入：`p`
* 为了编辑一段文本你能想到哪几种操作方式（按键序列）？

`a`  `A`

`c [number] motion` `ce`

`dd` `d  motion`

`i` `o` `p` `r` `R` `u` `x`
* 查看当前正在编辑的文件名的方法？查看当前光标所在行的行号的方法？
 
  ctrl+g
* 在文件中进行关键词搜索你会哪些方法？如何设置忽略大小写的情况下进行匹配搜索？如何将匹配的搜索结果进行高亮显示？如何对匹配到的关键词进行批量替换？
  + 关键词搜索：`:/ keyword`或者`:? keyword`
  + 忽略大小写：`:set ic`
  + 高亮显示：`:set hls is`
  + 批量替换：`:%s/old/new/g`
* 在文件中最近编辑过的位置来回快速跳转的方法？
  + ctrl+o或者ctrl+i
* 如何把光标定位到各种括号的匹配项？例如：找到(, [, or {对应匹配的),], or }
  
  光标移到某一括号，输入`%`
* 在不退出vim的情况下执行一个外部程序的方法？
 
  `!程序名称`

* 如何使用vim的内置帮助系统来查询一个内置默认快捷键的使用方法？如何在两个不同的分屏窗口中移动光标？
  + 查询：`:help 快捷键名称`
  + 移动光标：
  CTRL+w +<h | j | k | l>

## 参考文献
[Vim的分屏功能命令大全](https://www.jb51.net/article/96585.htm)

vimtutor