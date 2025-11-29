extends MultiplayerSpawner

var red_players = []
var blue_players = []
 

@export var player_character: PackedScene
@export var snowball: PackedScene

func _ready() -> void:
	multiplayer.peer_connected.connect(spawn_player)
	multiplayer.peer_disconnected.connect(destroy_player)
	
func spawn_player(id: int):
	if !multiplayer.is_server(): return
	print("connected")
	var player: Node = player_character.instantiate()
	player.name = str(id)
	var player_team = "red" if len(blue_players) > len(red_players) else "blue"

	if len(blue_players) > len(red_players):
		red_players.append(id)
	else:
		blue_players.append(id)
	await get_node(spawn_path).call_deferred("add_child", player)
	update_player_team.rpc(id, player_team)
	update_player_team(id, player_team)
func destroy_player(id: int):
	if !multiplayer.is_server(): return
	if get_node(spawn_path).get_node(str(id)).team == "red":
		red_players.erase(id)
	else:
		blue_players.erase(id)
	get_node(spawn_path).get_node(str(id)).queue_free()

@rpc("any_peer") func update_player_team(id, team):
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	print(get_node(spawn_path).get_children())
	if get_node(spawn_path).get_node(str(id)):
		print(team)
		get_node(spawn_path).get_node(str(id)).team = team
	else:
		print("not switced to team " + team)
