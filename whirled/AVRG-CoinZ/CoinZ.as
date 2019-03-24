
package 
{
	import flash.events.Event;
	import com.whirled.avrg.AVRGameControl;
	import com.whirled.avrg.AVRGameRoomEvent;
	import flash.display.MovieClip;
	import com.whirled.game.PlayerSubControl;
	import com.whirled.ControlEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import com.whirled.avrg.AVRGameControlEvent;

	public class CoinZ extends MovieClip
	{
		public var ctrl:AVRGameControl;//ALL Control instances are handled through here.
		public var myCoinTime:Timer = new Timer(15000,int.MAX_VALUE);//Every 15 seconds for the timer 
		public var playerId:Number = 0;
		
		public function Greeter()
		{
			ctrl = new AVRGameControl(this);
			
			trace("CoinZ is up and working!");

			// whenever the player joins the game we'll start the timer that runs every 15 seconds to reward coins
			ctrl.addEventListener(AVRGameControlEvent.PLAYER_JOINED_GAME, playerJoined);
			myCoinTime.addEventListener(TimerEvent.TIMER,CoinTimer);

			// messages to show whenever player enters game
			ctrl.local.feedback((("Welcome " + ctrl.player.getPlayerName()) + " to CoinZ!"));
			ctrl.local.feedback("CoinZ was programmed by Shadowsych. Synced Profile: http://www.syncedonline.com/#people-2");
			ctrl.addEventListener(Event.UNLOAD,handleUnload);
		}

		public function handleUnload(E:Event):void
		{
			//Put RemoveEventListener's here. (this event is ran whenever the player quits the game)
		}
		
		public function playerJoined(E:AVRGameControlEvent):void
		{
		        // get the player's id and start the timer to award coins
			playerId = (E.value as Number);
			myCoinTime.start();
		}
		public function CoinTimer(E:TimerEvent):void
		{
			ctrl.player.completeTask("Reward Coins!", 1.0);
		}
	}
}
