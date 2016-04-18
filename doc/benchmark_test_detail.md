# Representative Benchmark Test

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

