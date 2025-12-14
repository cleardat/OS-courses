#include <ulib.h>
#include <stdio.h>

// 多子进程 COW 测试：
// 1. 父进程把 shared = 1
// 2. fork 出 child1、child2，两者分别把 shared 改成 2 和 3
// 3. 父进程等待两个子进程退出后再读 shared，应该仍然是 1
// 4. 父进程自己再把 shared 改成 4，验证父写只影响自己的页

static int shared = 0;

static void
child_work(int id, int value) {
    cprintf("child%d: start, shared = %d, addr = %p\n",
            id, shared, &shared);
    shared = value;
    cprintf("child%d: after write, shared = %d, addr = %p\n",
            id, shared, &shared);
    exit(0);
}

int
main(void) {
    cprintf("COW multi test start\n");

    // 父进程先写 shared = 1
    shared = 1;
    cprintf("parent: initial shared = %d, addr = %p\n",
            shared, &shared);

    // 第一次 fork，创建 child1
    int pid1 = fork();
    if (pid1 < 0) {
        cprintf("fork1 failed\n");
        exit(-1);
    }
    if (pid1 == 0) {
        // 子进程1：把 shared 改成 2
        child_work(1, 2);
    }

    // 第二次 fork，创建 child2
    int pid2 = fork();
    if (pid2 < 0) {
        cprintf("fork2 failed\n");
        exit(-1);
    }
    if (pid2 == 0) {
        // 子进程2：把 shared 改成 3
        child_work(2, 3);
    }

    // 父进程：依次等待两个子进程结束
    int ret;
    ret = wait();
    cprintf("parent: child exited with %d\n", ret);
    ret = wait();
    cprintf("parent: child exited with %d\n", ret);

    // 此时两个子进程都退出，父进程再次读取 shared：
    // 如果 COW 正确，shared 仍然是最初的 1
    cprintf("parent: after children write, shared = %d, addr = %p\n",
            shared, &shared);

    // 父进程自己再写一次，验证父写在独占页上生效，不影响别人
    shared = 4;
    cprintf("parent: after parent write, shared = %d, addr = %p\n",
            shared, &shared);

    cprintf("COW multi test end\n");
    return 0;
}
