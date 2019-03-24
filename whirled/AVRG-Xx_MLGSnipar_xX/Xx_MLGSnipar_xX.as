package 
{

	import flash.display.MovieClip;
	import flash.events.Event;
	import com.whirled.avrg.AVRGameControl;
	import flash.ui.Mouse;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class Xx_MLGSnipar_xX extends MovieClip
	{
		public function Xx_MLGSnipar_xX()
		{
			Mouse.hide();

			_ctrl = new AVRGameControl(this);
			_ctrl.local.feedback("u th1nk ur m1g enuf 4 dis?!?!?! xX_ank0sl@yer_xxx will destroy u m8");
			//areaSize = _ctrl.local.getPaintableArea();

			// add the gun instance, and it's controls: (moving the gun and killing monsters)
			addChild(_gun);
			addEventListener(Event.ENTER_FRAME, ctrlGun);
			addEventListener(Event.ENTER_FRAME, ctrlKill);
			
			// shoot event  (NOTE: do not EVER refer to the stage in avrg games!)
			_gun.addEventListener(MouseEvent.CLICK, shootGun);
			
			//start the timer to spawn the entities
			timerListener.start();
			timerListener.addEventListener(TimerEvent.TIMER, ctrlSpawn);
			
			_ctrl.addEventListener(Event.UNLOAD, handleUnload);
		}

		protected function handleUnload(event :Event):void
		{ //whenever the player closes the game
			Mouse.show();
			_ctrl.local.feedback("dats r1te ch@mp, u better not come back");
		}
		// this controls the gun's movement and frames
		protected function ctrlGun(E:Event):void
		{
			//if we're in frame 1, then make the gun equal to where the mouse's X and Y is located
			if(_gun.currentFrame == 1)
			{
			_gun.x = mouseX;
			_gun.y = mouseY;
			}

			// if the gun's shoot animation is in frame 10, then back to the gun's idle position
			if (_gun.inside_gun.shoot.currentFrame == 10)
			{
				_gun.inside_gun.gotoAndStop(1);
			}

		}
		protected function shootGun(E:MouseEvent):void
		{ //goto the shoot gun animation
			_gun.inside_gun.gotoAndStop(2);
		}
		protected function ctrlSpawn(E:TimerEvent): void 
		{
		       //random number of 1 or 2 (1 = spawn a bad guy) (2 = spawn a good guy)
			if( (Math.floor(Math.random() * (2 - 1 + 1)) + 1) == 1){
			//we got the number 1
			badNum ++;
			totalNum ++
			badCount.push(new badGuys());
			badCount[badNum].x = (Math.floor(Math.random() * (1000 - 0 + 1)) + 0); //random x spawn
			badCount[badNum].y = (Math.floor(Math.random() * (400 - 0 + 1)) + 0); //random y spawn
			addChildAt(badCount[badNum], totalNum); //add the badguy; we have a 2nd argument so that we can overlap the entities
			} else {
			//we got the number 2
			goodNum ++;
			totalNum ++;
			goodCount.push(new goodGuys());
			goodCount[goodNum].x = (Math.floor(Math.random() * (1000 - 0 + 1)) + 0);
			goodCount[goodNum].y = (Math.floor(Math.random() * (400 - 0 + 1)) + 0);
			addChildAt(goodCount[goodNum], totalNum); //add the goodguy; we have a 2nd argument so that we can overlap the entities
			}
		}
		protected function ctrlKill(E:Event): void 
		{
			for(var i = 0; i < badNum; i ++){ //we use this for loop to iterate through which specific bad guy was shot
			if(_gun.inside_gun.shoot.hit.hitTestObject(badCount[i]))
			{
				badCount[i].visible = false;
				badCount[i].y = 5000;
				_ctrl.player.completeTask("Task", 0.1); //award coins!
			} 
			}
		}

		protected var _ctrl:AVRGameControl;
		protected var _gun:gunMovieClip = new gunMovieClip();
		protected var timerListener:Timer = new Timer(1000, 99999); //every 5 seconds
		public var areaSize;
		public var goodNum = -1; //total number of good guys spawned, must start at -1 since array index starts at 0
		public var badNum = -1; //total number of badguys spawned, must start at -1 since array index starts at 0
		public var totalNum = -1; //total number of entities (bad and good guys) spawned, must start at -1 since array index starts at 0
		public var badCount:Array = []; //this array holds all of the badguy MovieClips
		public var goodCount:Array = []; //this array holds all of the goodguy MovieClips
	}
}
