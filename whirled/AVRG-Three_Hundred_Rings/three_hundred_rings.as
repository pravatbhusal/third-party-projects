//
// $Id$
//
// three_hundred_rings - an AVR game for Whirled

package {

import flash.display.Sprite;
import flash.events.Event;
import com.whirled.*;
import com.whirled.avrg.*;
import com.whirled.net.*;
import com.threerings.util.RingBuffer;
import flash.events.MouseEvent;
import flash.display.DisplayObject;
import flash.utils.Timer;
import flash.events.TimerEvent;

public class three_hundred_rings extends Sprite
{
	public var Score:Number = 0;
	private var numberOfPlayers:Number = 1;
	private var chatMuted:Boolean = false;
	
    public function three_hundred_rings ()
    {
        _ctrl = new AVRGameControl(this);
		addChild(showScore);
		showScore.x = 725;
		//check for the score property
		showScore.scoreTxT.text = String(Score);
		
		_ctrl.local.feedback("Welcome " + _ctrl.player.getPlayerName() + " to Three Hundred Rings! This game was created by Shadowsych, West, and JayyT.");
		_ctrl.local.feedback("Use !chat [Message] to speak to global chat, and !mute to mute global chat.");
		
		_ctrl.game.addEventListener(MessageReceivedEvent.MESSAGE_RECEIVED , receivedMessage);
		_ctrl.room.addEventListener(ControlEvent.CHAT_RECEIVED, receivedChat);
        _ctrl.addEventListener(Event.UNLOAD, handleUnload);
    }
	
    protected function handleUnload (event :Event) :void{
		_ctrl.local.feedback("Thanks for playing, hope to see you soon!");
    }
	
	//messages received from the server actionscript file
	private function receivedMessage(E:MessageReceivedEvent): void {
		//when the spawn timer is initiated, then update the number of rings in the server based on the first player's value
		if(E.name == "changeSpawnPosition" && _ctrl.player.getPlayerId() == _ctrl.game.getPlayerIds()[0]) {
			numberOfPlayers = _ctrl.game.getPlayerIds().length;
			if(numberOfPlayers < 1) {
				numberOfPlayers = 1;
			}
			_ctrl.agent.sendMessage("setRingPosition", numberOfPlayers);
		//else if the number of players isn't initiated, then initiate the position for the one client playing alone
		} else if(E.name == "changeSpawnPosition" && _ctrl.game.getPlayerIds().length < 1) {
			_ctrl.agent.sendMessage("setRingPosition", 1);
		}
		
		if(E.name == "getRingPosition")
		{ //if the message's name is the phrase "getRingPosition"
			//delete all the current rings
			for(var j:Number = 0; j < ringData.length; j++) {
				removeChild(ringData[j][0]);
			}
			ringData = E.value as Array;
			updateRingPosition();
		}
		
		if(E.name == "getClickedRingPosition")
		{ //if the message's name is the phrase "getClickedRingPosition"
			var clickedRingItemPosition:Array = E.value as Array;
			for(var i = 0; i < ringData.length; i++) {
				//if the x and y values match for one of the rings in the ringData array for the clicked ring
				if(ringData[i][2] == clickedRingItemPosition[0] && ringData[i][3] == clickedRingItemPosition[1]) {
					if (clickedRingItemPosition[2] == 12) {
						ringData[i][0].ring.gotoAndStop(3);
					} else if (clickedRingItemPosition[2] >= 9 && clickedRingItemPosition[2] != 12) {
						ringData[i][0].ring.gotoAndStop(2);
					} else {
						ringData[i][0].ring.gotoAndStop(1);
					}
					//update the information on the ringData array
					ringData[i][0].x = clickedRingItemPosition[3];
					ringData[i][0].y = clickedRingItemPosition[4];
					ringData[i][1] = clickedRingItemPosition[2];
					ringData[i][2] = clickedRingItemPosition[3];
					ringData[i][3] = clickedRingItemPosition[4];
					
					//make it invisible
					ringData[i][0].visible = false;
					break;
				}
			}
		}
		
		if(E.name == "sayGlobalChat")
		{ //if the message's name is the phrase "sayGlobalChat"
			if(chatMuted == false) {
				_ctrl.local.feedback("[Global Chat] " + String(E.value));
			}
		}
	}
	
	//event that initiates when a person in the room talks
	private function receivedChat(E:ControlEvent): void {
		var entityId:String = String(E.name);
		var chatValue:String = String(E.value);
		//check if the player that chatted was the player in control
		if(entityId == _ctrl.room.getAvatarInfo(_ctrl.player.getPlayerId()).entityId) {
			//check if the chat was a global chat (contains !chat)
			if(chatValue.indexOf("!chat") > -1) {
				chatValue = chatValue.replace("!chat", "");
				var sendChatMessage:String = _ctrl.player.getPlayerName() + ":" + chatValue;
				_ctrl.agent.sendMessage("getGlobalChat", sendChatMessage);
			} else if(chatValue == "!mute") {
				if(chatMuted == false) {
					chatMuted = true;
					_ctrl.local.feedback("You have muted global chat. Use !mute again to unmute the chat.");
				} else {
					chatMuted = false;
					_ctrl.local.feedback("You have unmuted global chat. Use !mute to mute the chat.");
				}
			}
		}
	}
	
	//updates all the rings' positions based on the values received from the server
	private function updateRingPosition() {
		//add new rings
		for(var i:Number = 0; i < ringData.length; i++) {
			ringData[i][0] = new ring_item();
			addChild(ringData[i][0]);
			ringData[i][0].buttonMode = true;
			ringData[i][0].addEventListener(MouseEvent.CLICK, clickedRingItem);
			if (ringData[i][1] == 12) {
				ringData[i][0].ring.gotoAndStop(3);
			} else if (ringData[i][1] >= 9 && ringData[i][1] != 12) {
				ringData[i][0].ring.gotoAndStop(2);
			} else {
				ringData[i][0].ring.gotoAndStop(1);
			}
			ringData[i][0].x = ringData[i][2];
			ringData[i][0].y = ringData[i][3];
			//decide whether or not this ring will be visible for this round by checking if the addition of the x and y values is odd
			if((ringData[i][2] + ringData[i][3]) % 2 != 0) {
				ringData[i][0].visible = true;
			} else {
				ringData[i][0].visible = false;
			}
		}
	}
	
	private function clickedRingItem(E:MouseEvent): void {
		var clickedRingItem:DisplayObject = E.currentTarget as DisplayObject;
		var clickedRingItemPosition:Array = new Array(clickedRingItem.x, clickedRingItem.y);
		_ctrl.agent.sendMessage("setClickedRingPosition", clickedRingItemPosition);
		
		E.currentTarget.valueOf().visible = false;
		
		//find out which type of ring we clicked so that we can award the player properly
		if(E.currentTarget.valueOf().ring.currentFrame == 1) {
			_ctrl.agent.sendMessage("rewardRingCoins", _ctrl.player.getPlayerId());
			Score += 1;
			showScore.scoreTxT.text = String(Score);
		} else if(E.currentTarget.valueOf().ring.currentFrame == 2) {
			_ctrl.local.feedback("Whoah, you found a ruby!");
			_ctrl.agent.sendMessage("rewardRubyRingCoins", _ctrl.player.getPlayerId());
			Score += 3;
			showScore.scoreTxT.text = String(Score);
 		} if(E.currentTarget.valueOf().ring.currentFrame == 3) {
			_ctrl.local.feedback("Nice! You found a diamond!");
			_ctrl.agent.sendMessage("rewardDiamondRingCoins", _ctrl.player.getPlayerId());
			Score += 6;
			showScore.scoreTxT.text = String(Score);
		}
	}

    protected var _ctrl :AVRGameControl;
	public var showScore:score_gui = new score_gui();
	public var ringData:Array = [];
}
}