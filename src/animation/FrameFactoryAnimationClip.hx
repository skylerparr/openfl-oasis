package animation;
import flash.display.Bitmap;

class FrameFactoryAnimationClip implements AnimationClip {

    public var totalFrames(get, null): Int;
    public var currentFrame(get, null): Int;

    private var _bitmap: Bitmap;
    private var _frameFactory: FrameFactory;
    private var _animationName: String;

    private var _onStartAnimation: Void->Void;
    private var _onEndAnimation: Void->Void;
    private var _onFrame: Void->Void;

    public function new() {
    }

    public function setup(bitmap: Bitmap, frameFactory: FrameFactory, animationName: String): Void {
        _bitmap = bitmap;
        _frameFactory = frameFactory;
        _animationName = animationName;
        currentFrame = -1;

        totalFrames = _frameFactory.getNumberOfFrames(_animationName);
    }

    private function get_totalFrames():Int {
        return totalFrames;
    }

    private function get_currentFrame():Int {
        return currentFrame;
    }

    private inline function formatFrame(frameMapping:FrameMapping):Void {
        _bitmap.bitmapData = frameMapping.bitmap;
        _bitmap.x = frameMapping.x;
        _bitmap.y = frameMapping.y;
    }

    private inline function notifyCallbacks(): Void {
        if(_onStartAnimation != null) {
            if(currentFrame == 0) {
                _onStartAnimation();
            }
        }
        if(_onEndAnimation != null) {
            if(currentFrame == totalFrames - 1) {
                _onEndAnimation();
            }
        }
        if(_onFrame != null) {
            _onFrame();
        }
    }

    public function nextFrame():Void {
        ++currentFrame;
        if(currentFrame >= totalFrames) {
            currentFrame = 0;
        }
        var frameMapping: FrameMapping = _frameFactory.getFrame(_animationName, currentFrame);
        formatFrame(frameMapping);
        notifyCallbacks();
    }

    public function previousFrame():Void {
        --currentFrame;
        if(currentFrame < 0) {
            currentFrame = totalFrames - 1;
        }
        var frameMapping: FrameMapping = _frameFactory.getFrame(_animationName, currentFrame);
        formatFrame(frameMapping);
        notifyCallbacks();
    }

    public function goToFrame(frameNum:Int):Void {
        currentFrame = frameNum;
        if(currentFrame < 0) {
            currentFrame = totalFrames - 1;
        }
        if(currentFrame >= totalFrames) {
            currentFrame = 0;
        }
        var frameMapping: FrameMapping = _frameFactory.getFrame(_animationName, currentFrame);
        formatFrame(frameMapping);
        notifyCallbacks();
    }

    public function onStartAnimation(callback:Void -> Void):Void {
        _onStartAnimation = callback;
    }

    public function onEndAnimation(callback:Void -> Void):Void {
        _onEndAnimation = callback;
    }

    public function onFrame(callback:Void -> Void):Void {
        _onFrame = callback;
    }
}
