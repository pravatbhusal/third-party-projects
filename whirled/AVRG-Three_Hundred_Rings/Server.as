//
// $Id$
//
// The server agent for three_hundred_rings - an AVR game for Whirled

package {
	
	import com.whirled.*;
	import com.whirled.avrg.*;
	import com.whirled.net.*;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

public class Server extends ServerObject
{
    public function Server ()
    {
        _control = new AVRServerGameControl(this);
		_control.game.addEventListener(MessageReceivedEvent.MESSAGE_RECEIVED, MsgReceived);
		var spawnTimer:Timer = new Timer(10000); 
		spawnTimer.addEventListener(TimerEvent.TIMER, spawnTick);
		spawnTimer.start();
		
		//spawn timer
		function spawnTick(E:TimerEvent): void {
			_control.game.sendMessage("changeSpawnPosition", "");
		}

		//messages received from the client actionscript file
		function MsgReceived(E:MessageReceivedEvent): void {
			var playerId: int = 0;
			var player: PlayerSubControlServer = null;
			
			if(E.name == "setClickedRingPosition")
			{ //if the message's name is the phrase "setClickedRingPosition"
				var clickedPosition:Array = E.value as Array;
				var positionData:Array = new Array(clickedPosition[0], clickedPosition[1], Math.floor(Math.random() * (12 - 1 + 1) + 1), Math.floor(Math.random() * (1300 - 0 + 1) + 0), Math.floor(Math.random() * (500 - 50 + 1) + 50));
				_control.game.sendMessage("getClickedRingPosition", positionData);
			}
			
			if (E.name == "rewardRingCoins") {
				playerId = int(E.value);
				player = _control.getPlayer(playerId);
				player.completeTask("Reward Coins!", 0.20);
			} else if(E.name == "rewardRubyRingCoins") {
				playerId = int(E.value);
				player = _control.getPlayer(playerId);
				player.completeTask("Reward Coins!", 0.35);
 			} else if(E.name == "rewardDiamondRingCoins") {
				playerId = int(E.value);
				player = _control.getPlayer(playerId);
				player.completeTask("Reward Coins!", 0.50);
			}
			
			if(E.name == "setRingPosition")
			{ //if the message's name is the phrase "setRingPosition", then add a ring
				var numberOfPlayers:Number = Number(E.value);
				var ringData:Array = [];
				for(var i:Number = 0; i < numberOfPlayers; i++) {
					//quadruple-dimension array (0 = name, 1 = chance of spawning rare ring, 2 = x-coordinate, 3 = y-coordinate)
					ringData.push(["ring" + i, Math.floor(Math.random() * (12 - 1 + 1) + 1), Math.floor(Math.random() * (1300 - 0 + 1) + 0), Math.floor(Math.random() * (500 - 50 + 1) + 50)]);
				}
				_control.game.sendMessage("getRingPosition", ringData);
			}
			
			if(E.name == "getGlobalChat")
			{ //if the message's name is the phrase "getGlobalChat"
				var globalChatMessage:String = String(E.value);
				_control.game.sendMessage("sayGlobalChat", globalChatMessage);
			}
		}
    } //end constructor

    protected var _control :AVRServerGameControl;
}

}