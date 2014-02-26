package audio;
import flash.events.IOErrorEvent;
import flash.net.URLRequest;
import flash.media.Sound;
import openfl.Assets;
class LayeredSoundManager implements SoundManager {

    public var allSoundLayers(get, null): Array<SoundLayer>;
    @:isVar
    public var masterVolume(get, set): Float;

    private var _soundMap: Map<String, MappedSound>;
    private var _layerMap: Map<String, SoundLayer>;

    public function new() {
        _soundMap = new Map<String, MappedSound>();
        _layerMap = new Map<String, SoundLayer>();
        masterVolume = 1;
    }

    private function get_allSoundLayers():Array<SoundLayer> {
        var retVal: Array<SoundLayer> = [];
        for(layer in _layerMap) {
            retVal.push(layer);
        }
        return retVal;
    }

    public function set_masterVolume(value:Float): Float {
        this.masterVolume = value;
        for(layer in _layerMap) {
            layer.volume = value;
        }
        return this.masterVolume;
    }

    public function get_masterVolume():Float {
        return masterVolume;
    }

    public function mapSound(name: String, url: String, layer: String): Void {
        _soundMap.set(name, {name: name, url: url, sound: null, layer: layer});
    }

    public function addSoundLayer(name: String): Void {
        var soundLayer: SoundLayer = createSoundLayer(name);
        _layerMap.set(name, soundLayer);
    }

    public function removeSoundLayer(name: String): Void {
        var soundLayer: SoundLayer = _layerMap.get(name);
        if(soundLayer != null) {
            soundLayer.stopAllSounds();
            _layerMap.remove(name);
        }
    }

    public function getSound(name:String):SoundHandle {
        return createSoundHandle(name);
    }

    public function getSoundLayerByName(name:String):SoundLayer {
        return _layerMap.get(name);
    }

    public function stopAllSounds():Void {
        for(layer in _layerMap) {
            layer.stopAllSounds();
        }
    }

    public function createSoundLayer(value: String): SoundLayer {
        var retVal: SingleSoundLayer = new SingleSoundLayer(this);
        retVal.name = value;
        return retVal;
    }

    public function createSoundHandle(name: String): SoundHandle {
        var mappedSound: MappedSound = _soundMap.get(name);
        if(mappedSound == null) {
            return null;
        }
        #if flash
        var sound: Sound = new Sound();
        sound.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
        var req: URLRequest = new URLRequest(mappedSound.url);
        sound.load(req);
        #else
        var sound: Sound = Assets.getSound(mappedSound.url);
        #end
        if(sound == null) {
            return null;
        }
        mappedSound.sound = sound;
        var layer: SoundLayer = _layerMap.get(mappedSound.layer);
        if(layer == null) {
            return null;
        }
        var handle: SoundHandleImpl = new SoundHandleImpl(sound, layer);
        layer.addSoundHandle(handle);
        layer.volume = layer.volume;
        return handle;
    }

    private function onIOError(e: IOErrorEvent): Void {
        trace(e.text);
    }
}

typedef MappedSound = {
    name: String,
    sound: Sound,
    url: String,
    layer: String
}