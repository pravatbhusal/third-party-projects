//
// $Id$
//
// The server agent for BlackVoid - an AVR game for Whirled

package {

	import com.whirled.*;
	import com.whirled.avrg.*;
	import com.whirled.net.*;

public class Server extends ServerObject
{
    public var _control :AVRServerGameControl;
	
    public function Server ()
    {
        _control = new AVRServerGameControl(this);
	_control.game.addEventListener(MessageReceivedEvent.MESSAGE_RECEIVED, MsgReceived); //this event listener will get any client messages sent to the server
		
		function MsgReceived(event: MessageReceivedEvent): void {
		
		var playerId: int = int(event.value); //get the player ID from the message's value.
		var player: PlayerSubControlServer = _control.getPlayer(playerId); //get the player object from the player's ID.

		if (event.name == "access_granted") { //we award coins with granted access
			player.completeTask("Reward Coins!", 1);
		}	
      } //end function
    } //end constructor
  } //end class
} //end package
