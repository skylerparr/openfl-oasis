package audio;
import flash.events.EventDispatcher;
class SingleSoundLayer implements SoundLayer {
    @:isVar
    public var name(get, set): String;
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

    private var _allSounds: List<SoundHandle>;
    private var _soundManager: SoundManager;
    private var _volumeChangeHandler: SoundSettings->Void;

    public function new(soundManager: SoundManager) {
        _soundManager = soundManager;
        _allSounds = new List<SoundHandle>();
    }

    public function get_name():String {
        return name;
    }

    public function set_name(value:String):String {
        this.name = value;
        return name;
    }

    public function get_volume():Float {
        return volume;
    }

    public function set_volume(value:Float):Float {
        this.volume = value;
        if(volume < 0) {
            volume = 0;
        }
        if(volume > _soundManager.masterVolume) {
            volume = _soundManager.masterVolume;
        }
        for(soundHandle in _allSounds) {
            soundHandle.volume = volume;
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
        for(soundHandle in _allSounds) {
            soundHandle.pan = pan;
        }
        return pan;
    }

    public function set_leftToLeft(value:Float):Float {
        this.leftToLeft = value;
        for(soundHandle in _allSounds) {
            soundHandle.leftToLeft = leftToLeft;
        }
        return leftToLeft;
    }

    public function get_leftToLeft():Float {
        return leftToLeft;
    }

    public function set_leftToRight(value:Float):Float {
        this.leftToRight = value;
        for(soundHandle in _allSounds) {
            soundHandle.leftToRight = leftToRight;
        }
        return leftToRight;
    }

    public function get_leftToRight():Float {
        return leftToRight;
    }

    public function set_rightToRight(value:Float):Float {
        this.rightToRight = value;
        for(soundHandle in _allSounds) {
            soundHandle.rightToRight = rightToRight;
        }
        return rightToRight;
    }

    public function get_rightToRight():Float {
        return rightToRight;
    }

    public function set_rightToLeft(value:Float):Float {
        this.rightToLeft = value;
        for(soundHandle in _allSounds) {
            soundHandle.rightToLeft = rightToLeft;
        }
        return rightToLeft;
    }

    public function get_rightToLeft():Float {
        return rightToLeft;
    }

    public function stopAllSounds():Void {
        for(soundHandle in _allSounds) {
            soundHandle.stop();
        }
    }

    public function addSoundHandle(value:SoundHandle):Void {
        _allSounds.push(value);
        value.volume = volume;
    }

    public function removeSoundHandle(value:SoundHandle):Void {
        _allSounds.remove(value);
    }

    public function onVolumeChange(handler:SoundSettings -> Void) {
        _volumeChangeHandler = handler;
    }
}
