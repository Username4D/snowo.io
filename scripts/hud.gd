extends Node2D

func _process(delta: float) -> void:
	$ammo.text = "AMMO: " + var_to_str(self.get_parent().ammo)
	if game_server_handler_class.game_server_handler:
		$red_hp.text = str(game_server_handler_class.game_server_handler.health_red)
		$blue_hp.text = str(game_server_handler_class.game_server_handler.health_blue)
		$time.text = str(floori(game_server_handler_class.game_server_handler.match_time / 60)) + ":" + str(game_server_handler_class.game_server_handler.match_time % 60)
	if multiplayer.is_server():
		$room_id_display.text = "ROOM: " + str(multiplayer_handler.peer.online_id)
