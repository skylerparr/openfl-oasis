package animation;
interface AnimationClip {
    var totalFrames(get, null): Int;
    var currentFrame(get, null): Int;

    function nextFrame(): Void;
    function previousFrame(): Void;
    function goToFrame(frameNum: Int): Void;
    function onStartAnimation(callback: Void->Void): Void;
    function onEndAnimation(callback: Void->Void): Void;
    function onFrame(callback: Void->Void): Void;
}
