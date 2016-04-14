# Representative Benchmark Test

## Graphics

### glxbench

集中于测试性能，而对是否能启动图形界面无法测试。另外测试界面是图形化的，开始需要鼠标点击，而且第一次开始前可能需要下载一些测试包。故舍弃使用。

### piglit

是图形测试OpenGL的另外一个，需要安装一系列依赖（如下所示），还需要另外安装一个开源库[waffle](https://github.com/waffle-gl/waffle)

    dependency: `sudo apt-get install cmake g++ mesa-common-dev libgl1-mesa-dev python-numpy python-mako freeglut3-dev x11proto-gl-dev libxrender-dev libgles2-mesa-dev`

安装好全部依赖后，尝试运行piglit，但是总是会报错找不到waffle的动态链接库文件。暂时没找到解决方案。


