package audio;
import flash.events.Event;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.media.Sound;
class SoundHandleImpl implements SoundHandle {
    @:isVar
    public var length(get, null): Float;
    @:isVar
    public var position(get, null): Float;
    @:isVar
    public var leftPeak(get, null): Float;
    @:isVar
    public var rightPeak(get, null): Float;
    @:isVar
    public var volume(get, set): Float;
    @:isVar
    public var pan(get, set): Float;
    @:isVar
    public var leftToLeft(get, set): Float;
    @:isVar
    public var leftToRight(get, set): Float;
    @:isVar
    public var rightToRight(get, set): Float;
    @:isVar
    public var rightToLeft(get, set): Float;

    public var name: String;

    private var _sound: Sound;
    private var _soundLayer: SoundLayer;
    private var _soundChannel: SoundChannel;
    private var _onCompleteHandler: Void->Void;

    private var _pausedPosition: Float;
    private var _loopCount: Int;
    private var _volumeChangeHandler: SoundSettings->Void;
    private var _isPlaying: Bool;

    public function new(sound: Sound, soundLayer: SoundLayer) {
        _sound = sound;
        _soundLayer = soundLayer;
        pan = 0;
        leftToLeft = 1;
        leftToRight = 1;
        rightToRight = 1;
        rightToLeft = 1;
    }

    public function dispose(): Void {
        stop();
        if(_soundLayer != null) {
            _soundLayer.removeSoundHandle(this);
            _soundLayer = null;
        }
        _sound = null;

        _soundChannel = null;
        _onCompleteHandler = null;
        _volumeChangeHandler = null;
    }

    public function get_length():Float {
        return _sound.length;
    }

    public function get_position():Float {
        if(_soundChannel == null) {
            return 0;
        }
        return _soundChannel.position;
    }

    public function get_leftPeak():Float {
        if(_soundChannel == null) {
            return 0;
        }
        return _soundChannel.leftPeak;
    }

    public function get_rightPeak():Float {
        if(_soundChannel == null) {
            return 0;
        }
        return _soundChannel.rightPeak;
    }

    public function get_volume():Float {
        return volume;
    }

    public function set_volume(value:Float):Float {
        this.volume = value;
        if(volume <= 0) {
            volume = 0;
            if(_volumeChangeHandler != null) {
                _volumeChangeHandler(this);
            }
            stop();
            return volume;
        }
        if(volume > _soundLayer.volume) {
            volume = _soundLayer.volume;
        }
        if(_soundChannel != null) {
            var soundTransform: SoundTransform = _soundChannel.soundTransform;
            soundTransform.volume = volume;
            _soundChannel.soundTransform = soundTransform;
        }
        if(_volumeChangeHandler != null) {
            _volumeChangeHandler(this);
        }
        return volume;
    }

    public function get_pan():Float {
        return pan;
    }

    public function set_pan(value:Float):Float {
        this.pan = value;
        if(_soundChannel != null) {
            var soundTransform: SoundTransform = _soundChannel.soundTransform;
            soundTransform.pan = pan;
            _soundChannel.soundTransform = soundTransform;
        }
        return pan;
    }

    public function set_leftToLeft(value:Float):Float {
        this.leftToLeft = value;
        if(_soundChannel != null) {
            var soundTransform: SoundTransform = _soundChannel.soundTransform;
            #if flash
            soundTransform.leftToLeft = leftToLeft;
            _soundChannel.soundTransform = soundTransform;
            #end
        }
        return leftToLeft;
    }

    public function get_leftToLeft():Float {
        return leftToLeft;
    }

    public function set_leftToRight(value:Float):Float {
        this.leftToRight = value;
        if(_soundChannel != null) {
            var soundTransform: SoundTransform = _soundChannel.soundTransform;
            #if flash
            soundTransform.leftToRight = leftToRight;
            _soundChannel.soundTransform = soundTransform;
            #end
        }
        return leftToRight;
    }

    public function get_leftToRight():Float {
        return leftToRight;
    }

    public function set_rightToRight(value:Float):Float {
        this.rightToRight = value;
        if(_soundChannel != null) {
            var soundTransform: SoundTransform = _soundChannel.soundTransform;
            #if flash
            soundTransform.rightToRight = rightToRight;
            _soundChannel.soundTransform = soundTransform;
            #end
        }
        return rightToRight;
    }

    public function get_rightToRight():Float {
        return rightToRight;
    }

    public function set_rightToLeft(value:Float):Float {
        this.rightToLeft = value;
        if(_soundChannel != null) {
            var soundTransform: SoundTransform = _soundChannel.soundTransform;
            #if flash
            soundTransform.rightToLeft = rightToLeft;
            _soundChannel.soundTransform = soundTransform;
            #end
        }
        return rightToLeft;
    }

    public function get_rightToLeft():Float {
        return rightToLeft;
    }

    public function play(startTime:Float = 0, loops:Int = 1):Void {
        if(_isPlaying) {
            return;
        }
        var tmpVolumeHandler: SoundSettings->Void = _volumeChangeHandler;
        _volumeChangeHandler = null;
        volume = _soundLayer.volume;
        if(volume == 0) {
            return;
        }
        _loopCount = loops;
        try {
            _soundChannel = _sound.play(startTime, 0);
        } catch (e: Dynamic) {
            trace(e);
        }
        if(_soundChannel == null) {
            return;
        }
        _isPlaying = true;
        _soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
        var soundTransform: SoundTransform = _soundChannel.soundTransform;
        soundTransform.volume = volume;
        soundTransform.pan = pan;
        #if flash
        soundTransform.leftToLeft = leftToLeft;
        soundTransform.leftToRight = leftToRight;
        soundTransform.rightToRight = rightToRight;
        soundTransform.rightToLeft = rightToLeft;
        #end
        _soundChannel.soundTransform = soundTransform;
        _volumeChangeHandler = tmpVolumeHandler;
    }

    public function stop():Void {
        if(_soundChannel != null) {
            _soundChannel.stop();
            _soundChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
            _soundChannel = null;
        }
        _isPlaying = false;
    }

    private function onSoundComplete(e: Event):Void {
        _loopCount--;
        stop();
        if(_loopCount != 0) {
            play(0, _loopCount);
        }
        if(_onCompleteHandler != null) {
            _onCompleteHandler();
        }
    }

    public function pause():Void {
        if(_isPlaying && _soundChannel != null) {
            _isPlaying = false;
            _soundChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
            _pausedPosition = position;
            _soundChannel.stop();
        }
    }

    public function resume():Void {
        if(!_isPlaying && _sound != null) {
            play(_pausedPosition, _loopCount);
        }
    }

    public function onComplete(handler:Void -> Void):Void {
        _onCompleteHandler = handler;
    }

    public function onVolumeChange(handler:SoundSettings -> Void) {
        _volumeChangeHandler = handler;
    }
}
