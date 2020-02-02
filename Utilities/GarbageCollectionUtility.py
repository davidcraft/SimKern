import psutil
import numpy
import gc


class GarbageCollectionUtility(object):

    @staticmethod
    def logMemoryUsageAndGarbageCollect(log):
        processes = psutil.Process()
        procs = [processes] + processes.children(recursive=True)
        for process in procs:
            rss = process.memory_info().rss
            memory_usage_mb = numpy.round(rss / 1e6, 2)
            log.debug("Memory usage for PID %s: %s: MB", process.pid, memory_usage_mb)
        gc.collect()
