extends Node

@export var health_blue = 0
@export var health_red = 0

@export var match_time = 0
@export var match_state = "ongoing" # ongoing, paused

signal win(winner: String)
signal restart

func start_game():
	if !multiplayer.is_server(): return
	health_blue = 50
	health_red = 50
	match_time = 0
	for i in self.get_parent().get_node("flags").get_children():
		i.domination = 0
	$Timer.start()

func _on_timer_timeout() -> void:
	if !multiplayer.is_server(): return
	match_time += 1
	for i in self.get_parent().get_node("flags").get_children():
		if i.domination < 0:
			health_red -= 1
		if i.domination > 0:
			health_blue -= 1
	if health_blue <= 0:
		health_blue = 0
		win_f.rpc("red")
		win_f("red")
	elif health_red <= 0:
		health_red = 0
		win_f.rpc("blue")
		win_f("blue")

func _ready() -> void:
	await get_tree().process_frame
	game_server_handler_class.game_server_handler = self
	if multiplayer.is_server():
		start_game()


@rpc("any_peer") func win_f(team):
	win.emit(team)
	get_tree().create_timer(20).timeout.connect(func(): restart.emit())
	if !multiplayer.is_server(): return
	$Timer.stop()
	await get_tree().create_timer(20).timeout
	
	start_game()
