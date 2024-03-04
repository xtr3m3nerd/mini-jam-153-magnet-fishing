extends Area2D

var collected_pickups : Array[Pickup] = []
var transition_sound_player := AudioStreamPlayer.new()

func _ready():
	add_child(transition_sound_player)

func _on_body_entered(body):
	
	#add to collected_pickups and increase money
	if(body.is_in_group("player")):
		for magnet_object in body.magnetic_zone.get_overlapping_bodies():
			if magnet_object.is_in_group("pickup"):
				collected_pickups.append(magnet_object.pickup)
				PlayerManager.money += magnet_object.pickup.value
				
				
				PlayerManager.picked_up_ids.append(magnet_object.get_index())
				#magnet_object.queue_free()
	
	PlayerManager.pickups.append_array(collected_pickups)
	
	
	collected_pickups = []
	
	var leave_effect = load("res://assets/sfx/shopexit.wav")
	transition_sound_player.stream = leave_effect
	transition_sound_player.play()
	await transition_sound_player.finished
	
	call_deferred("change_to_shop")
	
	pass # Replace with function body.

func change_to_shop():
	SceneManager.change_to_shop()
