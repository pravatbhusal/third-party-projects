
package 
{
	import com.whirled.ServerObject;
	import com.whirled.avrg.AVRServerGameControl;
	import com.whirled.avrg.AVRGameControlEvent;
	import flash.utils.Timer;

	import flash.events.TimerEvent;
	public class Server extends ServerObject
	{
		public var Sctrl:AVRServerGameControl;

		public function Server()
		{
			Sctrl = new AVRServerGameControl(this);
		}
	}
}