//
// $Id$
//
// The server agent for uselessCoinGame4Shadow - an AVR game for Whirled

package {


	import com.whirled.*;
	import com.whirled.avrg.*;
	import com.whirled.net.*;

	/**
	 * The server agent for uselessCoinGame4Shadow. Automatically created by the
	 * whirled server whenever a new game is started.
	 */
	public class Server extends ServerObject {
		/**
		 * Constructs a new server agent.
		 */
		public function Server() {
			_control = new AVRServerGameControl(this);
			trace("Server reporting for duty!");

			// Look for server messages.
			_control.game.addEventListener(MessageReceivedEvent.MESSAGE_RECEIVED, MsgReceived);

			function MsgReceived(event: MessageReceivedEvent): void {
				// Get the player ID from the message's value.
				var playerId: int = int(event.value);
				// Get the player object from the player's ID.
				var player: PlayerSubControlServer = _control.getPlayer(playerId);

				if (event.name == "coins") { //we award coins
					player.completeTask("Reward Coins!", 0.4);
				}
				if(event.name.indexOf("prize_") != -1) { //this is a prize message, so let's award the prize!
					var prizeIdent:String = event.name.replace("prize_", "");
					player.awardPrize(prizeIdent);
				}
			}
			
		} //end constructor
		protected var _control: AVRServerGameControl;
	}
}