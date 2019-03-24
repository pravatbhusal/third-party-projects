package me.Shadowsych;

//DoubleJump created by Shadowsych.

import org.bukkit.Bukkit;
import org.bukkit.ChatColor;
import org.bukkit.Server;
import org.bukkit.command.Command;
import org.bukkit.command.CommandSender;
import org.bukkit.entity.Player;
import org.bukkit.permissions.Permission;
import org.bukkit.plugin.PluginManager;
import org.bukkit.plugin.java.JavaPlugin;

public class MainProgram extends JavaPlugin{
	
	public boolean CanRestart = true;
	public int CDNumber1 = 180;
	public int CDNumber2 = 120;
	public int CDNumber3 = 60;
	public int DetermineCounter1;
	public int DetermineCounter2;
	public int DetermineCounter3;
	public Permission ThreeMinJump = new Permission("doublejump.threemin"); //Default Rank
	public Permission TwoMinJump = new Permission("doublejump.twomin"); //Monk
	public Permission OneMinJump = new Permission("doublejump.onemin"); //Ruler
		
		@Override
		public void onEnable(){ //Essential, when your plugin is enabled.
			getLogger().info("Double Jump is up and running! - Created by Shadowsych."); //CMD will print this out.
			new EventListeners(this); //Inherits the EventListeners class
		}
		
		@Override
		public void onDisable(){//Essential, when your plugin is disabled.
			
		}
		
		@SuppressWarnings("deprecation")
		public boolean onCommand(CommandSender sender, Command cmd, String label, String[] args) { //Creates command function.
			Player player = (Player) sender;
			
			//Three minute double jump cooldown
			if(cmd.getName().equalsIgnoreCase("threedj") && player.hasPermission("doublejump.threemin") && !(player.hasPermission("doublejump.onemin")) && !(player.hasPermission("doublejump.twomin"))){ 
				if(CanRestart == true){ //Checks to see if the Timer is still running
				CanRestart = false; //The timer has ran.
				CDNumber1 = 180;
				DetermineCounter1 = Bukkit.getServer().getScheduler().scheduleAsyncRepeatingTask(this, new Runnable(){
					
					public void run(){
							if(CDNumber1 > -1){ //This can be a 0 integer
								if(!(CDNumber1 == 0)){ //If once it is 0.
								}
							CDNumber1 --; //Makes the number -1 if it's already a 0.
						}
						if(CDNumber1 == -1){ //Now catches that the number is -1.
							player.sendMessage(ChatColor.GREEN + "Your double jump ability has refreshed!");
							CanRestart = true; //You can restart your timer now.
							Bukkit.getServer().getScheduler().cancelTask(DetermineCounter1); //Disables counter.
							return;
						}
					}
				}, 0L, 20L);
				}
				
				
			} 	
			
			//Two minute double jump cooldown
			if(cmd.getName().equalsIgnoreCase("twodj") && player.hasPermission("doublejump.twomin") && !(player.hasPermission("doublejump.onemin")) && (player.hasPermission("doublejump.threemin"))){ 
				if(CanRestart == true){ //Checks to see if the Timer is still running
				CanRestart = false; //The timer has ran.
				CDNumber2 = 120;
				DetermineCounter2 = Bukkit.getServer().getScheduler().scheduleAsyncRepeatingTask(this, new Runnable(){
					
					public void run(){
							if(CDNumber2 > -1){ //This can be a 0 integer
								if(!(CDNumber2 == 0)){ //If once it is 0.
								}
							CDNumber2 --; //Makes the number -1 if it's already a 0.
						}
						if(CDNumber2 == -1){ //Now catches that the number is -1.
							player.sendMessage(ChatColor.GREEN + "Your double jump ability has refreshed!");
							CanRestart = true; //You can restart your timer now.
							Bukkit.getServer().getScheduler().cancelTask(DetermineCounter2); //Disables counter.
							return;
						}
					}
				}, 0L, 20L);
				}
				
				
			}	
			
			//One minute double jump cooldown
			if(cmd.getName().equalsIgnoreCase("onedj") && player.hasPermission("doublejump.onemin") && player.hasPermission("doublejump.twomin") && player.hasPermission("doublejump.threemin")){ 
				if(CanRestart == true){ //Checks to see if the Timer is still running
				CanRestart = false; //The timer has ran.
				CDNumber3 = 60;
				DetermineCounter3 = Bukkit.getServer().getScheduler().scheduleAsyncRepeatingTask(this, new Runnable(){
					
					public void run(){
							if(CDNumber3 > -1){ //This can be a 0 integer
								if(!(CDNumber3 == 0)){ //If once it is 0.
								}
							CDNumber3 --; //Makes the number -1 if it's already a 0.
						}
						if(CDNumber3 == -1){ //Now catches that the number is -1.
							player.sendMessage(ChatColor.GREEN + "Your double jump ability has refreshed!");
							CanRestart = true; //You can restart your timer now.
							Bukkit.getServer().getScheduler().cancelTask(DetermineCounter3); //Disables counter.
							return;
						}
					}
				}, 0L, 20L);
				}
				
				
			}
			
			return false; //Is essential in a boolean function.
			
		}
	}
		