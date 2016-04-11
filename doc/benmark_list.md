# Job Documents

## aim7&aim9

usable: no

tag: cpu; io; function call; suite;

introduction: 

    AIM7 is a program written in C that forks many processes called tasks, each of which concurrently runs in random order a set of subtests called jobs.
    the AIM Independent Resource Benchmark exercises and times each component of a UNIX computer system, independently. The benchmark uses 58 subtests to generate absolute processing rates, in operations per second, for subsystems, I/O transfers, function calls, and UNIX system calls. GPL'd and can be published under the "non-audited" clause. 

page: http://lbs.sourceforge.net/

## blogbench

usable: hold

tag: io;

introdution: 

    Blogbench is a portable filesystem benchmark that tries to reproduce the load of a real-world busy file server.
    It stresses the filesystem with multiple threads performing random reads, writes and rewrites in order to get a realistic idea of the scalability and the concurrency a system can handle.

page: https://www.pureftpd.org/project/blogbench

## dbench

usable: yes

tag: io;

introduction: 

    DBENCH is a tool to generate I/O workloads to either a filesystem or to a networked CIFS or NFS server. It can even talk to an iSCSI target. DBENCH can be used to stress a filesystem or a server to see which workload it becomes saturated

page: https://dbench.samba.org/

## dd-write

usable: yes

tag: io;

introduction: 

    Use Linux `dd` command to test filesystem io workload.

page: https://romanrm.net/dd-Benchmark

## ebizzy

usable: yes

tag: cpu; memory;

introduction:

    ebizzy is designed to generate a workload resembling common web application server workloads.  It is highly threaded, has a large in-memory working set with low locality, and allocates and deallocates memory frequently.  When running most efficiently, it will max out the CPU. The records per second rate should be as high as possible, and the system time as low as possible.

page: https://sourceforge.net/p/ltp/git/ci/1eb440c2b5fe43a3e5023015a16aa5d7d3385b1e/tree/utils/benchmark/ebizzy-0.3/README

## ext4-frags

usable: yes

tag: io;

introduction:

```
mke2fs -t ext4 -b 1024 -J size=1 -q $partition
mount -t ext2 $partition $mnt 2>/dev/null ||
mount -t ext4 $partition $mnt             || exit
mkdir $mnt/a
cd $mnt/a
seq 1 210000  | xargs -n 1 fallocate -l 1m
seq 1 2 210000  | xargs /bin/rm
mkdir $mnt/b
cd $mnt/b
seq 1 103 | xargs -n 1 fallocate -l 1g
```

## fileio

usable: yes

tag: io;

introduction:

    use `fallocate` and `sysbench` to test.
    SysBench is a modular, cross-platform and multi-threaded benchmark tool for evaluating OS parameters that are important for a system running a database under intensive load.

page: https://github.com/akopytov/sysbench

## fsmark/fwq

usable: yes

tag: io;

introduction: 

    The fs_mark benchmark tests synchronous write workloads. It can vary the number of files, directory depth, etc. It has detailed timings for reads, writes, unlinks and fsyncs that make it good for simulating mail servers and other setups.

page: https://sourceforge.net/projects/fsmark/

## ftq

usable: no

tag: cpu;

introduction:

    FWQ (fixed work quanta) and FTQ (fixed time quanta) run on each core and hardware thread within a single node via pthreads. 
    The FTQ and FWQ benchmarks measure hardware and software interference or ‘noise’ on a node from the applications perspective. 

page: https://asc.llnl.gov/sequoia/benchmarks/#ftq

## ftrace_onoff

usable: no

tag: debug;

introduction:

    Ftrace is an internal tracer designed to help out developers and designers of systems to find what is going on inside the kernel. It can be used for debugging or analyzing latencies and performance issues that take place outside of user-space.

page: http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/trace/ftrace.txt

## glbenchmark

usable: hold

tag: graphics;

introduction:

    Equal to GFXBench.
    GLBenchmark 2.7 is a graphics performance benchmark tool that measures different graphic and computation capabilities of your mobile device. The majority of the tests focus on graphic resources, measuring the quality and performance of the underlying OpenGL ES 2.x implementation.

page: https://gfxbench.com/benchmark.jsp

## hackbench

usable: yes

tag: io;

introduction:


Hackbench  is  both  a benchmark and a stress test for the Linux kernel scheduler. It's main job is to create a specified number  of  pairs  of schedulable entities
(either threads or traditional processes) which communicate via either sockets or
pipes and time how long it takes  for each pair to send data back and forth.
hpcc
idle
iozone
iperf
kbuild
kernel_selftests
ku-latency
kvm-unit-tests
linpack
locktorture
ltp
mce-test
nbench
ndctl
nepim
netperf
netpipe
nuttcp
oltp
packetdrill
pbzip2
perf-bench-numa-mem
perf-bench-sched-pipe
pft
phoronix-test-suite
piglit
pigz
pixz
plzip
pm-qa
postmark
pxz
qperf
rcutorture
reaim
siege
sockperf
stutter
suspend
tbench
tcrypt
thrulay
tlbflush
trinity
unixbench
vm-scalability
will-it-scale
xfstests
