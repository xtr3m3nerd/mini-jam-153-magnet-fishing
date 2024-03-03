extends Area2D

var collected_pickups : Array[Pickup] = []

func _on_body_entered(body):
	
	#add to collected_pickups and increase money
	if(body.is_in_group("player")):
		for magnet_object in body.magnetic_zone.get_overlapping_bodies():
			if magnet_object.is_in_group("pickup"):
				collected_pickups.append(magnet_object.pickup)
				PlayerManager.money += magnet_object.pickup.value
				magnet_object.queue_free()
	
	PlayerManager.pickups.append_array(collected_pickups)
	collected_pickups = []
	
	print(PlayerManager.money)
	
	
	
	
	pass # Replace with function body.
