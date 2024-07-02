-- msvc test ok
-- xmake f -yc -p windows -a x86 -m debug -k static --runtimes=MDd
-- xmake f -yc -p windows -a x86 -m debug -k shared --runtimes=MDd
-- xmake project -k vsxmake -a x86 -m debug
-- 这个库只在WIN 下面使用 -- 模拟 LINUX 用
-- 参考 cmake 文件修改
--set_allowedarchs("windows|x86","windows|x86_64")

target("yw_pthreads")
    set_kind("$(kind)")
    
    -- add_includedirs(".")
    -- add the header files for installing
    add_headerfiles("pthread.h", {public = true})
    add_headerfiles("_ptw32.h", {public = true})
    add_headerfiles("sched.h", {public = true})
    add_headerfiles("semaphore.h", {public = true})
    -- 如果是 x86 平台，增加宏定义 PTW32_ARCH 为 x32, 否则为 x64
    if is_arch("x86") then
        add_defines("PTW32_ARCHX86")
    else
        add_defines("DPTW32_ARCHAMD64")
    end
    add_defines("HAVE_CONFIG_H")
    add_defines("PTW32_RC_MSC")
    -- remove_files("pthread.c")
    add_files(
        "cleanup.c",
        "create.c",
        "dll.c",
        "errno.c",
        "global.c",
        "pthread_attr_destroy.c",
        "pthread_attr_getaffinity_np.c",
        "pthread_attr_getdetachstate.c",
        "pthread_attr_getinheritsched.c",
        "pthread_attr_getname_np.c",
        "pthread_attr_getschedparam.c",
        "pthread_attr_getschedpolicy.c",
        "pthread_attr_getscope.c",
        "pthread_attr_getstackaddr.c",
        "pthread_attr_getstacksize.c",
        "pthread_attr_init.c",
        "pthread_attr_setaffinity_np.c",
        "pthread_attr_setdetachstate.c",
        "pthread_attr_setinheritsched.c",
        "pthread_attr_setname_np.c",
        "pthread_attr_setschedparam.c",
        "pthread_attr_setschedpolicy.c",
        "pthread_attr_setscope.c",
        "pthread_attr_setstackaddr.c",
        "pthread_attr_setstacksize.c",
        "pthread_barrier_destroy.c",
        "pthread_barrier_init.c",
        "pthread_barrier_wait.c",
        "pthread_barrierattr_destroy.c",
        "pthread_barrierattr_getpshared.c",
        "pthread_barrierattr_init.c",
        "pthread_barrierattr_setpshared.c",
        "pthread_cancel.c",
        "pthread_cond_destroy.c",
        "pthread_cond_init.c",
        "pthread_cond_signal.c",
        "pthread_cond_wait.c",
        "pthread_condattr_destroy.c",
        "pthread_condattr_getpshared.c",
        "pthread_condattr_init.c",
        "pthread_condattr_setpshared.c",
        "pthread_delay_np.c",
        "pthread_detach.c",
        "pthread_equal.c",
        "pthread_exit.c",
        "pthread_getconcurrency.c",
        "pthread_getname_np.c",
        "pthread_getschedparam.c",
        "pthread_getspecific.c",
        "pthread_getunique_np.c",
        "pthread_getw32threadhandle_np.c",
        "pthread_join.c",
        "pthread_key_create.c",
        "pthread_key_delete.c",
        "pthread_kill.c",
        "pthread_mutex_consistent.c",
        "pthread_mutex_destroy.c",
        "pthread_mutex_init.c",
        "pthread_mutex_lock.c",
        "pthread_mutex_timedlock.c",
        "pthread_mutex_trylock.c",
        "pthread_mutex_unlock.c",
        "pthread_mutexattr_destroy.c",
        "pthread_mutexattr_getkind_np.c",
        "pthread_mutexattr_getpshared.c",
        "pthread_mutexattr_getrobust.c",
        "pthread_mutexattr_gettype.c",
        "pthread_mutexattr_init.c",
        "pthread_mutexattr_setkind_np.c",
        "pthread_mutexattr_setpshared.c",
        "pthread_mutexattr_setrobust.c",
        "pthread_mutexattr_settype.c",
        "pthread_num_processors_np.c",
        "pthread_once.c",
        "pthread_rwlock_destroy.c",
        "pthread_rwlock_init.c",
        "pthread_rwlock_rdlock.c",
        "pthread_rwlock_timedrdlock.c",
        "pthread_rwlock_timedwrlock.c",
        "pthread_rwlock_tryrdlock.c",
        "pthread_rwlock_trywrlock.c",
        "pthread_rwlock_unlock.c",
        "pthread_rwlock_wrlock.c",
        "pthread_rwlockattr_destroy.c",
        "pthread_rwlockattr_getpshared.c",
        "pthread_rwlockattr_init.c",
        "pthread_rwlockattr_setpshared.c",
        "pthread_self.c",
        "pthread_setaffinity.c",
        "pthread_setcancelstate.c",
        "pthread_setcanceltype.c",
        "pthread_setconcurrency.c",
        "pthread_setname_np.c",
        "pthread_setschedparam.c",
        "pthread_setspecific.c",
        "pthread_spin_destroy.c",
        "pthread_spin_init.c",
        "pthread_spin_lock.c",
        "pthread_spin_trylock.c",
        "pthread_spin_unlock.c",
        "pthread_testcancel.c",
        "pthread_timechange_handler_np.c",
        "pthread_timedjoin_np.c",
        "pthread_tryjoin_np.c",
        "pthread_win32_attach_detach_np.c",
        
        "ptw32_calloc.c",
        "ptw32_callUserDestroyRoutines.c",
        "ptw32_cond_check_need_init.c",
        "ptw32_getprocessors.c",
        "ptw32_is_attr.c",
        "ptw32_MCS_lock.c",
        "ptw32_mutex_check_need_init.c",
        "ptw32_new.c",
        "ptw32_processInitialize.c",
        "ptw32_processTerminate.c",
        "ptw32_relmillisecs.c",
        "ptw32_reuse.c",
        "ptw32_rwlock_cancelwrwait.c",
        "ptw32_rwlock_check_need_init.c",
        "ptw32_semwait.c",
        "ptw32_spinlock_check_need_init.c",
        "ptw32_strdup.c",
        "ptw32_threadDestroy.c",
        "ptw32_threadStart.c",
        "ptw32_throw.c",
        "ptw32_timespec.c",
        "ptw32_tkAssocCreate.c",
        "ptw32_tkAssocDestroy.c",
        "sched_get_priority_max.c",
        "sched_get_priority_min.c",
        "sched_getscheduler.c",
        "sched_setaffinity.c",
        "sched_setscheduler.c",
        "sched_yield.c",
        "sem_close.c",
        "sem_destroy.c",
        "sem_getvalue.c",
        "sem_init.c",
        "sem_open.c",
        "sem_post_multiple.c",
        "sem_post.c",
        "sem_timedwait.c",
        "sem_trywait.c",
        "sem_unlink.c",
        "sem_wait.c",
        "signal.c",
        "w32_CancelableWait.c"
    )

    -- 如果是动态库，增加宏定义 PTW32_BUILD, 否则为 PTW32_STATIC_LIB
    if is_kind("shared") then
        --add_defines("PTW32_BUILD")
        add_rules("utils.symbols.export_all")
        -- 把 PTHREAD_SHARED_SOURCES 一组文件加入到编译中
        

    else
        add_defines("PTW32_STATIC_LIB")
        

    end
    add_defines("PTW32_RC_MSC")
    add_defines("HAVE_PTW32_CONFIG_H")
    add_defines("_TIMESPEC_DEFINED")


-- 把 test_package 做 test app
target("test_package")
    set_kind("binary")
    add_files("test_package/*.cpp")
    add_includedirs(".")
    add_deps("yw_pthreads")





