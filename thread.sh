#!/bin/bash
######本脚本是简单测试shell中的多线程的实现方式，和线程间通讯的解决办法。
trap "exec 1000<&-;exec 1000 >&-;exit 1 " 2
mkfifo myfifo1 #### mkfifo:创建命名管道的命令,这可以解决线程间通讯的问题，myfifo1文件是管道文件，一次只能传递一行，并且必须读出和写入同时进行才可。而且该文件是存在在内存系统中的，但可以向普通文件一样操作。

 {
echo "echo2to1" >myfifo1 ##线程1中向管道写入了文件，但因为没有读取，所以线程会一直等待，直到有了读出
echo -e "\033[45;34m我是echo2\033[0m`date +%s`"
sleep 5
echo $$
}& ### &:是后台运行的符号，shell脚本是通过后台运行的方式来实现多线程并发的，但是这有一个问题，就是后台支持的线程数是有限的，我们不能无限的创建，而列举的方式指定线程数也很麻烦，这里需要用到文件描述符和命名管道结合的方式
{
var=`cat myfifo1`  ##读取线程1中传入的数据，简单的实现了线程通讯。
echo -e "\033[42;36m我是$var\033[0m`date +%s`"
sleep 5
echo $$
}&
wait
echo -e "\033[45;34m我是echo3\033[0m`date +%s`"
echo $$
rm -f myfifo1
exit 0
#####线程间通讯，不同于脚本内通讯，shell脚本中的线程，因为是在后台运行的，所以无法通过定义在脚本中的函数，变量，文件进行通讯。
