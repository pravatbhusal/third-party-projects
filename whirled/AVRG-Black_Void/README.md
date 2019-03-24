## Black Void
![Alt text](/game-Addons/Whirled/AVRG-Black_Void/blackvoidicon.png)

Black Void is a super fast coin generator for the website http://www.whirled.com/
The files are now open-source for anyone to study and utilize for future AVRG games in Synced or Whirled.
Synced highly higly highly discourages any re-upload of Black Void on its website.

## Dependencies
You will need:
- Flex SDK (to build the files) 
  - http://www.adobe.com/devnet/flex/flex-sdk-download.html
- Adobe Flash or Notepad++ (to edit the Blackvoid actionscript codes) 
  - https://notepad-plus-plus.org/download/v7.2.2.html
  - http://www.adobe.com/products/animate.html

## Documentation and Setup
- Place the Black Void folder (with the files inside the folder) into your whirled-sdk or synced-sdk home directory
- Open the Black Void folder and open the BlackVoid.as with either Adobe Flash or Notepad++ 
- In the "public var Whitelist:Array = [12112270];" code, add the Synced or Whirled IDs that would be whitelisted to use Black Void (seperate the IDs with commas) Save when done
- Now open the build.bat file
- If you have not setup your Flex sdk to AVRG games in Whirled or Synced before, it will ask you to locate your flex sdk and the runtime
- Once you have setup your runtime and flexsdk file directories in the build.bat, exit the build.bat file and then re-open it
- It should build the swf and abc files and is now ready to be uploaded to Whirled or Synced

## Commands
These commands are to be typed in the Whirled or Synced chatbox
 - Type !setSpeed then press enter then type your coins awarded per second value and then press enter
 - Type !setCoins then press enter then type your coins award amount value and then press enter
