#include <defs.h>
#include <list.h>
#include <proc.h>
#include <assert.h>
#include <default_sched.h>

/**
 * RR（Round-Robin，轮转调度）算法实现
 * 
 * 算法原理：
 * - 所有就绪进程按FIFO顺序排列在运行队列中
 * - 每个进程分配相同的时间片（time_slice）
 * - 当进程时间片用完后，被放到队列尾部，调度下一个进程
 * - 适用于分时系统，保证公平性但不支持优先级
 * 
 * 数据结构：使用链表（list_entry_t）维护运行队列
 * 时间复杂度：入队O(1)、出队O(1)、选择下一个进程O(1)
 */

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
    // LAB6: YOUR CODE
    // 初始化运行队列的链表为空（双向循环链表）
    list_init(&(rq->run_list));
    // 进程数量设为0
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
    // LAB6: YOUR CODE
    // 断言：确保进程的run_link未在其他队列中（必须是空的）
    assert(list_empty(&(proc->run_link)));
    
    // 将进程加入运行队列尾部（FIFO顺序）
    // list_add_before会在run_list前插入，即加到队列尾部
    list_add_before(&(rq->run_list), &(proc->run_link));
    
    // 初始化或重置时间片
    // 如果进程的时间片为0或超过最大值，则重新设置为最大时间片
    if (proc->time_slice == 0 || proc->time_slice > rq->max_time_slice) {
        proc->time_slice = rq->max_time_slice;
    }
    
    // 设置进程所属的运行队列（反向指针，便于管理）
    proc->rq = rq;
    
    // 增加运行队列中的进程数量
    rq->proc_num++;
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
    // LAB6: YOUR CODE
    // 断言：确保进程确实在队列中且属于该运行队列
    assert(!list_empty(&(proc->run_link)) && proc->rq == rq);
    
    // 从运行队列中删除进程
    // list_del_init会删除节点并重新初始化为空链表
    list_del_init(&(proc->run_link));
    
    // 减少运行队列中的进程数量
    rq->proc_num--;
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
    // LAB6: YOUR CODE
    // 获取队列的第一个元素（队首）
    // run_list是头节点，list_next返回第一个实际节点
    list_entry_t *le = list_next(&(rq->run_list));
    
    // 如果队列不为空，返回队首进程
    if (le != &(rq->run_list)) {
        // le2proc宏：将list_entry转换为包含它的proc_struct指针
        // 参数：链表节点指针，proc_struct中的成员名
        return le2proc(le, run_link);
    }
    
    // 队列为空，返回NULL
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
    // LAB6: YOUR CODE
    // 每个时钟中断时被调用（通过sched_class_proc_tick）
    
    if (proc->time_slice > 0) {
        // 时间片减一（每次时钟中断消耗一个时间片）
        proc->time_slice--;
    }
    
    if (proc->time_slice == 0) {
        // 时间片耗尽，设置需要重新调度标志
        // schedule()会在trap返回前检查此标志并执行调度
        proc->need_resched = 1;
    }
}

// RR调度类定义：将具体的实现函数与调度框架关联
// 通过函数指针表实现多态，使得调度框架可以无缝切换不同算法
struct sched_class default_sched_class = {
    .name = "RR_scheduler",           // 调度器名称
    .init = RR_init,                  // 初始化函数
    .enqueue = RR_enqueue,            // 进程入队函数
    .dequeue = RR_dequeue,            // 进程出队函数
    .pick_next = RR_pick_next,        // 选择下一个进程函数
    .proc_tick = RR_proc_tick,        // 时间片处理函数
};
