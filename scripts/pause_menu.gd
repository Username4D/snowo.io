extends Control

func _on_close_pressed() -> void:
	self.get_parent().close_menu()

func _on_exit_pressed() -> void:
	multiplayer_handler.peer.leave_room()
	self.get_parent().get_parent().get_parent().add_child(load("res://scenes/main_menu.tscn").instantiate())
	self.get_parent().get_parent().queue_free()
	
