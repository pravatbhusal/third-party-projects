
package me.Shadowsych;



import org.bukkit.ChatColor;
import org.bukkit.GameMode;
import org.bukkit.Material;
import org.bukkit.entity.Player;
import org.bukkit.event.EventHandler;
import org.bukkit.event.Listener;
import org.bukkit.event.player.PlayerMoveEvent;
import org.bukkit.event.player.PlayerToggleFlightEvent;



public class EventListeners implements Listener {
	
	MainProgram MainCode;

	public EventListeners(MainProgram plugin) {
		MainCode = plugin;
		plugin.getServer().getPluginManager().registerEvents(this, plugin); //Registers Event Main
	}
	
	//Let the player fly!
	@EventHandler
	public void PlayerToggleFlight(PlayerToggleFlightEvent EventFloat){

		Player player = EventFloat.getPlayer();
		
		if(player.getGameMode() == GameMode.CREATIVE)
		return; //If the player is creative then don't do this Event.
		EventFloat.setCancelled(true); 
		player.setAllowFlight(false);
		
		//If we can restart the jump
		if(MainCode.CanRestart == true){
		
		//If the player can double jump for three minutes cooldown
		if(player.hasPermission("doublejump.threemin")){
			if(!(player.hasPermission("doublejump.twomin"))){
				if(!(player.hasPermission("doublejump.onemin"))){
					player.performCommand("threedj");
				}
			}
		}
		//If the player can double jump for two minutes cooldown
		if(player.hasPermission("doublejump.twomin")){
			if(player.hasPermission("doublejump.threemin")){
				if(!(player.hasPermission("doublejump.onemin"))){
					player.performCommand("twodj");
				}
			}
		} 
		//If the player can double jump for one minute cooldown
		if(player.hasPermission("doublejump.onemin")){
			if(player.hasPermission("doublejump.twomin")){
				if(player.hasPermission("doublejump.threemin")){
			player.performCommand("onedj");
				}
			}
		}
		
		//Speed to make the player jump and then give a message saying "You have double jumped!" 
		player.setVelocity(player.getLocation().getDirection().multiply(0).setY(1));
		player.sendMessage(ChatColor.AQUA + "You have double jumped!");
		}
		
	}
	
	@EventHandler
	//Can the player double jump?
	public void PlayerJump(PlayerMoveEvent EventJumped){
	Player player = EventJumped.getPlayer();
	if((player.getGameMode() != GameMode.CREATIVE) //Player is not creative
			&& (player.getLocation().subtract(0, 1, 0).getBlock().getType() != Material.AIR) //Block beneath them is not air
			&& (!player.isFlying())) //Player is not flying
	{
		player.setAllowFlight(true); //Allow the player to fly
	}
		
	
}
}

