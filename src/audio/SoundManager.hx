package audio;
interface SoundManager {
    var allSoundLayers(get, null): Array<SoundLayer>;
    var masterVolume(get, set): Float;
    function getSound(name: String): SoundHandle;
    function getSoundLayerByName(name: String): SoundLayer;
    function stopAllSounds(): Void;
}
