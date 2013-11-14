package schedule;
interface TaskScheduler {
    /**
    * Schedules a job.
    *
    * @param job
    */
    function addJob(job: Runnable): Void;

    /**
    * Removes the job from the scheduler.  In order to be rescheduled addJob must be called again.
    *
    * @param job
    */
    function removeJob(job: Runnable): Void;

    /**
    * notifies the scheduler to run jobs and the time passed to it is the amount of time in milliseconds
    * the scheduler has to run as many jobs as possible.  The task scheduler could potentially finish before
    * the allotted time.
    *
    * @param time
    */
    function runJobs(time: Int): Void;
}
