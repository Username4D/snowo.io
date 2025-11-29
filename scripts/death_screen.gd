extends Control


func pop_up():
	$borders.modulate.a = 0
	self.visible = true
	$fade_in.start()
	while $fade_in.time_left != 0:
		await get_tree().process_frame
		$borders.modulate.a = 1 - $fade_in.time_left / 3
		$respawn_label.text = "Respawn (R) | " + str(round($fade_in.time_left * 10) / 10)
	$respawn_label.text = "Respawn (R) | Now"
	$borders.modulate.a = 1

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("reload") and $borders.modulate.a == 1 and self.visible:
		self.visible = false
		self.get_parent().respawn.rpc()
		self.get_parent().respawn()
