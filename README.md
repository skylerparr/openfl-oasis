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
