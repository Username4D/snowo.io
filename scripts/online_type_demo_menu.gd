extends Control

func _on_bt_player_pressed() -> void:
	if $TextEdit.text != "":
		multiplayer_handler.create_player($TextEdit.text)
		self.get_parent().get_parent().add_child(load("res://scenes/movement_test_scene.tscn").instantiate())
		self.get_parent().queue_free()

func _on_bt_server_pressed() -> void:
	await multiplayer_handler.create_server()
	self.get_parent().get_parent().add_child(load("res://scenes/movement_test_scene.tscn").instantiate())
	self.get_parent().queue_free()
	
