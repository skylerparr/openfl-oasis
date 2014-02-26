package audio;
interface SoundSettings {
    var volume(get, set): Float;
    var pan(get, set): Float;
    var leftToLeft(get, set): Float;
    var leftToRight(get, set): Float;
    var rightToRight(get, set): Float;
    var rightToLeft(get, set): Float;
    function onVolumeChange(handler: SoundSettings->Void): Void;
}
