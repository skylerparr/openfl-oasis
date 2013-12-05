package animation;
import schedule.Runnable;
import haxe.Timer;
class RunnableAnimation implements Animation implements Runnable {
    public var percentComplete(get, null): Float = 0;
    @:isVar
    public var loop(get, set): Bool;
    @:isVar
    public var pingPong(get, set): Bool;
    @:isVar
    public var fps(get, set): Int;
    public var reverse(default, default): Bool;

    public var animationClip(default, set): AnimationClip;

    private var _startTime: Float;
    private var _running: Bool;
    private var _frameTime: Float;

    public function new() {
        loop = true;
        _startTime = 0;
    }

    private function set_animationClip(value:AnimationClip):AnimationClip {
        animationClip = value;
        _running = true;
        return animationClip;
    }

    private function get_loop():Bool {
        return loop;
    }

    private function set_loop(value:Bool):Bool {
        this.loop = value;
        return loop;
    }

    private function set_pingPong(value:Bool):Bool {
        this.pingPong = value;
        return pingPong;
    }

    private function get_pingPong():Bool {
        return pingPong;
    }

    private function get_fps():Int {
        return fps;
    }

    private function set_fps(value:Int):Int {
        this.fps = value;
        _frameTime = 1000 / fps;
        return fps;
    }

    private function get_percentComplete(): Float {
        return percentComplete;
    }

    public function run(): Void {
        if(!_running) {
            return;
        }
        var currentTime: Int = Std.int(Timer.stamp() * 1000);
        if(currentTime - _startTime > _frameTime) {
            _startTime = currentTime;
            if(reverse) {
                animationClip.previousFrame();
            } else {
                animationClip.nextFrame();
            }
            if(animationClip.currentFrame >= animationClip.totalFrames - 1) {
                if(!loop && !reverse) {
                    stop();
                } else if(loop) {
                    if(pingPong) {
                        reverse = !reverse;
                    }
                }
            }
            if(animationClip.currentFrame == 0) {
                if(!loop && reverse) {
                    stop();
                } else if(loop) {
                    if(pingPong) {
                        reverse = !reverse;
                    }
                }
            }
        }
    }

    public function stop(): Void {
        percentComplete = 1;
    }

    public function pause():Void {
        _running = false;
    }

    public function resume():Void {
        _running = true;
        percentComplete = 0;
    }
}
