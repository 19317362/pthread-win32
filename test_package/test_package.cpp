#include "pthread.h"
#include "sched.h"
#include "semaphore.h"

#include <windows.h>
#include <stdio.h>

#define PTW32_THREAD_NULL_ID {NULL,0}

/*
 * Some non-thread POSIX API substitutes
 */
#define rand_r( _seed ) \
        ( _seed == _seed? rand() : rand() )

#if defined(__MINGW32__)
#include <stdint.h>
#elif defined(__BORLANDC__)
#define int64_t ULONGLONG
#else
#define int64_t _int64
#endif

#if defined(_MSC_VER) && _MSC_VER >= 1400
#  define PTW32_FTIME(x) _ftime64_s(x)
#  define PTW32_STRUCT_TIMEB struct __timeb64
#elif ( defined(_MSC_VER) && _MSC_VER >= 1300 ) || \
      ( defined(__MINGW32__) && __MSVCRT_VERSION__ >= 0x0601 )
#  define PTW32_FTIME(x) _ftime64(x)
#  define PTW32_STRUCT_TIMEB struct __timeb64
#else
#  define PTW32_FTIME(x) _ftime(x)
#  define PTW32_STRUCT_TIMEB struct _timeb
#endif


const char * error_string[] = {
  "ZERO_or_EOK",
  "EPERM",
  "ENOFILE_or_ENOENT",
  "ESRCH",
  "EINTR",
  "EIO",
  "ENXIO",
  "E2BIG",
  "ENOEXEC",
  "EBADF",
  "ECHILD",
  "EAGAIN",
  "ENOMEM",
  "EACCES",
  "EFAULT",
  "UNKNOWN_15",
  "EBUSY",
  "EEXIST",
  "EXDEV",
  "ENODEV",
  "ENOTDIR",
  "EISDIR",
  "EINVAL",
  "ENFILE",
  "EMFILE",
  "ENOTTY",
  "UNKNOWN_26",
  "EFBIG",
  "ENOSPC",
  "ESPIPE",
  "EROFS",
  "EMLINK",
  "EPIPE",
  "EDOM",
  "ERANGE",
  "UNKNOWN_35",
  "EDEADLOCK_or_EDEADLK",
  "UNKNOWN_37",
  "ENAMETOOLONG",
  "ENOLCK",
  "ENOSYS",
  "ENOTEMPTY",
  "EILSEQ",
  "EOWNERDEAD",
  "ENOTRECOVERABLE"
};

/*
 * The Mingw32 assert macro calls the CRTDLL _assert function
 * which pops up a dialog. We want to run in batch mode so
 * we define our own assert macro.
 */
#ifdef assert
# undef assert
#endif

#ifndef ASSERT_TRACE
# define ASSERT_TRACE 0
#else
# undef ASSERT_TRACE
# define ASSERT_TRACE 1
#endif

# define assert(e) \
   ((e) ? ((ASSERT_TRACE) ? fprintf(stderr, \
                                    "Assertion succeeded: (%s), file %s, line %d\n", \
			            #e, __FILE__, (int) __LINE__), \
	                            fflush(stderr) : \
                             0) : \
          (fprintf(stderr, "Assertion failed: (%s), file %s, line %d\n", \
                   #e, __FILE__, (int) __LINE__), exit(1), 0))

int assertE;
# define assert_e(e, o, r) \
   (((assertE = e) o (r)) ? ((ASSERT_TRACE) ? fprintf(stderr, \
                                    "Assertion succeeded: (%s), file %s, line %d\n", \
			            #e, __FILE__, (int) __LINE__), \
	                            fflush(stderr) : \
                             0) : \
          (fprintf(stderr, "Assertion failed: (%s %s %s), file %s, line %d, error %s\n", \
                   #e,#o,#r, __FILE__, (int) __LINE__, error_string[assertE]), exit(1), 0))



enum {
	NUMTHREADS = 100
};

static int washere = 0;

void * func(void * arg)
{
  washere = 1;
  return arg; 
}
 
int main(void)
{
  pthread_t t,
            last_t;
  pthread_attr_t attr;
  void * result = NULL;
  int i;

  assert(pthread_attr_init(&attr) == 0);;
  assert(pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE) == 0);

  washere = 0;
  assert(pthread_create(&t, &attr, func, NULL) == 0);
  assert(pthread_join(t, &result) == 0);;
  assert((int)(size_t)result == 0);
  assert(washere == 1);
  last_t = t;

  for (i = 1; i < NUMTHREADS; i++)
    {
      washere = 0;
      assert(pthread_create(&t, &attr, func, (void *)(size_t)i) == 0);
      pthread_join(t, &result);
      assert((int)(size_t) result == i);
      assert(washere == 1);
      /* thread IDs should be unique */
      assert(!pthread_equal(t, last_t));
      /* thread struct pointers should be the same */
      assert(t.p == last_t.p);
      /* thread handle reuse counter should be different by one */
      assert(t.x == last_t.x+1);
      last_t = t;
    }
  printf("%s %d\n", __func__,__LINE__);
  return 0;
}
