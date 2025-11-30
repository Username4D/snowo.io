extends Node2D

func pop_up(team: String):
	self.visible = true
	match team:
		"red":
			$borders_blue.visible = false
			$borders_red.visible = true
			$red_win_label.visible = true
			$blue_win_label.visible = false
		"blue":
			$borders_blue.visible = true
			$borders_red.visible = false
			$red_win_label.visible = false
			$blue_win_label.visible = true
	await game_server_handler_class.game_server_handler.restart
	self.visible = false
