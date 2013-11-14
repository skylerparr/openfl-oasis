package animation;
import flash.display.BitmapData;
interface FrameFactory {
    function getFrame(name: String, frameNumber: Int): FrameMapping;
    function getNumberOfFrames(name: String): Int;
}
