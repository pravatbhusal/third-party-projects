//
// $Id$
//
// The server agent for lucky_pick - an AVR game for Whirled

package {
	
	import com.whirled.*;
	import com.whirled.avrg.*;
	import com.whirled.net.*;

public class Server extends ServerObject
{
    public function Server ()
    {
        _control = new AVRServerGameControl(this);
        trace("Lucky Pick server agent reporting for duty!");
		
		_control.game.addEventListener(MessageReceivedEvent.MESSAGE_RECEIVED, MsgReceived);

			function MsgReceived(E:MessageReceivedEvent): void {
				// Get the player ID from the message's value.
				var playerId: int = int(E.value);
				// Get the player object from the player's ID.
				var player: PlayerSubControlServer = _control.getPlayer(playerId);
				
				if(String(E.name).indexOf("trophy") != -1) 
				{ //if the message's name has the phrase "trophy"
					player.awardTrophy(String(E.name));
				} //check if trophy
			}
    } //end constructor

    protected var _control :AVRServerGameControl;
}

}
