package animation;
import schedule.Runnable;
interface Animation {
    var loop(get, set): Bool;
    var pingPong(get, set): Bool;
    var fps(get, set): Int;
    var reverse(default, default): Bool;

    function pause(): Void;
    function resume(): Void;
}
