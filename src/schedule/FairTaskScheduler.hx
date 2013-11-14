package schedule;
class FairTaskScheduler implements TaskScheduler {
    private var _allJobs: Array<Runnable>;

    private var _currentJobIndex: Int;

    public function new() {
        _allJobs = [];
        _currentJobIndex = 0;
    }

    public function addJob(job:Runnable):Void {
        if(job != null) {
            _allJobs.push(job);
        }
    }

    public function removeJob(job:Runnable):Void {
        if(job != null) {
            _allJobs.remove(job);
            job.stop();
        }
    }

    public function runJobs(time:Int):Void {
        var startTime: Int = Std.int(haxe.Timer.stamp() * 1000);
        var job: Runnable;
        var oldIndex: Int = _currentJobIndex;
        do {
            job = getJob();
            if(job != null) {
                if(job.percentComplete >= 1) {
                    _currentJobIndex--;
                    removeJob(job);
                } else {
                    job.run();
                }
            }
            var endTime: Int = Std.int(haxe.Timer.stamp() * 1000);
            if(endTime - startTime > time) {
                return;
            }
            if(_currentJobIndex == oldIndex) {
                return;
            }
        } while(job != null);
    }

    private inline function getJob(): Runnable {
        var job: Runnable = null;
        if(_allJobs.length > 0) {
            job = _allJobs[_currentJobIndex];
        }
        _currentJobIndex++;
        if(_currentJobIndex >= _allJobs.length) {
            _currentJobIndex = 0;
        }
        return job;
    }
}
