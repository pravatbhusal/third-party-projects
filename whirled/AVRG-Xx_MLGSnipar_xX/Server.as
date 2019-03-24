//
// $Id$
//
// The server agent for fps_shooter - an AVR game for Whirled

package {

import com.whirled.ServerObject;
import com.whirled.avrg.AVRServerGameControl;

/**
 * The server agent for fps_shooter. Automatically created by the 
 * whirled server whenever a new game is started. 
 */
public class Server extends ServerObject
{
    /**
     * Constructs a new server agent.
     */
    public function Server ()
    {
        _control = new AVRServerGameControl(this);
        trace("fps_shooter server agent reporting for duty!");
    }

    protected var _control :AVRServerGameControl;
}

}
