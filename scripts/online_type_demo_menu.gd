extends Control

func _on_bt_player_pressed() -> void:
	multiplayer_handler.create_player()
	self.get_parent().add_child(load("res://scenes/movement_test_scene.tscn").instantiate())
	self.queue_free()

func _on_bt_server_pressed() -> void:
	multiplayer_handler.create_server()
	self.get_parent().add_child(load("res://scenes/movement_test_scene.tscn").instantiate())
	self.queue_free()
