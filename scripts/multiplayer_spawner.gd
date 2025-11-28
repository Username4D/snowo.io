extends MultiplayerSpawner

@export var player_character: PackedScene
@export var snowball: PackedScene

func _ready() -> void:
	multiplayer.peer_connected.connect(spawn_player)
	
func spawn_player(id: int):
	if !multiplayer.is_server(): return
	print("connected")
	var player: Node = player_character.instantiate()
	player.name = str(id)
	print(id)
	get_node(spawn_path).call_deferred("add_child", player)

func spawn_snowball(origin: int):
	if !multiplayer.is_server(): return
	print("ohh")
	var ball = snowball.instantiate()
	ball.origin = origin
