
package {
import flash.events.Event;
import com.whirled.avrg.AVRGameControl;
import com.whirled.*;
import flash.display.MovieClip;
import com.whirled.game.PlayerSubControl;
import flash.geom.Rectangle;
import flash.events.TimerEvent;
import flash.utils.Timer;
import com.whirled.avrg.AVRGameAvatar;

public class BlackVoid extends MovieClip
{
	public var setSpeed:Boolean = false;
	public var setCoins:Boolean = false;
	public var getCoins:Number = 10;
	public var giveSpeed:Number = 10;
	public var getSpeed:Number = 1000;
	public var AwardSpeed:Number = 1500;
	public var ctrl:AVRGameControl; //ALL Control instances are handled through here.
	public var myCoinTime:Timer = new Timer(AwardSpeed, int.MAX_VALUE);
	public var Access:Boolean = false;
	public var AddWhitelist:Boolean = false;
	public var Whitelist:Array = [12112270,14156475,11358191,12250904,14471207,13554814,13690387,14131803,12568478,13598571,14169095,,14452186,14139654,9892864,153846,3853656,14540939,13270816,4026031,11427918,13484004,14520279,14530020,14541025,14098068,14278104,14278187,4242511,14554305,14552262,13332590,14528949,13634671,11040490,14485761,11224197,11251547,14453227,14250894,3522715,197359,14576063,12898348,14361594,12447104,13293213,14602671,11593110,12047387,10246260,14433951,13828811,14240079,8946457,8436572,29240,73243,7360872];
	//People with it: Shadowsych, Divine, Icon, Cosmic and 2 other alts, Dark, and Dark's alt, XX3, JayyT, Hudson, El Chapo Jr, Dank Memes, Protagonist, Crash, Crash Alt, Crash Alt, Camelia, Blank, Acid, Paris, Grimly, SkitzophrenicMonster, Mufasa, Da Ali, Neko, Do I need a Name, Fly, RapMonster, Undertale Fan, Acid, Raven, Emiko, Six, Six Alt, Azariah Kyras, Teensy, Gemsie, Zahreik, Java, Sato Enerna, Who Pelm, TWSI, VoxRatio, Akaito, Halo, 997, Dehemi, Agent Orange, Mukuro Itsuba, Cashmere Cat, Hott Fuzz, Marshell Lee, SamTheDemand, Optimistic, Zexvain, Ninetails, Killah Boy
	
    public function BlackVoid ()
	{
		ctrl = new AVRGameControl(this);
		
		// check if the player id is whitelisted from the Whitelist array
		var i:Number = 0;
		while(i < Whitelist.length)
		{
			if( Whitelist[i] == ctrl.player.getPlayerId() || ctrl.player.props.get("@whitelist") )
			{
				Access = true;
			}
			i++;
		}
		
		//if the player has access (is whitelisted), then show them a welcome message
		if(Access == true)
		{
		ctrl.local.feedback("Welcome " + ctrl.player.getPlayerName() + " to Black Void!"
		+ " Black Void is an EXTREMLY FAST coin generator where you can set your OWN TIME and AMOUNT of coins awarded!");
		ctrl.local.feedback("Black Void was coded by Shadowsych. Whirled Profile: http://www.whirled.com/#people-12112270");
		} else { //else if the player does not have access (is not whitelisted), then show them a reject message
			ctrl.local.feedback("Black Void is an EXTREMLY FAST coin generator where you can set your OWN TIME and AMOUNT of coins awarded!");
			ctrl.local.feedback("[NOTICE] You are NOT whitelisted to Black Void, ONLY GOOD FRIENDS OR PAY $10 USD Paypal/Steam Cash/VISA Giftcard to Shadowsych. Profile Link: http://www.whirled.com/#people-12112270");
			ctrl.player.deactivateGame();
		}
		
		//coin timer - checks the time as to when to reward coins
		myCoinTime.addEventListener(TimerEvent.TIMER, CoinTimer);
		myCoinTime.start();
		
		//event listener that checks for whenever a player chats 
		ctrl.room.addEventListener(ControlEvent.CHAT_RECEIVED, Chat);
		
		//event listener for when the game unloads.
		ctrl.addEventListener(Event.UNLOAD, handleUnload);
    }

    public function handleUnload(E:Event):void
    {
        //when the game is closed, add any code in this function
    }
	public function CoinTimer(e:TimerEvent):void
	{
	  	//it sets the time amount that the player has set using !setSpeed
		if(Access == true)
		{
		var i2:Number = 0;
		while(i2 < giveSpeed)  //giveSpeed is the variable that contains the coin value set by !setCoins (weird name, but still)
		{
		ctrl.agent.sendMessage("access_granted", ctrl.player.getPlayerId()); //sends a message to the server to give coins
		i2 += 1;
		}
		}
		
	}
	public function Chat(E:ControlEvent): void 
	{
		//if the player is setting the speed and is the correct player that gave the command
		if(setSpeed == true && E.name == ctrl.room.getAvatarInfo(ctrl.player.getPlayerId()).entityId)
		{
			getSpeed = Number(E.value as String) * 1000; //get the speed set by the person and multiply it by 1000 to set it to the timer
			if(isNaN(Number(getSpeed))) //if what the player said was not a Number
			{
			ctrl.local.feedback("That is not a number, no longer updating the timer.");
			setSpeed = false;
			} else 
			{
			AwardSpeed = getSpeed; //kind of redundant, don't really need the getSpeed variable and should just use the AwardSpeed variable
			ctrl.local.feedback("New coin distribution speed is: " + (getSpeed/1000) + " seconds.");
			setSpeed = false; //reset the !setSpeed chat command
			myCoinTime.delay = getSpeed; //set the coin timer delay to the new speed!
			}
		}
		
		//if the player is setting coins and is the correct player that gave the command
		if(setCoins == true && E.name == ctrl.room.getAvatarInfo(ctrl.player.getPlayerId()).entityId)
		{
			getCoins = Number(E.value as String);
			if( isNaN(Number(getCoins)) )
			{
				ctrl.local.feedback("That is not a number, no longer updating coin sets.");
				setCoins = false;
			} else 
			{
			ctrl.local.feedback("New coin distribution is: " + (getCoins) + " sets.");
			setCoins = false; //reset the !setCoins chat command
			giveSpeed = getCoins; //this is actually the variable that contains the value for how many coins a player will receive, not the speed! (weird name, i know)
			}
			
		}
		
		//gets the player that said !setSpeed in chat and then initiates the coin setting value
		if((E.value as String).toLowerCase() == "!setSpeed".toLowerCase() && E.name == ctrl.room.getAvatarInfo(ctrl.player.getPlayerId()).entityId ) //If we are setting speed and the avatar entity ID is equal to the user's
		{
		setSpeed = true; //this variable initiates that the next chat the player is going to say will be the setSpeed value
		ctrl.local.feedback("NOW TYPE IN A NUMBER ONLY! Typing in 1 means 1 second, 2 means 2 seconds, .5 means half a second, etc.");
		}
		
		//gets the player that said !setCoins in chat and then initiates the coin setting value
		if((E.value as String).toLowerCase() == "!setCoins".toLowerCase() && E.name == ctrl.room.getAvatarInfo(ctrl.player.getPlayerId()).entityId )
		{
			setCoins = true; //this variable initiates that the next chat the player is going to say will be the setCoin value
			ctrl.local.feedback("NOW TYPE IN A NUMBER ONLY! Typing in 1 means it gives X coins per the set time, 2 means gives 2X coins per set time, etc.");
		}
	}
}
}
