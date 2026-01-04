#include <defs.h>
#include <list.h>
#include <proc.h>
#include <assert.h>
#include <default_sched.h>

/**
 * FIFO（First In First Out，先来先服务）调度算法实现
 * 
 * 算法原理：
 * - 按照进程到达运行队列的顺序进行调度
 * - 先到达的进程先执行，后到达的进程排队等待
 * - 非抢占式：每个进程分配非常大的时间片，基本运行到完成或主动放弃CPU
 * - 最简单的调度算法，但可能导致短进程等待时间过长（护航效应）
 * 
 * 【核心】与RR算法的本质区别：
 * ==========================================
 * | 特性         | FIFO              | RR           |
 * |-------------|-------------------|--------------|
 * | 时间片大小   | 超大(500 ticks)   | 小(5 ticks)  |
 * | 切换频率     | 极低              | 高           |
 * | 进程行为     | 基本运行到完成     | 频繁轮转     |
 * | 护航效应     | 严重              | 轻微         |
 * ==========================================
 * 
 * 举例说明护航效应：
 * - 假设P1需要100ms，P2需要1ms，P3需要1ms
 * - FIFO: P1先运行100ms → P2运行1ms → P3运行1ms
 *   平均等待时间 = (0 + 100 + 101) / 3 = 67ms
 * - RR(时间片5ms): P1→P2→P3→P1→P2→P3... 交替执行
 *   平均等待时间更短，响应更快
 * 
 * 数据结构：使用链表（list_entry_t）维护运行队列
 * 时间复杂度：入队O(1)、出队O(1)、选择下一个进程O(1)
 */

/*
 * FIFO_init - 初始化FIFO运行队列
 * 
 * @rq: 运行队列指针
 * 
 * 初始化内容：
 * - run_list: 双向循环链表，存储就绪进程
 * - proc_num: 队列中进程数量，初始为0
 */
static void
FIFO_init(struct run_queue *rq)
{
    // 初始化运行队列为空链表
    list_init(&(rq->run_list));
    // 进程数量初始为0
    rq->proc_num = 0;
}

/*
 * FIFO_enqueue - 将进程加入FIFO队列尾部
 * 
 * @rq: 运行队列指针
 * @proc: 要加入队列的进程
 * 
 * 操作步骤：
 * 1. 验证进程未在其他队列中
 * 2. 插入到队列尾部（保证FIFO顺序）
 * 3. 设置进程的时间片（FIFO给予较大时间片）
 * 4. 更新队列元数据
 */
static void
FIFO_enqueue(struct run_queue *rq, struct proc_struct *proc)
{
    // 断言：确保进程的run_link是空的（未在其他队列中）
    assert(list_empty(&(proc->run_link)));
    
    // 将进程插入到队列尾部（FIFO：先进先出）
    // list_add_before 在 run_list 前插入，即队列尾部
    list_add_before(&(rq->run_list), &(proc->run_link));
    
    // FIFO特点：给予非常大的时间片，让进程尽可能运行完
    // 与RR的关键区别：FIFO时间片远大于RR（模拟非抢占式）
    if (proc->time_slice == 0 || proc->time_slice > rq->max_time_slice) {
        // FIFO给予超大时间片（100倍于RR），模拟"运行到完成"
        proc->time_slice = rq->max_time_slice * 100;  // RR是5，FIFO是500
    }
    
    // 设置进程所属的运行队列
    proc->rq = rq;
    
    // 增加队列中的进程数量
    rq->proc_num++;
}

/*
 * FIFO_dequeue - 从FIFO队列中移除进程
 * 
 * @rq: 运行队列指针
 * @proc: 要移除的进程
 * 
 * 注意：FIFO是非抢占的，通常只有进程自己完成或阻塞时才出队
 */
static void
FIFO_dequeue(struct run_queue *rq, struct proc_struct *proc)
{
    // 断言：确保进程确实在队列中，且属于该运行队列
    assert(!list_empty(&(proc->run_link)) && proc->rq == rq);
    
    // 从运行队列中删除进程
    // list_del_init 删除节点并重新初始化为空链表
    list_del_init(&(proc->run_link));
    
    // 减少运行队列中的进程数量
    rq->proc_num--;
}

/*
 * FIFO_pick_next - 选择下一个要运行的进程
 * 
 * @rq: 运行队列指针
 * @return: 下一个要运行的进程指针，队列为空则返回NULL
 * 
 * FIFO策略：总是选择队列头部的进程（最先到达的进程）
 */
static struct proc_struct *
FIFO_pick_next(struct run_queue *rq)
{
    // 获取队列的第一个元素（队首）
    // run_list 是头节点，list_next 返回第一个实际进程节点
    list_entry_t *le = list_next(&(rq->run_list));
    
    // 如果队列不为空
    if (le != &(rq->run_list)) {
        // le2proc宏：将list_entry转换为包含它的proc_struct指针
        // 返回队首进程（最先到达的进程）
        return le2proc(le, run_link);
    }
    
    // 队列为空，返回NULL
    return NULL;
}

/*
 * FIFO_proc_tick - 处理时钟中断事件
 * 
 * @rq: 运行队列指针
 * @proc: 当前运行的进程
 * 
 * FIFO特点：
 * - 通常不基于时间片抢占（或时间片很大）
 * - 进程主动放弃CPU或完成时才切换
 * - 这里仍然实现时间片机制，但时间片较大
 */
static void
FIFO_proc_tick(struct run_queue *rq, struct proc_struct *proc)
{
    // 每个时钟中断时被调用
    
    if (proc->time_slice > 0) {
        // 时间片递减
        proc->time_slice--;
    }
    
    // FIFO通常不频繁切换，但为了系统响应性，
    // 时间片耗尽时仍然触发调度
    if (proc->time_slice == 0) {
        // 时间片用完，设置需要重新调度标志
        // 进程会被重新加入队列尾部，让其他进程运行
        proc->need_resched = 1;
    }
}

// FIFO调度类定义：通过函数指针表实现调度框架的多态
// 可以通过修改 sched_init() 中的一行代码切换到FIFO算法
struct sched_class fifo_sched_class = {
    .name = "FIFO_scheduler",           // 调度器名称
    .init = FIFO_init,                  // 初始化函数
    .enqueue = FIFO_enqueue,            // 进程入队函数
    .dequeue = FIFO_dequeue,            // 进程出队函数
    .pick_next = FIFO_pick_next,        // 选择下一个进程函数
    .proc_tick = FIFO_proc_tick,        // 时间片处理函数
};
