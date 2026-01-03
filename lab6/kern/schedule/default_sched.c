#include <defs.h>
#include <list.h>
#include <proc.h>
#include <assert.h>
#include <default_sched.h>

/*
 * RR_init initializes the run-queue rq with correct assignment for
 * member variables, including:
 *
 *   - run_list: should be an empty list after initialization.
 *   - proc_num: set to 0
 *   - max_time_slice: no need here, the variable would be assigned by the caller.
 *
 * hint: see libs/list.h for routines of the list structures.
 */
static void
RR_init(struct run_queue *rq)
{
    // LAB6: 2311366
    // 初始化运行队列的链表为空
    list_init(&(rq->run_list));
    // 初始时队列中进程数为0
    rq->proc_num = 0;
}

/*
 * RR_enqueue inserts the process ``proc'' into the tail of run-queue
 * ``rq''. The procedure should verify/initialize the relevant members
 * of ``proc'', and then put the ``run_link'' node into the queue.
 * The procedure should also update the meta data in ``rq'' structure.
 *
 * proc->time_slice denotes the time slices allocation for the
 * process, which should set to rq->max_time_slice.
 *
 * hint: see libs/list.h for routines of the list structures.
 */
static void
RR_enqueue(struct run_queue *rq, struct proc_struct *proc)
{
    // LAB6: 2311366
    // 断言：进程的运行队列链表节点应该为空（即进程不在任何队列中）
    assert(list_empty(&(proc->run_link)));
    // 将进程的run_link节点加入到运行队列的尾部（实现FIFO）
    list_add_before(&(rq->run_list), &(proc->run_link));
    // 如果进程时间片为0或已用完，重新分配最大时间片
    if (proc->time_slice == 0 || proc->time_slice > rq->max_time_slice) {
        proc->time_slice = rq->max_time_slice;
    }
    // 设置进程所属的运行队列
    proc->rq = rq;
    // 运行队列中的进程数加1
    rq->proc_num ++;
}

/*
 * RR_dequeue removes the process ``proc'' from the front of run-queue
 * ``rq'', the operation would be finished by the list_del_init operation.
 * Remember to update the ``rq'' structure.
 *
 * hint: see libs/list.h for routines of the list structures.
 */
static void
RR_dequeue(struct run_queue *rq, struct proc_struct *proc)
{
    // LAB6: 2311366
    // 断言：进程的run_link应该在某个队列中（不为空）
    assert(!list_empty(&(proc->run_link)) && proc->rq == rq);
    // 将进程的run_link节点从运行队列中删除，并重新初始化该节点
    list_del_init(&(proc->run_link));
    // 运行队列中的进程数减1
    rq->proc_num --;
}

/*
 * RR_pick_next picks the element from the front of ``run-queue'',
 * and returns the corresponding process pointer. The process pointer
 * would be calculated by macro le2proc, see kern/process/proc.h
 * for definition. Return NULL if there is no process in the queue.
 *
 * hint: see libs/list.h for routines of the list structures.
 */
static struct proc_struct *
RR_pick_next(struct run_queue *rq)
{
    // LAB6: 2311366
    // 获取运行队列链表的第一个节点（队首）
    list_entry_t *le = list_next(&(rq->run_list));
    // 如果链表不为空（有可运行的进程）
    if (le != &(rq->run_list)) {
        // 通过le2proc宏将链表节点转换为对应的进程控制块指针
        return le2proc(le, run_link);
    }
    // 如果队列为空，返回NULL
    return NULL;
}

/*
 * RR_proc_tick works with the tick event of current process. You
 * should check whether the time slices for current process is
 * exhausted and update the proc struct ``proc''. proc->time_slice
 * denotes the time slices left for current process. proc->need_resched
 * is the flag variable for process switching.
 */
static void
RR_proc_tick(struct run_queue *rq, struct proc_struct *proc)
{
    // LAB6: 2311366
    // 检查进程的时间片是否大于0
    if (proc->time_slice > 0) {
        // 时间片减1
        proc->time_slice --;
    }
    // 如果时间片用完了
    if (proc->time_slice == 0) {
        // 设置need_resched标志，表示需要进行进程调度
        proc->need_resched = 1;
    }
}

struct sched_class default_sched_class = {
    .name = "RR_scheduler",
    .init = RR_init,
    .enqueue = RR_enqueue,
    .dequeue = RR_dequeue,
    .pick_next = RR_pick_next,
    .proc_tick = RR_proc_tick,
};
