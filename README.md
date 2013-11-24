openfl-oasis
============

Advanced 2D Sprite animation system for flash or openfl

What are the advantages of openfl-oasis?
 - It's interface driven (that means it's meant to be extendable)
 - It's super memory efficient. Only holds one reference to any given bitmap data
 - It's built on top of fair scheduling, which means it plays well with heavy load
 - Because it's built on top of scheduling you could implement your own scheduler and use threading
 - Works with texture packer

Sample setup:

    package;
    
    
    import schedule.FairTaskScheduler;
    import schedule.TaskScheduler;
    import animation.RunnableAnimation;
    import animation.FrameFactoryAnimationClip;
    import animation.TexturePackerFrameFactory;
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import haxe.Timer;
    import haxe.Json;
    import openfl.Assets;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    
    class Main extends Sprite {
    
        private var _taskScheduler: TaskScheduler;
    
        public function new() {
            super();
    
            //create a scheduler to manager the frames
            _taskScheduler = new FairTaskScheduler();
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
    
            //texture packer data
            var frameData: Dynamic = Json.parse(Assets.getText("assets/Lazlo_Walk_Side.json"));
            //source bitmap data
            var srcBd: BitmapData = Assets.getBitmapData("assets/Lazlo_Walk_Side.png");
    
            //The frame factory manages the individual frames for maximum memory efficiency
            var frameFactory: TexturePackerFrameFactory = new TexturePackerFrameFactory();
            //define an animation by name. That way you can duplication the animations as much as you want efficiently
            frameFactory.define("lazlo", srcBd, frameData);
    
            //The visual component of the animation
            var container: Sprite = new Sprite();
            var bitmap: Bitmap = new Bitmap();
            container.addChild(bitmap);
            addChild(container);
    
            //create the animation clip and assign it the name for the animation to show
            var animationClip: FrameFactoryAnimationClip = new FrameFactoryAnimationClip();
            animationClip.setup(bitmap, frameFactory, "lazlo");
    
            //configure the animation
            var animation: RunnableAnimation = new RunnableAnimation();
            animation.animationClip = animationClip;
            animation.fps = 18; //define the speed unto which to update the frames
            animation.loop = true; //defaults to true
            animation.pingPong = false; //defaults to false
            animation.reverse = false; //defaults to false
    
            //add it to the scheduler to have it animate
            _taskScheduler.addJob(animation);
        }
    
        private function onEnterFrame(e: Event): Void {
            //This is the number of milliseconds to spend animating.
            //This is where you can get creative and have tons of animations happening but keeping the frame rate high
            _taskScheduler.runJobs(10);
        }
    
    }

I have also added a sound manager where you can have different sound layers playing audio and you can have a master 
volume controller or control the individual sound layers.

Here's a sample usage:

    package;
    import flash.media.SoundTransform;
    import flash.media.SoundChannel;
    import flash.media.Sound;
    import flash.net.URLRequest;
    import audio.SoundHandle;
    import audio.SoundLayer;
    import audio.LayeredSoundManager;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.display.Sprite;
    import openfl.Assets;
    
    class Main extends Sprite {
    
        private var _soundManager: LayeredSoundManager;
    
        public function new() {
            super();
    
            _soundManager = new LayeredSoundManager();
            _soundManager.addSoundLayer("music");
            _soundManager.addSoundLayer("env");
            _soundManager.addSoundLayer("ambient");
            _soundManager.addSoundLayer("sfx");
    
            var allSounds: Array<String> = ["tali", "rok", "glitter", "win"];
            var layers: Array<String> = ["music", "env", "ambient", "sfx"];
    
            _soundManager.mapSound(allSounds[0], "assets/05 Talisman.mp3", layers[0]);
            _soundManager.mapSound(allSounds[1], "assets/11 Souk Rok.mp3", layers[1]);
            _soundManager.mapSound(allSounds[2], "assets/Avatar Music-Glitter Love-www.mrtzcmp3.net.mp3", layers[2]);
            _soundManager.mapSound(allSounds[3], "assets/SFX_BonusWin_05.wav", layers[3]);
    
            var container: Sprite = new Sprite();
            var button0: Sprite = createButton(0, 0, function(me: MouseEvent): Void {
                _soundManager.masterVolume -= 0.1;
            });
            container.addChild(button0);
            var button1: Sprite = createButton(60, 0, function(me: MouseEvent): Void {
                _soundManager.masterVolume += 0.1;
            });
            container.addChild(button1);
            addChild(container);
    
            var index: Int = 0;
            var allLayers: Array<SoundLayer> = _soundManager.allSoundLayers;
            var yPos: Float = 0;
            for(layer in allLayers) {
                var container: Sprite = new Sprite();
                container.y = yPos;
                var sound: String = allSounds[index];
                var layer: SoundLayer = _soundManager.getSoundLayerByName(layers[index]);
                var button2: Sprite = createButton(0, 25, function(me: MouseEvent): Void {
                    var soundHandle: SoundHandle = _soundManager.getSound(sound);
                    soundHandle.play();
                });
                container.addChild(button2);
                var button3: Sprite = createButton(0, 50, function(me: MouseEvent): Void {
                    layer.volume -= 0.1;
                });
                container.addChild(button3);
                var button4: Sprite = createButton(60, 50, function(me: MouseEvent): Void {
                    layer.volume += 0.1;
                });
                container.addChild(button4);
    
                addChild(container);
                index++;
                yPos += 100;
            }
        }
    
        private inline function createButton(x: Float, y: Float, handler: MouseEvent->Void): Sprite {
            var sprite: Sprite = new Sprite();
            sprite.graphics.beginFill(0x00AA00);
            sprite.graphics.drawRect(0,0,50,20);
            sprite.graphics.endFill();
            sprite.buttonMode = true;
            sprite.x = x;
            sprite.y = y;
            sprite.addEventListener(MouseEvent.CLICK, handler);
            return sprite;
        }
    }
