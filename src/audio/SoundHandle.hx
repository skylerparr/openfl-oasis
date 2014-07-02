package audio;
interface SoundHandle extends SoundSettings {
    var length(get, null): Float;
    var position(get, null): Float;
    var leftPeak(get, null): Float;
    var rightPeak(get, null): Float;
    function dispose(): Void;
    function play(startTime:Float = 0, loops:Int = 0): Void;
    function stop(): Void;
    function pause(): Void;
    function resume(): Void;
    function onComplete(handler: Void->Void): Void;
}
