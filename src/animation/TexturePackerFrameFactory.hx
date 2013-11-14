package animation;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

class TexturePackerFrameFactory implements FrameFactory {
    private static var p: Point = new Point();
    private static var rect: Rectangle = new Rectangle();

    private var _nameSourceDefMap: Map<String, NameSourceDef>;
    private var _frameMappingMap: Map<String, Array<FrameMapping>>;

    public function new() {
        _nameSourceDefMap = new Map<String, NameSourceDef>();
        _frameMappingMap = new Map<String, Array<FrameMapping>>();
    }

    public function define(name: String, sourceImage: BitmapData, frameDef: Dynamic): Void {
        if(_nameSourceDefMap.exists(name)) {
            return;
        }
        var frames: Array<Dynamic> = frameDef.frames;
        _nameSourceDefMap.set(name, {name: name, sourceImage: sourceImage, frameDefs: frames, numFrames: frames.length});
        var mapping: Array<FrameMapping> = [];
        for(frameGroup in frames) {
            mapping.push({bitmap: null, x: frameGroup.spriteSourceSize.x, y: frameGroup.spriteSourceSize.y});
        }
        _frameMappingMap.set(name, mapping);
    }

    public function destroy(name: String): Void {
        var mapping: Array<FrameMapping> = _frameMappingMap.get(name);
        for(map in mapping) {
            map.bitmap.dispose();
        }
        _frameMappingMap.remove(name);
    }

    public inline function getFrame(name:String, frameNumber:Int):FrameMapping {
        var mapping: Array<FrameMapping> = _frameMappingMap.get(name);
        var index: Int = frameNumber % mapping.length;
        var frameMap: FrameMapping = mapping[index];
        if(frameMap.bitmap == null) {
            var nameSourceDef: NameSourceDef = _nameSourceDefMap.get(name);
            var frameGroup: Dynamic = nameSourceDef.frameDefs[index];
            var frame: Dynamic = frameGroup.frame;
            var bitmapData: BitmapData = new BitmapData(frame.w, frame.h, true, 0);
            rect.x = frame.x;
            rect.y = frame.y;
            rect.width = frame.w;
            rect.height = frame.h;
            bitmapData.copyPixels(nameSourceDef.sourceImage, rect, p);
            frameMap.bitmap = bitmapData;
        }
        return frameMap;
    }

    public function getNumberOfFrames(name:String):Int {
        var nameSourceDef: NameSourceDef = _nameSourceDefMap.get(name);
        if(nameSourceDef == null) {
            return -1;
        }
        return nameSourceDef.numFrames;
    }
}

typedef NameSourceDef = {
    name: String,
    sourceImage: BitmapData,
    frameDefs: Array<Dynamic>,
    numFrames: Int
}