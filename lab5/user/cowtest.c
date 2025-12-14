#include <ulib.h>
#include <stdio.h>

// 用全局变量来测试 COW，确保地址在数据段里
static int shared = 0;

int main(void) {
    cprintf("COW test start\n");

    // 父进程先写
    shared = 1;
    cprintf("parent: initial shared = %d, addr = %p\n", shared, &shared);

    int pid = fork();
    if (pid < 0) {
        cprintf("fork failed\n");
        exit(-1);
    }

    if (pid == 0) {
        // 子进程
        cprintf("child: after fork, shared = %d, addr = %p\n", shared, &shared);

        // 子进程修改，应该触发写时拷贝
        shared = 2;
        cprintf("child: after write, shared = %d, addr = %p\n", shared, &shared);

        exit(0);
    } else {
        // 父进程
        int ret = wait();
        cprintf("parent: child %d exited with %d\n", pid, ret);

        // 父进程再读，应该仍然是 1
        cprintf("parent: after child write, shared = %d, addr = %p\n", shared, &shared);

        cprintf("COW test end\n");
        return 0;
    }
}
