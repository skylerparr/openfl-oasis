package audio;
interface SoundLayer extends SoundSettings {
    var name(get, null): String;
    function stopAllSounds(): Void;
    function addSoundHandle(value: SoundHandle): Void;
    function removeSoundHandle(value: SoundHandle): Void;
}
