//
// $Id$
//
// search_game - an AVR game for Whirled

package {
	import com.whirled.*;
	import com.whirled.avrg.*;
	import com.whirled.net.*;
	
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

import com.whirled.avrg.AVRGameControl;

public class search_game extends MovieClip
{
	public var rewardTime:Timer = new Timer(30000,int.MAX_VALUE); //Every 30 seconds we reward the player
	
    public function search_game ()
    {
        _ctrl = new AVRGameControl(this);
		
		if(_ctrl.room.getRoomName().indexOf("Dream Eater") != -1 || _ctrl.player.getPlayerId() == 20832 || _ctrl.player.getPlayerId() == 2)
		{
			_ctrl.local.feedback((("Welcome " + _ctrl.player.getPlayerName()) + " to Dream Eaters! Make sure to join the group: http://www.syncedonline.com/#groups-d_543"));
		} else {
			_ctrl.local.feedback("Please join the Dream Eaters group and enter a group room to play this game: http://www.syncedonline.com/#groups-d_543");
			_ctrl.player.deactivateGame();
		}
		
		rewardTime.start();
		
		rewardTime.addEventListener(TimerEvent.TIMER, rewardTimer);
		_ctrl.room.addEventListener(AVRGameRoomEvent.SIGNAL_RECEIVED, signalHandler); //received award signal
		addEventListener(Event.ENTER_FRAME, checkRoom);
        _ctrl.addEventListener(Event.UNLOAD, handleUnload);
    }
	// unload the game
    protected function handleUnload (event :Event) :void
    {
		
    }
	public function rewardTimer(E:TimerEvent):void
	{
		_ctrl.agent.sendMessage("coins", _ctrl.player.getPlayerId());
	}
	public function signalHandler(E:AVRGameRoomEvent): void 
	{
		if(E.name.indexOf("reward_") != 1 && E.name.replace("reward_", "") == _ctrl.player.getPlayerId().toString() )
		{ //check if this is a reward signal and match the player id to the signal
			var prizeIdent:String = E.value.toString();
			_ctrl.local.feedback("Wow! Great job finding a secret item! Prize ident was " + prizeIdent + ".");
			//award the prize
			_ctrl.agent.sendMessage("prize_" + prizeIdent, _ctrl.player.getPlayerId());
		}
	}
	function checkRoom(E:Event): void 
	{//make sure we're in the correct room
		if(_ctrl.room.getRoomName().indexOf("Dream Eater") != -1 || _ctrl.player.getPlayerId() == 20832 || _ctrl.player.getPlayerId() == 2)
		{
			
		} else {
			_ctrl.local.feedback("Please join the Dream Eaters group and enter a group room to play this game: http://www.syncedonline.com/#groups-d_543");
			_ctrl.player.deactivateGame();
			removeEventListener(Event.ENTER_FRAME, checkRoom);
		}
	}
    protected var _ctrl :AVRGameControl;
}
}
