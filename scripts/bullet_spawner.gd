extends MultiplayerSpawner

@export var last: Node

func spawn_function() -> Node:
	last =  load(get_spawnable_scene(0)).instantiate()
	print(last)
	last.name = "snowball" + str(randi_range(00000000, 99999999))
	#await self.get_parent().get_parent().call_deferred("add_child", last)
	return last

func _ready() -> void:
	set_spawn_function(spawn_function)
