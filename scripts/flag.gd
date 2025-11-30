extends Area3D

@export var domination = 0 # -1: blue, 1: red

func _physics_process(delta: float) -> void:
	var red_entries = 0
	var blue_entries = 0
	
	for i in get_overlapping_bodies():
		if i.is_in_group("player"):
			match i.team:
				"red":
					red_entries += 1
				"blue":
					blue_entries += 1
	
	if red_entries > blue_entries:
		domination = move_toward(domination, 1, delta * 1)
	elif blue_entries > red_entries:
		domination = move_toward(domination, -1, delta * 1)
	
	if domination > 0:
		$floor_mesh.get_surface_override_material(0).albedo_color = Color(1, 1 - domination, 1 - domination, 0.3)
	if domination < 0:
		$floor_mesh.get_surface_override_material(0).albedo_color = Color(1 + domination, 1 + domination, 1, 0.3)
	if domination == 0:
		$floor_mesh.get_surface_override_material(0).albedo_color = Color(1, 1, 1, 0.3)
