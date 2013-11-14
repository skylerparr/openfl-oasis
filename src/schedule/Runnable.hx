package schedule;
interface Runnable {
    /**
    * Reports how much of the task has completed.  If the percent complete is returned as 1, then the task
    * has finished and will be removed from the scheduler.
    *
    * @return
    */
    var percentComplete(get, null): Float;

    /**
    * Tells the runnable that they may be run.  The run method could potentially hog the thread.  So keep the
    * run call lightweight and able to do jobs over a series of calls.
    */
    function run(): Void;

    /**
    * called when the job is removed from the scheduler.
    */
    function stop(): Void;
}
