//
// $Id$
//
// lucky_pick - an AVR game for Whirled

package {

import flash.display.Sprite;
import flash.events.Event;
	import com.whirled.*;
	import com.whirled.avrg.*;
	import com.whirled.net.*;

public class lucky_pick extends Sprite
{
	public var Score:Number = 0;
    public function lucky_pick ()
    {
        _ctrl = new AVRGameControl(this);
		addChild(showScore);
		showScore.x = 725;
		//check for the score property
		showScore.scoreTxT.text = String(Score);
		
		_ctrl.agent.sendMessage("trophy_firstgame", _ctrl.player.getPlayerId());
		_ctrl.local.feedback("Welcome " + _ctrl.player.getPlayerName() + " to Lucky Pick!");
		_ctrl.local.feedback("Make sure to join the group: http://www.syncedonline.com/#groups-d_619");
		
		addEventListener(Event.ENTER_FRAME, checkRoom);
		_ctrl.room.addEventListener(AVRGameRoomEvent.SIGNAL_RECEIVED, cloverSignal);
        _ctrl.addEventListener(Event.UNLOAD, handleUnload);
    }
	
    protected function handleUnload (event :Event) :void
    {
		
    }
	public function cloverSignal(E:AVRGameRoomEvent): void {
		if(Number(E.name) == _ctrl.player.getPlayerId() && String(E.value) == "four-leaf-clover") 
		{ //first we need to check if the playerId that clicked the clover is equal to the client playing
			_ctrl.local.feedback("Congratulations " + _ctrl.player.getPlayerName() + ", you found a four-leaf clover!");
			//award the coins just once
			_ctrl.player.completeTask("Reward Coins!", 1.0);
			Score += 1; //add score by 1
			showScore.scoreTxT.text = String(Score); //update score text
		} else if(Number(E.name) == _ctrl.player.getPlayerId() && String(E.value) == "golden-clover")
		{
			_ctrl.local.feedback("Congratulations " + _ctrl.player.getPlayerName() + ", you found a golden clover!");
			//award the coins 3 times
			_ctrl.player.completeTask("Reward Coins!", 1.0);
			_ctrl.player.completeTask("Reward Coins!", 1.0);
			_ctrl.player.completeTask("Reward Coins!", 1.0);
			Score += 3; //add score by 3
			showScore.scoreTxT.text = String(Score); //update score text
		}
	}
	public function checkRoom(E:Event): void {
			if(_ctrl.room.getRoomId() != 12527)
			{//check to make sure the player is in the correct room, or else deactivate the game with a message said once:
				_ctrl.local.feedback("You're in the incorrect room to play this game. http://www.syncedonline.com/#world-s12527");
				_ctrl.player.deactivateGame();
				removeEventListener(Event.ENTER_FRAME, checkRoom);
			} 
	}

    protected var _ctrl :AVRGameControl;
	public var showScore:score_gui = new score_gui();
}
}
