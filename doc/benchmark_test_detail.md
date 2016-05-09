# Representative Benchmark Test

## Summary

为了在安卓的环境下运行之前Linux下的测试用例，经过与曹和敖的讨论，发现问题的关键在于安卓环境和Linux文件系统（比如Debian）的区别，这个区别主要体现在重要的库不包含，比如libc，这就导致运行时链接所需的动态链接库无法找到，因而无法运行

这个问题对于那些使用gcc编译运行的Benchmark来说，可以采用静态编译的方式避免，即在编译选项中加入：

```
CFLAG=static
```

对于64位的gcc一般来说还需要加上`-m32`选项，因为测试的安卓系统（除了最新的）是只有32位的。

```
CFLAG=static -m32
```

需要注意的是，这种解决方法只支持有源码，可以使用gcc编译的Benchmark，而对于一些不开源、只有二进制文件的程序，需要视情况而定，不一定能够在安卓上运行。

另一个思路，经过chy老师指点，可以在安卓上安装Linux Deploy程序，搭建一个和Linux一样的文件系统，这样Linux上能够运行的Benchmark大部分都可以直接运行。

但是我想到的一个问题是，这样与直接在Linux环境上测有何区别？如果是要测不同ROM版本下对系统性能的影响，使用Linux Deploy直接换成Linux的环境对此有没有影响？不过考虑到安卓发布的其内核与Linux内核还是有细微差异，这样想来也还是有必要底层必须使用安卓环境测。

当然这种方法也是只支持命令行界面的Benchmark，对于图形界面的测试还是无能为力的。

## Graphics

### glxbench

集中于测试性能，而对是否能启动图形界面无法测试。另外测试界面是图形化的，开始需要鼠标点击，而且第一次开始前可能需要下载一些测试包。故舍弃使用。

### piglit

是图形测试OpenGL的另外一个，需要安装一系列依赖（如下所示），还需要另外安装一个开源库[waffle](https://github.com/waffle-gl/waffle)

    dependency: `sudo apt-get install cmake g++ mesa-common-dev libgl1-mesa-dev python-numpy python-mako freeglut3-dev x11proto-gl-dev libxrender-dev libgles2-mesa-dev`

安装好全部依赖后，尝试运行piglit，但是总是会报错找不到waffle的动态链接库文件。暂时没找到解决方案。

## IO

### fsmark

运行`lkp pack fsmark`即可下载安装，

运行`lkp run jobs/fsmark-generic-1hdd-test.yaml`可得到正确结果。

```
2016-04-15 15:59:19 ./fs_mark -d /1 -d /2 -d /3 -d /4 -n 256 -L 1 -S 0 -s 1048576
#  ./fs_mark  -d  /1  -d  /2  -d  /3  -d  /4  -n  256  -L  1  -S  0  -s  1048576
#       Version 3.3, 4 thread(s) starting at Fri Apr 15 15:59:19 2016 
#       Sync method: NO SYNC: Test does not issue sync() or fsync() calls.
#       Directories:  no subdirectories used
#       File names: 40 bytes long, (16 initial bytes of time stamp with 24 random bytes at end of name)
#       Files info: size 1048576 bytes, written with an IO size of 16384 bytes per write
#       App overhead is time in microseconds spent in the test not doing file writing related system calls.
FSUse%        Count         Size    Files/sec     App Overhead
    55         1024      1048576        169.3            12321
```


## CPU/Memory

### LTP

下载LTP的官方tar包后，解压，按以下命令编译安装：

    ./configure
    make all
    make install

之后把安装的目录链接到$BENCHMARK_DIR：

    ln -s /opt/ltp /lkp/benchmarks/ltp

再用LKP的内部命令运行即可(本地运行)：

    lkp run jobs/ltp-1hdd.yaml

详见LTP[安装说明](https://github.com/linux-test-project/ltp/blob/master/INSTALL)

## Android

### Robotium

在Linux下，安装[Andriod Studio](http://developer.android.com/sdk/index.html)并且按照Robotium的[文档](https://github.com/RobotiumTech/robotium/wiki/Getting-Started#android-studio)，下载好示例工程代码，再依据Readme运行，可以实现本机的测试。

但是，对于如何将其与LKP-tests进行结合，有以下问题：

该测试实际上有两台设备，一台PC机、一台安卓机（或者虚拟的），是通过PC机输入`adb`命令控制安卓机的测试，但是LKP-tests的测试原理是一台机器（或者虚拟的）自己在本地环境运行测试用例的命令，并将运行结果储存，结果一般是命令行里的标准输出流。这样来看，如何控制qemu里的机器就成了难以绕过的问题。

